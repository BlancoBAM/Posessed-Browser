#!/bin/bash
# ==============================================================================
# GCP Accelerated Builder for Posessed Browser
# ==============================================================================
# This script provisions a high-performance Google Cloud VM (n2d-standard-64),
# downloads the Chromium source, performs deep internal branding replacement for
# "Posessed Browser", compiles the AppImage & DEB binaries, and saves them.
#
# RUN THIS FROM GOOGLE CLOUD SHELL:
# curl -sOL https://raw.githubusercontent.com/BlancoBAM/Posessed-Browser/main/scripts/gcp-build.sh && bash gcp-build.sh
# ==============================================================================

PROJECT_ID=$(gcloud config get-value project)
ZONE="us-central1-a"
INSTANCE_NAME="posessed-browser-builder"
MACHINE_TYPE="n2d-standard-64" # 64 vCPUs, 256GB RAM for extremely fast Chromium builds
DISK_SIZE="300GB"              # Chromium src checkout requires ~100GB
DISK_TYPE="pd-ssd"

echo "========================================================================"
echo " Starting GCP Provisioning for Posessed Browser Deep Compilation"
echo "========================================================================"
echo "Project: $PROJECT_ID"
echo "Machine: $MACHINE_TYPE"
echo "Disk:    $DISK_SIZE $DISK_TYPE"
echo "========================================================================"

# 1. Provide a startup script that runs ON the VM automatically
cat <<'EOF' >/tmp/startup.sh
#!/bin/bash
# Log everything
exec > /var/log/posessed-browser-build.log 2>&1
set -x

# Update and install dependencies
sudo apt-get update
sudo apt-get install -y git python3 python3-pip curl wget unzip zip jq
sudo apt-get install -y build-essential libnss3-dev libcups2-dev libdrm-dev \
    libxkbcommon-dev libxcomposite-dev libxcursor-dev libxdamage-dev \
    libxrandr-dev libgbm-dev libasound2-dev libpci-dev libpangocairo-1.0-0 \
    libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0

WORK_DIR="/home/builder"
mkdir -p $WORK_DIR
cd $WORK_DIR

# Install depot_tools (required for Chromium)
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH="$WORK_DIR/depot_tools:$PATH"

# Clone Posessed Browser source
git clone https://github.com/BlancoBAM/Posessed-Browser.git
cd Posessed-Browser

# Install the Python build manager (uv)
curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh
uv build

# Setup the build environment (downloads ~100GB of Chromium src)
# This uses the BrowserOS core CLI which wraps `gclient sync`
cd packages/browseros
uv run browseros checkout

# ============================================================================
# DEEP REBRANDING (THE MAGIC SAUCE)
# ============================================================================
echo "Applying Deep Branding Replacement (BrowserOS -> Posessed Browser)..."
SRC_DIR="src" # Chromium checkout directory

# Replace hardcoded UI strings in C++ & GRD (UI/Localization) files
find $SRC_DIR/chrome/browser/browseros -type f -name "*.cc" -o -name "*.h" -o -name "*.grd*" -exec sed -i 's/BrowserOS/Posessed Browser/g' {} +
find $SRC_DIR/chrome/browser/browseros -type f -name "*.cc" -o -name "*.h" -o -name "*.grd*" -exec sed -i 's/Browser OS/Posessed Browser/g' {} +

# Replace the internal help & website URLs
find $SRC_DIR/chrome/browser/browseros -type f -exec sed -i 's|docs.browseros.com|github.com/BlancoBAM/Posessed-Browser/wiki|g' {} +
find $SRC_DIR/chrome/browser/browseros -type f -exec sed -i 's|browseros.com|github.com/BlancoBAM/Posessed-Browser|g' {} +

# Inject the Lilith Logo directly into the Chromium build assets
# Chromium uses specific icon sizes in `chrome/app/theme/default_100_percent/`
for size in 16 24 32 48 64 128 256; do
    # Assuming standard image resizing via imagemagick
    sudo apt-get install -y imagemagick
    convert /home/builder/Posessed-Browser/docs/logo/posessed-browser-logo.png -resize ${size}x${size} $SRC_DIR/chrome/app/theme/default_100_percent/browseros/posessed_logo_${size}.png
    # Replace references to browseros_logo directly
    find $SRC_DIR/chrome/app -name "*.grd*" -exec sed -i 's/browseros_logo_/posessed_logo_/g' {} +
done

# ============================================================================
# COMPILATION
# ============================================================================
echo "Starting extremely fast 64-core compilation..."
# Standard BrowserOS build command leverages all available cores
uv run browseros build

# Package the binaries
uv run browseros package --appimage --deb

# Export artifacts to a Google Cloud Storage bucket
gsutil cp out/Release/*.AppImage gs://$PROJECT_ID-browser-builds/
gsutil cp out/Release/*.deb gs://$PROJECT_ID-browser-builds/
gsutil cp out/Release/*.zip gs://$PROJECT_ID-browser-builds/

# Shut down the VM to save money
sudo poweroff
EOF

echo "Creating Cloud Storage Bucket for artifacts..."
gcloud storage buckets create gs://$PROJECT_ID-browser-builds --location=US || true

echo "Provisioning Build VM ($INSTANCE_NAME)..."
gcloud compute instances create $INSTANCE_NAME \
	--project=$PROJECT_ID \
	--zone=$ZONE \
	--machine-type=$MACHINE_TYPE \
	--network-interface=network-tier=PREMIUM,subnet=default \
	--maintenance-policy=MIGRATE \
	--provisioning-model=STANDARD \
	--scopes=https://www.googleapis.com/auth/cloud-platform \
	--create-disk=auto-delete=yes,boot=yes,device-name=$INSTANCE_NAME,image=projects/debian-cloud/global/images/debian-12-bookworm-v20240213,mode=rw,size=$DISK_SIZE,type=projects/$PROJECT_ID/zones/$ZONE/diskTypes/$DISK_TYPE \
	--metadata-from-file=startup-script=/tmp/startup.sh

echo "========================================================================"
echo " Successfully launched the 64-Core Build Server!"
echo " The server is downloading Chromium, patching the internal UI, and building."
echo " When finished, the VM will auto-delete and the binaries will appear in:"
echo " https://console.cloud.google.com/storage/browser/$PROJECT_ID-browser-builds"
echo "========================================================================"
