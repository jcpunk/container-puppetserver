#!/usr/bin/env bash

set -x
set -e

timeout=10
if [ "$#" -gt 0 ]; then
  timeout=$1
fi

hostpubkey=$(puppet config print hostcert)
hostprivkey=$(puppet config print hostprivkey)
localcacert=$(puppet config print localcacert)

curl --fail \
    --no-progress-meter \
    --max-time "${timeout}" \
    --resolve "${HOSTNAME}:${PUPPET_MASTERPORT}:127.0.0.1" \
    --cert    "${hostpubkey}" \
    --key     "${hostprivkey}" \
    --cacert  "${localcacert}" \
    "https://${HOSTNAME}:${PUPPET_MASTERPORT}/status/v1/simple" \
    |  grep -q '^running$' \
    || exit 1
