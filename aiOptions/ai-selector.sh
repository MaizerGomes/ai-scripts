#!/bin/bash

# Configuration: (display_name|command|icon|type)
potential_agents=(
  "Claude|claude|❄️|Cloud"
  "Cursor|cursor-agent|🚀|Cloud"
  "Codex|codex|📖|Cloud"
  "Openclaw|openclaw|🦀|Cloud"
  "Opencode|opencode|📂|Cloud"
  "Gemini|gemini|♊|Cloud"
  "Copilot|copilot|🤖|Cloud"
  "Ollama|ollama|🦙|Local"
  "Aichat|aichat|💬|Mix"
  "Mods|mods|🛠️|Mix"
  "Tgpt|tgpt|🌐|Free"
)

STATE_DIR="$HOME/.ai-selector"
mkdir -p "$STATE_DIR"
# Generate a unique cache file for the current directory
DIR_HASH=$(echo -n "$PWD" | md5 | cut -c1-8)
CACHE_FILE="$STATE_DIR/last_cmd_$DIR_HASH"
USAGE_FILE="$STATE_DIR/usage_$(date +%Y-%m-%d)"

# Helper to get usage
get_usage() {
  grep "^$1:" "$USAGE_FILE" 2>/dev/null | cut -d: -f2 || echo "0"
}

# Detect available agents and gather their stats for sorting
available_data=()
for item in "${potential_agents[@]}"; do
  IFS='|' read -r name cmd icon type <<< "$item"
  if command -v "$cmd" >/dev/null 2>&1; then
    usage=$(get_usage "$cmd")
    available_data+=("$usage|$name|$cmd|$icon|$type")
  fi
done

[ ${#available_data[@]} -eq 0 ] && echo "No AI CLI agents found." && exit 1

# Sort agents by usage (descending)
# Sorting logic: numeric reverse (usage), then name
IFS=$'\n' sorted_data=($(sort -t'|' -k1,1rn -k2,2 <<<"${available_data[*]}"))
unset IFS

options=()
commands=()
icons=()
types=()
usages=()

for line in "${sorted_data[@]}"; do
  IFS='|' read -r usage name cmd icon type <<< "$line"
  options+=("$name")
  commands+=("$cmd")
  icons+=("$icon")
  types+=("$type")
  usages+=("$usage")
done

# Load state (last command used in this directory)
last_cmd=$(cat "$CACHE_FILE" 2>/dev/null)
selected=0
for i in "${!commands[@]}"; do
  [[ "${commands[$i]}" == "$last_cmd" ]] && selected=$i
done

cleanup() {
  tput rc   # Restore cursor to start of menu
  tput ed   # Clear the menu area one last time
  tput cnorm # Show cursor
  stty echo
}
trap cleanup EXIT

tput civis # Hide cursor
stty -echo

show_menu() {
  local out=""
  out+="\033[1;34m--- AI Agent Selector (\033[1;33m$(basename "$PWD")\033[1;34m) ---\033[0m\n"
  out+=$(printf "\033[0;90m%-20s %-10s %-10s\033[0m\n" "  Agent" "Type" "Today's Uses")
  out+="\n"

  for i in "${!options[@]}"; do
    local type_color="\033[0;36m"
    [[ "${types[$i]}" == "Cloud" ]] && type_color="\033[0;33m"
    
    local line=""
    if [ $i -eq $selected ]; then
      line=$(printf "\033[1;32m> %-2d. %s %-15s \033[0m %b%-10s\033[0m \033[1;32m[%s]\033[0m" \
        $((i+1)) "${icons[$i]}" "${options[$i]}" "$type_color" "${types[$i]}" "${usages[$i]}")
    else
      line=$(printf "  %-2d. %s %-15s %b%-10s\033[0m [%s]" \
        $((i+1)) "${icons[$i]}" "${options[$i]}" "$type_color" "${types[$i]}" "${usages[$i]}")
    fi
    out+="$line\n"
  done
  
  out+="\n\033[0;90m[Arrows/1-${#options[@]}] Select  [Enter] Launch  [q] Quit\033[0m"
  
  tput rc   # Restore cursor to saved position
  tput ed   # Clear from cursor to end of screen
  echo -en "$out"
}

# Save initial cursor position
tput sc
show_menu

while true; do
  read -rsn1 key
  case "$key" in
    $'\x1b')
      read -rsn2 key
      case "$key" in
        '[A') ((selected--)); [ $selected -lt 0 ] && selected=$((${#options[@]} - 1)) ;;
        '[B') ((selected++)) ; [ $selected -ge ${#options[@]} ] && selected=0 ;;
      esac
      ;;
    [1-9])
      if [ "$key" -le "${#options[@]}" ]; then
        selected=$((key - 1)); show_menu; break
      fi
      ;;
    "") break ;;
    q) exit 0 ;;
  esac
  show_menu
done

# Perform cleanup before execution
tput rc
tput ed
tput cnorm
stty echo

# Save last command
echo "${commands[$selected]}" > "$CACHE_FILE"

# Increment usage
current_usage=$(get_usage "${commands[$selected]}")
new_usage=$((current_usage + 1))
if grep -q "^${commands[$selected]}:" "$USAGE_FILE" 2>/dev/null; then
  sed -i '' "s/^${commands[$selected]}:.*/${commands[$selected]}:$new_usage/" "$USAGE_FILE"
else
  echo "${commands[$selected]}:$new_usage" >> "$USAGE_FILE"
fi

echo -e "\n\033[1;34mStarting ${icons[$selected]} ${options[$selected]}... (Usage today: $new_usage)\033[0m"
exec "${commands[$selected]}" "$@"
