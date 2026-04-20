#!/usr/bin/env bash
set -euo pipefail

TOKEN_URL="${1:?token url required}"
CLIENT_ID="${2:?client id required}"
CLIENT_SECRET="${3:?client secret required}"
SCOPE="${4:-}"

if [ -n "${SCOPE}" ]; then
  POST_DATA="grant_type=client_credentials&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&scope=${SCOPE}"
else
  POST_DATA="grant_type=client_credentials&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}"
fi

RESPONSE="$(curl -sS -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "${POST_DATA}" \
  "${TOKEN_URL}")"

ACCESS_TOKEN="$(echo "${RESPONSE}" | jq -r '.access_token // empty')"

if [ -z "${ACCESS_TOKEN}" ]; then
  echo "Token request failed" >&2
  echo "${RESPONSE}" >&2
  exit 1
fi

echo "${ACCESS_TOKEN}"
