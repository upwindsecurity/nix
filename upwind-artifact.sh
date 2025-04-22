#!/bin/bash

### Getting auth token

response="$("${curl}" -fsSL -X POST \
    --data grant_type=client_credentials \
    --data "audience=${authAudience}" \
    --data "client_id=${UPWIND_CLIENT_ID}" \
    --data "client_secret=${UPWIND_CLIENT_SECRET}" \
    --url "${authEndpoint}" 2>&1)"
if [[ $? != 0 ]]; then
    printf "error: unable to get auth token: %s" "${response}"
    exit 1
fi

authHeader="Authorization: Bearer $(echo "${response}" | ${jq} -r .access_token)"
if [[ -z "${authHeader}" ]]; then
    printf "error: failed to find access_token in authentication response."
    exit 1
fi

"${curl}" -fsSL -X GET --url "${artifactUrl}" --header "${authHeader}" -o "$out" 2>&1
