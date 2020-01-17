#!/usr/bin/env bash
set -euf -o pipefail

api=https://api.github.com

# Fetches a resource, paginating until the response is empty.
# When all resources have been fetched, combine them all into one file.
#
function fetch { # path query
  path=$1
  query=$2
  baseUrl="${api}/${path}?${query}"

  mkdir -p "${path}"

  page=1
  while :
  do
    url="${baseUrl}&page=${page}"
    echo "${url}"
    json=$(curl "${GITHUB_AUTH}" --fail --silent --show-error "${url}" | jq . -c --raw-output)
    if [ "${json}" == "[]" ]; then
      break
    fi
    echo "${json}" > "${path}/page-$(printf "%03d" "${page}").json"
    page=$((page+1))
  done

  # Combine them all into one file for easier processing
  find "${path}" -type f | xargs jq -s add > "${path}.json"
}
