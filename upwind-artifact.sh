#!/bin/bash

### Getting auth token

# US Region:
#   auth_audience=https://agent.upwind.io
#   upwind_auth_endpoint=https://oauth.upwind.io/oauth/token
# EU Region:
#   auth_audience=https://agent.eu.upwind.io
#   upwind_auth_endpoint=https://oauth.eu.upwind.io/oauth/token

response="$("${CURL}" -fsSL -X POST \
    --data grant_type=client_credentials \
    --data "audience=${UPWIND_AUTH_AUDIENCE}" \
    --data "client_id=${UPWIND_CLIENT_ID}" \
    --data "client_secret=${UPWIND_CLIENT_SECRET}" \
    --url "${UPWIND_AUTH_ENDPOINT}" 2>&1)"
if [[ $? != 0 ]]; then
    printf "Unable to get auth token: %s" "${response}"
    exit 1
fi

token="$(echo "${response}" | ${JQ} -r .access_token)"
if [[ -z "${token}" ]]; then
    printf "Failed to find access_token in authentication response."
    exit 1
fi

auth_header="Authorization: Bearer ${token}"

"${CURL}" -fsSL -X GET --url "${UPWIND_ARTIFACT_URL}" --header "${auth_header}" -o "$out" 2>&1
