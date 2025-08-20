#!/usr/bin/env bash
set -uo pipefail

main() {
    arg_release_url_or_path="$1"
    arg_component="$2"
    arg_version="$(strip-prefix "$3" v)"
    arg_platform="$4"
    arg_arch="$5"

    # show usage and exit if args aren't provided
    if [[ $# != 5 ]]; then
        print_usage_message
        exit 1
    fi

    filename="${arg_component}-v${arg_version}-${arg_platform}-${arg_arch}.tar.gz"
    if [[ "${arg_release_url_or_path}" == http* ]]; then
        base_url="${arg_release_url_or_path}/${arg_component}/v${arg_version}"
        package="${base_url}/${filename}"

        if [[ "${UPWIND_CLIENT_ID:-}" == "" || "${UPWIND_CLIENT_SECRET:-}" == "" ]]; then
            echo "error: UPWIND_CLIENT_ID and UPWIND_CLIENT_SECRET must be set." >&2
            exit 1
        fi

        auth_endpoint="${UPWIND_AUTH_ENDPOINT:-https://oauth.upwind.io/oauth/token}"
        auth_audience="${UPWIND_AUTH_AUDIENCE:-https://agent.upwind.io}"

        auth_response="$(curl -fsSL -X POST \
            --data grant_type=client_credentials \
            --data "audience=${auth_audience}" \
            --data "client_id=${UPWIND_CLIENT_ID}" \
            --data "client_secret=${UPWIND_CLIENT_SECRET}" \
            --url "${auth_endpoint}" 2>&1)"
        if [[ $? != 0 ]]; then
            echo "Error authenticating: ${auth_response}" 2>&1
            exit 1
        fi

        auth_token="$(echo "${auth_response}" | grep -Eo '"access_token"[^,]*' | sed -E 's/"access_token": ?"(.*)"/\1/')"

        auth_header="Authorization: Bearer ${auth_token}"
        sha256="$(curl -fsSL -X GET --url "${package}.sha256" --header "${auth_header}" 2>&1)"
        if [[ $? != 0 ]]; then
            echo "Error getting hash: ${sha256}" 2>&1
            exit 1
        fi
    else
        package="${arg_release_url_or_path}/${filename}"
        sha256_file="${arg_release_url_or_path}/${filename}.sha256"
        sha256="$(cat "${sha256_file}")"
    fi

    output_path="./release/${arg_component}/v${arg_version}"
    echo "Writing to ${output_path}/${filename}.json"
    mkdir -p "${output_path}"
    print_manifest
    print_manifest > "${output_path}/${filename}.json"
}

strip-prefix() { printf "%s" "${1#"$2"}"; }

print_manifest() {
    cat <<EOF
{
  "name": "${arg_component}",
  "arch": "${arg_arch}",
  "version": "${arg_version}",
  "package": "${package}",
  "sha256": "${sha256}"
}
EOF
}

print_usage_message() {
    cat >&2 <<EOF
usage: generate-manifest.sh <release-url-or-path> <component> <version> <platform> <arch>

If release-url-or-path is set to a path containing a tarball and hash file, then
authentication is skipped and the release manifest is generated directly from those
local files.

Otherwise, the environment variables UPWIND_CLIENT_ID and UPWIND_CLIENT_SECRET are
required to be set to credentials with permission to access the provided release url.

Additionally, the optional UPWIND_AUTH_ENDPOINT and UPWIND_AUTH_AUDIENCE variables
may be set to override the authentication endpoint and audience if necessary.

For example, the invocation:

  generate-manifest.sh https://releases.upwind.io upwind-agent 0.119.0 linux amd64

generates the output:

{
  "name": "upwind-agent",
  "arch": "amd64",
  "version": "0.119.0",
  "package": "https://releases.upwind.io/upwind-agent/v0.119.0/upwind-agent-v0.119.0-linux-amd64.tar.gz",
  "sha256": "4cfa32684135322a9ff748b6143f4ef4dcd7e9509630d93a7f415aec32fe1776"
}
EOF
}

main "$@"
