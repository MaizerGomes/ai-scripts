#!/usr/bin/env bash

# fetch_api_usage.sh - Fetch usage metrics from AI provider APIs

# Helper for JSON output
json_null() { echo "null"; }

# OpenAI Usage (Daily)
fetch_openai_usage() {
    local key="$OPENAI_API_KEY"
    if [ -z "$key" ]; then json_null; return 0; fi
    
    local date=$(date +%Y-%m-%d)
    curl -s "https://api.openai.com/v1/usage?date=$date" \
      -H "Authorization: Bearer $key" || json_null
}

# Anthropic Usage (requires Admin API Key)
fetch_anthropic_usage() {
    local key="$ANTHROPIC_API_KEY"
    if [[ -z "$key" || ! "$key" =~ ^sk-ant-admin ]]; then json_null; return 0; fi
    
    local start_date=$(date -u -v-1d +%Y-%m-%dT00:00:00Z)
    curl -s "https://api.anthropic.com/v1/organizations/usage_report/messages?starting_at=$start_date&bucket_width=1d" \
      -H "anthropic-version: 2023-06-01" \
      -H "x-api-key: $key" || json_null
}

# Ollama Local Models
fetch_ollama_status() {
    if ! command -v ollama >/dev/null 2>&1; then json_null; return 0; fi
    
    # Check if ollama list has any models (skip header)
    local models=$(ollama list | tail -n +2)
    if [ -z "$models" ]; then
        echo "[]"
    else
        # Manually parse ollama list to JSON array
        echo "["
        first=1
        while read -r name id size modified; do
            if [ $first -ne 1 ]; then echo ","; fi
            echo -n "    { \"name\": \"$name\", \"id\": \"$id\", \"size\": \"$size\", \"modified\": \"$modified\" }"
            first=0
        done <<< "$models"
        echo
        echo "  ]"
    fi
}

# Main execution
echo "{"
echo "  \"timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
echo -n "  \"openai\": "
fetch_openai_usage
echo ","
echo -n "  \"anthropic\": "
fetch_anthropic_usage
echo ","
echo -n "  \"ollama\": "
fetch_ollama_status
echo
echo "}"
