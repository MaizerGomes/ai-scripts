#!/bin/bash

# Cloudflare DNS IP Switcher
# Usage: ./switch-ip.sh <domain> <old_ip> <new_ip>

CONFIG_FILE="cloudflare_keys"

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <domain> <old_ip> <new_ip> [mode: manual|auto]"
    exit 1
fi

DOMAIN=$1
OLD_IP=$2
NEW_IP=$3
MODE=${4:-manual}

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found."
    echo "Please create a file named '$CONFIG_FILE' with the format 'domain:api_token' per line."
    exit 1
fi

# Function to check if an IP is online
is_online() {
    ping -c 1 -W 2 "$1" > /dev/null 2>&1
    return $?
}

# Determine source and target IPs
SOURCE_IP=$OLD_IP
TARGET_IP=$NEW_IP

if [ "$MODE" == "auto" ]; then
    echo "Auto-mode enabled. Checking IP status..."
    if is_online "$NEW_IP"; then
        echo "IP $NEW_IP is ONLINE."
        if is_online "$OLD_IP"; then
            echo "IP $OLD_IP is also ONLINE. Using default: $OLD_IP -> $NEW_IP"
        else
            echo "IP $OLD_IP is OFFLINE. Switching: $OLD_IP -> $NEW_IP"
        fi
        SOURCE_IP=$OLD_IP
        TARGET_IP=$NEW_IP
    elif is_online "$OLD_IP"; then
        echo "IP $OLD_IP is ONLINE but $NEW_IP is OFFLINE. Reverting/Staying: $NEW_IP -> $OLD_IP"
        SOURCE_IP=$NEW_IP
        TARGET_IP=$OLD_IP
    else
        echo "Error: Both IPs ($OLD_IP and $NEW_IP) are OFFLINE. Cannot perform switch."
        exit 1
    fi
fi

# Get API token for the domain
API_TOKEN=$(grep "^$DOMAIN:" "$CONFIG_FILE" 2>/dev/null | cut -d':' -f2)

if [ -z "$API_TOKEN" ]; then
    TOKEN_URL="https://dash.cloudflare.com/profile/api-tokens?permissionGroupGuid=dns&operator=and&permissionGuid=dns_records_edit"
    echo "--------------------------------------------------------"
    echo "No API token found for domain '$DOMAIN'."
    echo "Please create a token with 'DNS:Edit' permissions."
    echo ""
    echo "1. Go to: $TOKEN_URL"
    
    # Open browser automatically on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open "$TOKEN_URL"
        echo "(Opening your browser...)"
    fi
    
    echo ""
    echo "2. Once created, paste your API token here and press Enter:"
    read -r NEW_TOKEN
    
    if [ -z "$NEW_TOKEN" ]; then
        echo "No token provided. Exiting."
        exit 1
    fi
    
    # Save the token to the config file
    echo "$DOMAIN:$NEW_TOKEN" >> "$CONFIG_FILE"
    API_TOKEN=$NEW_TOKEN
    echo "Token saved to '$CONFIG_FILE' for future use."
    echo "--------------------------------------------------------"
fi

echo "Switching IP for domain '$DOMAIN' from '$SOURCE_IP' to '$TARGET_IP'..."

# 1. Get Zone ID
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$DOMAIN" \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" | jq -r '.result[0].id')

if [ -z "$ZONE_ID" ] || [ "$ZONE_ID" == "null" ]; then
    echo "Error: Could not find Zone ID for domain '$DOMAIN'. Check your API token and domain name."
    exit 1
fi

# 2. Get DNS Records with SOURCE_IP
RECORDS_JSON=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=A&content=$SOURCE_IP" \
     -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json")

RECORD_IDS=$(echo "$RECORDS_JSON" | jq -r '.result[].id')

if [ -z "$RECORD_IDS" ] || [ "$RECORD_IDS" == "" ]; then
    echo "No A records found with IP '$SOURCE_IP' for domain '$DOMAIN'."
    exit 0
fi

COUNT=0
for RECORD_ID in $RECORD_IDS; do
    RECORD_NAME=$(echo "$RECORDS_JSON" | jq -r ".result[] | select(.id == \"$RECORD_ID\") | .name")
    
    # Skip protected records
    case "$RECORD_NAME" in
        "matolaspar-s" | "matolaspar-s.$DOMAIN" | \
        "millenniump-s" | "millenniump-s.$DOMAIN" | \
        "matolaspar-p" | "matolaspar-p.$DOMAIN" | \
        "millenniump-p" | "millenniump-p.$DOMAIN")
            echo "Skipping protected record '$RECORD_NAME'..."
            continue
            ;;
    esac

    echo "Updating record '$RECORD_NAME' ($RECORD_ID)..."
    
    UPDATE_RESPONSE=$(curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
         -H "Authorization: Bearer $API_TOKEN" \
         -H "Content-Type: application/json" \
         --data "{\"content\":\"$TARGET_IP\"}")
    
    SUCCESS=$(echo "$UPDATE_RESPONSE" | jq -r '.success')
    
    if [ "$SUCCESS" == "true" ]; then
        echo "Successfully updated record '$RECORD_NAME' to '$TARGET_IP'."
        ((COUNT++))
    else
        ERROR_MSG=$(echo "$UPDATE_RESPONSE" | jq -r '.errors[0].message')
        echo "Failed to update record '$RECORD_NAME': $ERROR_MSG"
    fi
done

echo "Done. $COUNT records updated."
