# AI Scripts

A collection of bash scripts for managing and interacting with AI CLI tools.

## Scripts

### `aiOptions/ai-selector.sh` — AI Agent Selector

An interactive terminal menu to select and launch an AI CLI agent. Remembers your last-used agent per directory and tracks daily usage counts.

**Features:**
- Auto-detects installed AI agents (Claude, Cursor, Codex, Gemini, Copilot, Ollama, aichat, mods, tgpt, and more)
- Sorts agents by today's usage
- Per-directory memory of your last-used agent
- Arrow keys, number keys, or Enter to select

**Usage:**
```bash
bash aiOptions/ai-selector.sh
```

---

### `aiUsage/` — AI Usage Dashboard

A terminal dashboard showing installed AI tools, API key status, and live usage metrics from provider APIs.

**Scripts:**
- `ai-usage.sh` — Main dashboard entry point (interactive, refreshable)
- `detect_tools.sh` — Detects installed AI CLI tools and API keys, outputs JSON
- `fetch_api_usage.sh` — Fetches usage data from OpenAI, Anthropic, and Ollama

**Usage:**
```bash
cd aiUsage
bash ai-usage.sh
```

Press any key to refresh, `q` to quit.

## Dependencies

| Tool | Purpose |
|------|---------|
| `curl` | API requests |
| `jq` | JSON processing |
| `tput` | Terminal UI formatting |
| `sqlite3` | Local DB parsing (mods, aichat) |
| `bc` | Cost calculations |
| `gum` | Interactive UI elements (optional) |

## Supported AI Tools

| Agent | Type |
|-------|------|
| Claude | Cloud |
| Cursor | Cloud |
| Codex | Cloud |
| Gemini | Cloud |
| Copilot | Cloud |
| Ollama | Local |
| aichat | Mix |
| mods | Mix |
| tgpt | Free |

## Supported API Keys

The dashboard checks for the following environment variables:

- `OPENAI_API_KEY`
- `ANTHROPIC_API_KEY`
- `GOOGLE_API_KEY` / `GEMINI_API_KEY`
- `PERPLEXITY_API_KEY`
- `MISTRAL_API_KEY`
- `GROQ_API_KEY`
