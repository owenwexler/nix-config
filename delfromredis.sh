#!/usr/bin/env bash
# delete_redis_prefix.sh
# Usage: ./delete_redis_prefix.sh <prefix>
# Example: ./delete_redis_prefix.sh "session:"

# Exit immediately if any command fails
set -euo pipefail

# Check arguments
if [ $# -ne 1 ]; then
  echo "Usage: $0 <prefix>"
  exit 1
fi

PREFIX=$1

# Confirm action
echo "Deleting all Redis keys with prefix: '$PREFIX'"
read -p "Are you sure? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

# Use redis-cli to find and delete matching keys
# The KEYS command can be expensive; for large datasets, use SCAN instead
echo "Scanning Redis for keys..."
COUNT=0

# Use SCAN cursor-based iteration for safety
while IFS= read -r key; do
  redis-cli DEL "$key" >/dev/null
  ((COUNT++))
done < <(redis-cli --raw SCAN 0 MATCH "${PREFIX}*" COUNT 1000 | awk 'NR%2==0')

echo "Deleted $COUNT keys with prefix '${PREFIX}'."
