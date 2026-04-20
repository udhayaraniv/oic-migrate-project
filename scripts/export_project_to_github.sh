#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:?base url required}"
INSTANCE_NAME="${2:?instance name required}"
ACCESS_TOKEN="${3:?access token required}"
PROJECT_ID="${4:?project id required}"
PROJECT_LABEL="${5:-}"

URL="${BASE_URL}/ic/api/integration/v1/gitprojects/${PROJECT_ID}/exporttorepository?integrationInstance=${INSTANCE_NAME}"

TMP_BODY="$(mktemp)"
TMP_HEADERS="$(mktemp)"
TMP_JSON="$(mktemp)"
trap 'rm -f "$TMP_BODY" "$TMP_HEADERS" "$TMP_JSON"' EXIT

if [ -n "${PROJECT_LABEL}" ]; then
  cat > "${TMP_JSON}" <<EOF
{"label":"${PROJECT_LABEL}"}
EOF
else
  cat > "${TMP_JSON}" <<EOF
{}
EOF
fi

HTTP_CODE="$(curl -sS \
  -D "${TMP_HEADERS}" \
  -o "${TMP_BODY}" \
  -w "%{http_code}" \
  -X POST \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Content-Type: application/json" \
  --data @"${TMP_JSON}" \
  "${URL}")"

echo "HTTP status: ${HTTP_CODE}"
echo "Response headers:"
sed -n '1,80p' "${TMP_HEADERS}"

if [ "${HTTP_CODE}" != "200" ]; then
  echo "Export to repository failed. Response body:"
  cat "${TMP_BODY}"
  exit 1
fi

if [ -s "${TMP_BODY}" ]; then
  echo "Response body:"
  cat "${TMP_BODY}"
fi

echo "Export to GitHub repository completed for ${PROJECT_ID}"
