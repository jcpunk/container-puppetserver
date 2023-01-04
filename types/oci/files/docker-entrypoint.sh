#!/bin/bash
# bash is required to pass ENV vars with dots as sh cannot

set -e

find /docker-entrypoint.d/ /docker-custom-entrypoint.d/ -type f -name "*.sh" -exec chmod +x {} \;
sync
echo "Running builtin entrypoint scripts"
for f in /docker-entrypoint.d/*.sh; do
    echo "Running $f"
    "$f"
done
echo "Running custom entrypoint scripts"
for f in /docker-custom-entrypoint.d/*.sh; do
    echo "Running $f"
    "$f"
done
echo "Running puppet server"
exec /opt/puppetlabs/bin/puppetserver "$@"
