# 🕵️‍♂️ AI Agent Selector

An interactive terminal menu for selecting and launching AI CLI agents.

---

## ✨ Features

- **🚀 Smart Detection**: Automatically finds installed agents like `claude`, `cursor`, `gemini`, `ollama`, and more.
- **📈 Sorted by Usage**: Agents you use most today appear at the top of the list.
- **🧠 Directory Memory**: Remembers which agent you used last in each directory (perfect for different projects).
- **⌨️ Keyboard Driven**: Use arrow keys, number keys (1-9), or Enter to select.
- **🎨 Interactive UI**: A clean, color-coded menu with icons and usage stats.

---

## 🚀 Quick Start

Launch the selector from any directory:

```bash
bash aiOptions/ai-selector.sh
```

### Controls

| Key | Action |
| :--- | :--- |
| **Up/Down** | Move selection |
| **1-9** | Jump directly to agent |
| **Enter** | Launch selected agent |
| **q** | Quit |

---

## 🛠️ How it Works

1. **Detection**: Checks your `$PATH` for pre-configured AI CLI tools.
2. **State**: Stores last-used command and usage counts in `~/.ai-selector`.
3. **Execution**: Once selected, the script `exec`s the agent, passing any additional arguments you provided.

---

## 🤖 Supported Agents

- **Cloud**: Claude, Cursor, Codex, Gemini, Copilot
- **Local**: Ollama
- **Mixed/Utils**: aichat, mods, tgpt, opencode

---

## 📝 Customization

You can add or remove agents by editing the `potential_agents` array in `ai-selector.sh`:

```bash
potential_agents=(
  "My Agent|my-agent-cmd|🔥|Cloud"
)
```
