#!/bin/bash
set -e

echo "=== Ubuntu Coder Container Setup ==="

echo "=== Coder Configuration ==="
echo "CODER_ACCESS_URL: ${CODER_ACCESS_URL:-'Not set - will use tunnel'}"
echo "CODER_DATA: ${CODER_DATA}"

# Ensure directories exist with correct permissions
mkdir -p "$CODER_DATA"
chown -R coder:coder /home/coder/.config 2>/dev/null || true

echo "=== Starting Coder Server ==="
exec coder server
