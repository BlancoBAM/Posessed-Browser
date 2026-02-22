<div align="center">
<img width="300" alt="Posessed Browser Logo" src="docs/logo/posessed-browser-logo.png" />

# Posessed Browser

## _Let Lilim posess your browser._

**An open-source, AI-native Chromium fork — built for and bundled with [Lilith Linux](https://github.com/BlancoBAM/Lilith-Linux).**

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](LICENSE)
[![GitHub Releases](https://img.shields.io/github/v/release/BlancoBAM/Posessed-Browser?color=FF4500)](https://github.com/BlancoBAM/Posessed-Browser/releases)
[![Powered by Lilim](https://img.shields.io/badge/AI-Lilim-8B0000?logo=github)](https://github.com/BlancoBAM/Lilim)

<a href="https://github.com/BlancoBAM/Posessed-Browser/releases/latest">
  <img src="https://img.shields.io/badge/Download-Linux_AppImage-FF4500?style=flat&logo=linux&logoColor=white" alt="Download for Linux" />
</a>

</div>

---

## Overview

**Posessed Browser** is a Chromium fork with native AI agents baked in. It ships as the default browser of [Lilith Linux](https://github.com/BlancoBAM/Lilith-Linux), tightly integrated with [Lilim](https://github.com/BlancoBAM/Lilim) — an intelligent, locally-run AI system designed for the Lilith Linux ecosystem.

No cloud dependency. No subscriptions. Your data stays on your machine.

> **"Let Lilim posess your browser."**
> Lilim is the default AI brain — running locally, knowing your system, acting on your behalf.

---

## Features

| Feature                  | Description                                                              |
| ------------------------ | ------------------------------------------------------------------------ |
| 🧠 **Lilim Integration** | Powered by the Lilim AI system from Lilith Linux — runs 100% locally     |
| 🤖 **AI Agents**         | Describe any web task in plain English and watch it execute              |
| 🔒 **Privacy-First**     | No telemetry, no cloud processing, no data collection                    |
| 🔄 **Workflows**         | Build visual, repeatable browser automations                             |
| 📂 **Cowork**            | Combine browser automation with local file operations                    |
| ⏰ **Scheduled Tasks**   | Run agents on autopilot — daily, hourly, or every few minutes            |
| 💬 **LLM Hub**           | Compare multiple AI models side-by-side on any page                      |
| 🛡️ **Ad Blocker**        | Built-in uBlock Origin with Manifest V2 support                          |
| 🔌 **MCP Server**        | Control your browser from `claude-code`, `gemini-cli`, or any MCP client |
| ⚙️ **Chrome-Compatible** | All your extensions work. Import bookmarks and passwords in one click    |

---

## Lilim — The Default AI

Posessed Browser ships with **[Lilim](https://github.com/BlancoBAM/Lilim)** as its default AI provider, no API key required when running on Lilith Linux.

Lilim is a locally-run intelligent assistant built specifically for the Lilith Linux environment. It handles:

- Browser automation and agent tasks
- Page summarization and chat
- Multi-step workflows
- System-aware operations (file access, terminal, search)

> As Lilim evolves and Lilith Linux matures, Posessed Browser will automatically improve — deeper integrations, smarter agents, and faster responses are on the roadmap.

---

## AI Model Options

Posessed Browser supports multiple AI providers. Pick the one that works for you:

| Provider              | Models                        | Notes                                       |
| --------------------- | ----------------------------- | ------------------------------------------- |
| **Lilim** _(default)_ | Lilim (local)                 | Bundled with Lilith Linux — no key required |
| **Ollama**            | Llama 3, Mistral, Gemma, etc. | Free, runs locally                          |
| **LM Studio**         | Any GGUF model                | Free, runs locally                          |
| **Claude**            | Opus, Sonnet, Haiku           | Best for agentic tasks                      |
| **OpenAI**            | GPT-4o, o1, o3-mini           | Widely supported                            |
| **Gemini**            | Flash, Pro                    | Fast and affordable                         |
| **Azure OpenAI**      | GPT-4o via Azure              | Enterprise option                           |
| **AWS Bedrock**       | Claude on Bedrock             | Enterprise option                           |
| **OpenAI-Compatible** | Any endpoint                  | Custom API servers                          |

Configure your provider from the browser's **Settings → AI Provider** page.

---

## Quick Start

### On Lilith Linux

Posessed Browser comes pre-installed. Lilim is automatically configured — just open the browser and start using AI features immediately.

### On Other Systems

1. **Download** the latest AppImage release from [GitHub Releases](https://github.com/BlancoBAM/Posessed-Browser/releases)
2. **Make Executable & Run** — `chmod +x Posessed-Browser.AppImage && ./Posessed-Browser.AppImage`
3. **Import from Chrome** — go to `chrome://settings/importData`
4. **Configure AI** — go to **Settings → AI Provider** and add your API key, or [set up Ollama](https://ollama.com) for free local models
5. **Start** — press the **Assistant** button in your toolbar

---

## Why Posessed Browser?

> _"For the first time since Netscape, AI gives us the chance to completely reimagine the browser."_

Most browsers haven't changed fundamentally in a decade. Posessed Browser is built for the AI era:

- **You juggle 70+ tabs** — Posessed Browser gives you an agent to handle the tedious ones
- **Routine tasks are automated** — form fills, data extraction, research, scheduling
- **Your data is yours** — everything runs locally; nothing is sent to our servers
- **Open source** — inspect it, fork it, trust it

---

## For Lilith Linux Users

Posessed Browser is a **first-class citizen** of the Lilith Linux ecosystem:

- Ships as the **default browser** in Lilith Linux
- **Lilim is pre-configured** — no setup required
- **System-aware** — Lilim can access your filesystem, terminal, and system state
- **In Lilith Linux's official repos** — system updates (`apt upgrade`) deliver the latest Posessed Browser. Standalone releases are also published independently on [GitHub Releases](https://github.com/BlancoBAM/Posessed-Browser/releases)

As Lilim and Lilith Linux grow, expect Posessed Browser to grow with them:

- Smarter, faster local inference
- Deeper system integration
- More powerful agentic capabilities

---

## Contributing

Built on Chromium, Posessed Browser has two areas to contribute to:

- **Agent** — AI features, UI, and browser automation (`TypeScript/React`)
- **Browser** — Chromium patches and build system (`C++/Python`)

See [CONTRIBUTING.md](CONTRIBUTING.md) for full setup instructions.

Quick links:

- 🐛 [Report a bug](https://github.com/BlancoBAM/Posessed-Browser/issues)
- 💡 [Request a feature](https://github.com/BlancoBAM/Posessed-Browser/issues)
- 🔀 [Open a pull request](https://github.com/BlancoBAM/Posessed-Browser/pulls)

---

## Architecture

```text
Posessed Browser
├── packages/
│   ├── browseros/              # Chromium build system & patches
│   └── browseros-agent/        # AI agent Chrome extension
├── docs/                       # Documentation
└── README.md
```

The AI agent runs as a Chrome extension, with a local Bun server handling the agent loop, MCP tool calls, and API communication. On Lilith Linux, this connects directly to the local Lilim backend.

---

## Credits

- **[Lilim](https://github.com/BlancoBAM/Lilim)** — The AI backbone powering Posessed Browser on Lilith Linux
- **[Lilith Linux](https://github.com/BlancoBAM/Lilith-Linux)** — The OS this browser calls home
- **[ungoogled-chromium](https://github.com/ungoogled-software/ungoogled-chromium)** — Privacy patches
- **[The Chromium Project](https://www.chromium.org/)** — The foundation everything is built on

---

## License

Posessed Browser is open source under the [AGPL-3.0 license](LICENSE).

---

<p align="center">
  <img width="120" alt="Posessed Browser Logo" src="docs/logo/posessed-browser-logo.png" />
  <br/>
  <i>Let Lilim posess your browser.</i>
</p>
