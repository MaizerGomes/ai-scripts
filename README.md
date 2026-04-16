# 🤖 AI Scripts & Utils 🛠️

A collection of high-performance Bash utilities for interacting with AI CLI agents, monitoring API usage, and managing Cloudflare DNS failover.

---

## 🌟 Quick Look

| Component | Description | Highlights |
| :--- | :--- | :--- |
| **[AI Selector](./aiOptions)** | Interactive AI Agent Hub | Auto-detection, Usage Stats, Smart Sorting |
| **[AI Usage](./aiUsage)** | Real-time Dashboard | Cost Tracking, API Quotas, Tool Detection |
| **[Cloudflare Switch](./cloudflareDnsSwitch)** | DNS Failover Utility | Surgical IP Switching, Auto-Failover, Protected Records |

---

## 🚀 Components

### 🕵️‍♂️ AI Agent Selector (`aiOptions/`)
An interactive terminal menu to select and launch your favorite AI CLI agent. It remembers your last-used tool per directory and tracks daily usage.
- **Auto-detection**: Finds Claude, Cursor, Codex, Gemini, Ollama, and more.
- **Smart Order**: Agents are sorted by today's usage frequency.
- **Persistent**: Remembers your preferred tool for each workspace.
- **Usage**: `bash aiOptions/ai-selector.sh`

### 📊 AI Usage Dashboard (`aiUsage/`)
A comprehensive terminal UI to monitor your AI ecosystem.
- **API Metrics**: Live usage from OpenAI and Anthropic.
- **Key Status**: Automatically detects and masks your API keys.
- **Local Stats**: Integration with `ollama` and database-backed CLI tools.
- **Usage**: `cd aiUsage && bash ai-usage.sh`

### ☁️ Cloudflare DNS Switcher (`cloudflareDnsSwitch/`)
A robust utility to manage DNS failover between redundant firewalls or multi-homed setups.
- **Auto-Failover**: Pings targets to decide the best IP to route traffic.
- **Protected Records**: Safeguards critical infrastructure from accidental updates.
- **Seamless Auth**: Interactive setup for Cloudflare API tokens.
- **Usage**: `./switch-ip.sh domain.com old_ip new_ip [auto|manual]`

---

## 🛠️ System Dependencies

The scripts rely on these standard Unix/Linux utilities:

- `curl`: Network requests to AI and Cloudflare APIs.
- `jq`: Advanced JSON processing for API responses.
- `sqlite3`: Parsing local usage databases (e.g., `mods`, `aichat`).
- `tput`: Advanced terminal UI formatting and positioning.
- `bc`: Precise floating-point calculations for cost estimations.
- `gum`: (Optional) Enhanced interactive UI elements.

---

## 🔒 Security & Privacy

- **Zero Hardcoded Secrets**: All API keys are sourced from environment variables or ignored config files.
- **Local State**: State and usage data are stored in `$HOME/.ai-selector` and `.remember/`.
- **Sensitive Files**: `.gitignore` is pre-configured to exclude `cloudflare_keys` and `conductor` plans.

---

## 📝 License
Built for efficiency and speed. Use responsibly and keep your API keys safe! 🚀
