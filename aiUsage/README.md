# 📊 AI Usage Dashboard

A terminal-based monitoring tool for your AI CLI ecosystem.

---

## ✨ Features

- **✅ Tool Detection**: Scans your `$PATH` for installed AI tools (`mods`, `aichat`, `ollama`, etc.).
- **🔐 Key Monitoring**: Checks for available API keys and provides masked previews.
- **📈 Live API Quotas**: Fetches real-time usage metrics from OpenAI and Anthropic APIs.
- **🐚 Local Model Status**: Lists active models and versions from your local `ollama` instance.
- **🔄 Auto-Refresh**: Interactive dashboard that can be refreshed with any key.

---

## 🚀 Quick Start

From the root directory:

```bash
cd aiUsage
bash ai-usage.sh
```

---

## 🧩 Scripts

| Script | Purpose |
| :--- | :--- |
| **`ai-usage.sh`** | The main interactive dashboard entry point. |
| **`detect_tools.sh`** | Generates a JSON map of installed tools and API keys. |
| **`fetch_api_usage.sh`** | Retrieves usage data from cloud and local providers. |

---

## 🛠️ Requirements

The dashboard uses:
- `curl` for API requests.
- `jq` to parse and format JSON data.
- `tput` for terminal UI and colors.
- `ollama` (optional) for local model status.

---

## 📝 Configuration

The dashboard automatically checks for these environment variables:

- `OPENAI_API_KEY`: Required for OpenAI usage metrics.
- `ANTHROPIC_API_KEY`: Required for Anthropic usage (must be an **Admin Key**).
- `GOOGLE_API_KEY` / `GEMINI_API_KEY`: Used for Gemini-related tools.

---

## 📂 Data Storage

This script reads data from external APIs and local CLI tool databases (if available). It does not store any persistent usage data itself beyond the current session's display.
