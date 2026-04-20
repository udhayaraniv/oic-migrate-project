#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${1:?base url required}"
INSTANCE_NAME="${2:?instance name required}"
ACCESS_TOKEN="${3:?access token required}"

URL="${BASE_URL}/ic/api/integration/v1/gitprojects?integrationInstance=${INSTANCE_NAME}"

curl -sS \
  -X GET \
  -H "Authorization: Bearer ${ACCESS_TOKEN}" \
  -H "Accept: application/json" \
  "${URL}"
