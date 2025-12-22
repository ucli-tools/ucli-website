#!/bin/bash

# UCLI Tools DNS Setup Script
#
# This script configures DNS A records for ucli.tools to point to GitHub Pages
# using the Name.com API.
#
# Requirements:
# - curl (usually pre-installed)
# - jq (install with: apt-get install jq or similar)
# - .env file with Name.com credentials
#
# Setup:
# 1. Copy .env.example to .env
# 2. Fill in your Name.com API credentials
# 3. Run: bash scripts/setup_dns.sh

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
NAMECOM_API_BASE="https://api.name.com/v4"
GITHUB_PAGES_A_RECORDS=(
    "185.199.108.153"
    "185.199.109.153"
    "185.199.110.153"
    "185.199.111.153"
)

# Load environment variables
if [[ ! -f ".env" ]]; then
    echo -e "${RED}❌ Missing .env file${NC}"
    echo "Please copy .env.example to .env and fill in your Name.com credentials"
    exit 1
fi

source .env

# Validate required variables
if [[ -z "${NAMECOM_USERNAME:-}" ]] || [[ -z "${NAMECOM_API_TOKEN:-}" ]]; then
    echo -e "${RED}❌ Missing required environment variables${NC}"
    echo "Please ensure NAMECOM_USERNAME and NAMECOM_API_TOKEN are set in .env"
    exit 1
fi

DOMAIN="${DOMAIN:-ucli.tools}"
DNS_TTL="${DNS_TTL:-300}"

echo -e "${BLUE}🔧 Setting up DNS for ${DOMAIN}${NC}"
echo -e "${BLUE}📋 Target A records: ${GITHUB_PAGES_A_RECORDS[*]}${NC}"
echo

# Function to make API calls
api_call() {
    local method="$1"
    local url="$2"
    local data="${3:-}"

    local headers=""
    if [[ -n "${SESSION_TOKEN:-}" ]]; then
        headers="-H \"Api-Session-Token: $SESSION_TOKEN\""
    fi

    local curl_cmd="curl -s -X $method"
    if [[ -n "$data" ]]; then
        curl_cmd="$curl_cmd -H 'Content-Type: application/json' -d '$data'"
    fi
    if [[ -n "$headers" ]]; then
        curl_cmd="$curl_cmd $headers"
    fi
    curl_cmd="$curl_cmd '$url'"

    eval "$curl_cmd"
}

# Login to Name.com API
echo -e "${BLUE}🔐 Logging in to Name.com API...${NC}"

login_response=$(api_call "POST" "$NAMECOM_API_BASE/login" "{
    \"username\": \"$NAMECOM_USERNAME\",
    \"api_token\": \"$NAMECOM_API_TOKEN\"
}")

session_token=$(echo "$login_response" | jq -r '.session_token // empty')

if [[ -z "$session_token" ]]; then
    echo -e "${RED}❌ Login failed${NC}"
    echo "Response: $login_response"
    exit 1
fi

SESSION_TOKEN="$session_token"
echo -e "${GREEN}✅ Successfully logged in to Name.com API${NC}"

# Get existing DNS records
echo -e "\n${BLUE}📋 Checking existing DNS records...${NC}"

records_response=$(api_call "GET" "$NAMECOM_API_BASE/domains/$DOMAIN/records")

if [[ $? -ne 0 ]]; then
    echo -e "${RED}❌ Failed to get DNS records${NC}"
    exit 1
fi

# Extract A records for the root domain (@)
existing_a_records=$(echo "$records_response" | jq -r '.records[] | select(.type == "A" and .host == "") | .id')

if [[ -n "$existing_a_records" ]]; then
    echo -e "${YELLOW}🗑️  Removing existing A record(s) for @${NC}"

    while IFS= read -r record_id; do
        if [[ -n "$record_id" ]]; then
            delete_response=$(api_call "DELETE" "$NAMECOM_API_BASE/domains/$DOMAIN/records/$record_id")

            if [[ $? -eq 0 ]]; then
                echo -e "${GREEN}✅ Deleted DNS record ID: $record_id${NC}"
            else
                echo -e "${RED}❌ Failed to delete DNS record ID: $record_id${NC}"
            fi
        fi
    done <<< "$existing_a_records"
fi

# Create new A records
echo -e "\n${BLUE}➕ Creating new A records for GitHub Pages...${NC}"

success_count=0
total_records=${#GITHUB_PAGES_A_RECORDS[@]}

for ip in "${GITHUB_PAGES_A_RECORDS[@]}"; do
    create_response=$(api_call "POST" "$NAMECOM_API_BASE/domains/$DOMAIN/records" "{
        \"type\": \"A\",
        \"host\": \"\",
        \"answer\": \"$ip\",
        \"ttl\": $DNS_TTL
    }")

    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✅ Created A record: @ -> $ip${NC}"
        ((success_count++))
    else
        echo -e "${RED}❌ Failed to create A record for $ip${NC}"
        echo "Response: $create_response"
    fi
done

echo -e "\n${GREEN}🎉 DNS setup complete! $success_count/$total_records records created${NC}"

if [[ $success_count -eq $total_records ]]; then
    echo -e "\n${GREEN}✅ Your domain should be ready in 5-10 minutes${NC}"
    echo -e "${GREEN}🌐 Visit: https://$DOMAIN${NC}"
else
    echo -e "\n${YELLOW}⚠️  Some records failed to create. Please check your configuration.${NC}"
fi
