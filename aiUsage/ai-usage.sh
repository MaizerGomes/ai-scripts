#!/usr/bin/env bash

# ai-usage.sh - Main entry point for the AI Usage Dashboard

# Colors
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Screen Dimensions
COLS=$(tput cols)
ROWS=$(tput lines)

draw_header() {
    clear
    local title="🤖 AI CLI USAGE DASHBOARD 📊"
    local padding=$(( (COLS - ${#title}) / 2 ))
    printf "${BLUE}${BOLD}%*s%s%*s${RESET}\n" "$padding" "" "$title" "$padding" ""
    printf "${BLUE}%*s${RESET}\n" "$COLS" | tr ' ' '━'
    echo
}

draw_section() {
    local title="$1"
    printf "${CYAN}${BOLD}▶ %s${RESET}\n" "$title"
}

show_tools() {
    draw_section "INSTALLED TOOLS"
    ./detect_tools.sh | jq -r '.tools[] | select(.installed == true) | "  ${GREEN}✓${RESET} \(.name) [\(.version)]"' | sed "s/\${GREEN}/$(tput setaf 2)/g; s/\${RESET}/$(tput sgr0)/g"
    ./detect_tools.sh | jq -r '.tools[] | select(.installed == false) | "  ${RED}✗${RESET} \(.name) (not installed)"' | sed "s/\${RED}/$(tput setaf 1)/g; s/\${RESET}/$(tput sgr0)/g"
    echo
}

show_keys() {
    draw_section "API KEYS"
    ./detect_tools.sh | jq -r '.keys[] | select(.available == true) | "  ${GREEN}✓${RESET} \(.name): \(.masked)"' | sed "s/\${GREEN}/$(tput setaf 2)/g; s/\${RESET}/$(tput sgr0)/g"
    # Show missing keys in a single line
    local missing=$(./detect_tools.sh | jq -r '.keys[] | select(.available == false) | .name' | paste -sd ", " -)
    if [ -n "$missing" ]; then
        printf "  ${RED}✗${RESET} Missing: %s\n" "$missing"
    fi
    echo
}

show_usage() {
    draw_section "USAGE SUMMARY"
    local usage_json=$(./fetch_api_usage.sh)
    
    # OpenAI
    local oai=$(echo "$usage_json" | jq -r '.openai')
    if [[ "$oai" != "null" && "$oai" != "" ]]; then
        echo "${GREEN}  OpenAI:${RESET}"
        echo "$oai" | jq -r '.data[] | "    - \(.model): \(.n_requests) requests"'
    else
        echo "  OpenAI: No data"
    fi
    
    # Ollama
    local olla=$(echo "$usage_json" | jq -r '.ollama')
    if [[ "$olla" != "null" && "$olla" != "[]" ]]; then
        echo "${MAGENTA}  Ollama (Local):${RESET}"
        echo "$olla" | jq -r '.[] | "    - \(.name) (\(.size))"'
    else
        echo "  Ollama (Local): No models found"
    fi
    echo
}

# Run loop
while true; do
    draw_header
    show_tools
    show_keys
    show_usage
    
    printf "${YELLOW}Press 'q' to quit, any other key to refresh...${RESET}"
    read -n 1 -s key
    if [[ "$key" == "q" ]]; then
        break
    fi
done

clear
