#!/bin/bash
# bash is required to pass ENV vars with dots as sh cannot

set -e

find /healthcheck-script.d/ /healthcheck-custom-script.d/ -type f -name "*.sh" -exec chmod +x {} \;
sync
echo "Running builtin healthcheck scripts"
for f in /healthcheck-script.d/*.sh; do
    echo "Running $f"
    "$f"
done
echo "Running custom healthcheck scripts"
for f in /healthcheck-custom-script.d/*.sh; do
    echo "Running $f"
    "$f"
done
