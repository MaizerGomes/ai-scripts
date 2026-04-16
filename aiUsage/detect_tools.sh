#!/usr/bin/env bash

# detect_tools.sh - Detect installed AI CLI tools and API keys

# List of tools to check
TOOLS=("mods" "aichat" "ollama" "sgpt" "tgpt" "gh" "gemini-cli")

# List of API keys to check
KEYS=("OPENAI_API_KEY" "ANTHROPIC_API_KEY" "GOOGLE_API_KEY" "GEMINI_API_KEY" "PERPLEXITY_API_KEY" "MISTRAL_API_KEY" "GROQ_API_KEY")

echo "{"
echo "  \"tools\": ["

first=1
for tool in "${TOOLS[@]}"; do
    if [ $first -ne 1 ]; then echo ","; fi
    if command -v "$tool" >/dev/null 2>&1; then
        path=$(command -v "$tool")
        version=$("$tool" --version 2>/dev/null | head -n 1 || "$tool" version 2>/dev/null | head -n 1 || echo "unknown")
        # Sanitize version string (remove quotes, etc.)
        version=$(echo "$version" | tr -d '"')
        echo -n "    { \"name\": \"$tool\", \"installed\": true, \"path\": \"$path\", \"version\": \"$version\" }"
    else
        echo -n "    { \"name\": \"$tool\", \"installed\": false }"
    fi
    first=0
done
echo
echo "  ],"

echo "  \"keys\": ["
first=1
for key in "${KEYS[@]}"; do
    if [ $first -ne 1 ]; then echo ","; fi
    if [ -n "${!key}" ]; then
        val="${!key}"
        masked="${val:0:4}...${val: -4}"
        echo -n "    { \"name\": \"$key\", \"available\": true, \"masked\": \"$masked\" }"
    else
        echo -n "    { \"name\": \"$key\", \"available\": false }"
    fi
    first=0
done
echo
echo "  ]"
echo "}"
