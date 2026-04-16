# Track 1: Setup & Discovery

## Goals
- Detect installed AI CLI tools (`mods`, `aichat`, `ollama`, `sgpt`, `tgpt`, `gh`, `gemini-cli`).
- Check for environment variables (API keys).
- Create a configuration file to store detected tools and keys (optional).

## Tasks
1. [ ] Check PATH for executable existence.
2. [ ] Check environment for `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GOOGLE_API_KEY`, etc.
3. [ ] Create `detect_tools.sh` script to output detected tools in JSON format.
