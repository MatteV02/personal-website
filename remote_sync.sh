#!/bin/bash

# Script: sync_website.sh
# Description:
#   Syncs only the files relevant to an Apache2 website from a local directory
#   to a remote server via SSH, excluding unnecessary files like .gitignore, README.md, etc.
#   Uses rsync for efficient and secure file transfer.
#
# Usage:
#   ./sync_website.sh [REMOTE_USER] [REMOTE_HOST]
#     REMOTE_USER: Remote server username (default: user)
#     REMOTE_HOST: Remote IP or hostname (default: server)
#
# Example:
#   ./sync_website.sh pi 192.168.1.100

# Default values
REMOTE_USER="${1:-user}"  # Default remote user: user
REMOTE_HOST="${2:-server}"    # Remote host (default: server)
LOCAL_DIR="."           # Current directory (your website root)
REMOTE_DIR="/var/www/html"  # Apache2 default web directory

# Check if REMOTE_HOST is provided
if [ -z "$REMOTE_HOST" ]; then
    echo "Error: REMOTE_HOST is required."
    echo "Usage: $0 [REMOTE_USER] [REMOTE_HOST]"
    exit 1
fi

# List of files/directories to exclude
EXCLUDE_LIST=(
    ".git/"
    ".vscode"
    ".gitignore"
    "README.md"
    "*.swp"
    "*.bak"
    "*.tmp"
    "*.log"
    "*.sh"
)

# Build the exclude arguments for rsync
EXCLUDE_ARGS=()
for item in "${EXCLUDE_LIST[@]}"; do
    EXCLUDE_ARGS+=(--exclude "$item")
done

# Sync files using rsync over SSH with sudo on the remote side
echo "Syncing website files to $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR..."
rsync -avz --delete --rsync-path="sudo rsync" "${EXCLUDE_ARGS[@]}" "$LOCAL_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

echo "Sync completed!"
