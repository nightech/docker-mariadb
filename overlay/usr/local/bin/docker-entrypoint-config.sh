#!/usr/bin/env bash

set -e

# Ini
declare -A ENV_CONFIG=()

ENV_CONFIG[MAX_ALLOWED_PACKET]=${MAX_ALLOWED_PACKET:-"4m"}
ENV_CONFIG[INNODB_FLUSH_LOG_AT_TRX_COMMIT]=${INNODB_FLUSH_LOG_AT_TRX_COMMIT:-"1"}
ENV_CONFIG[INNODB_LOG_BUFFER_SIZE]=${INNODB_LOG_BUFFER_SIZE:-"8m"}
ENV_CONFIG[INNODB_BUFFER_POOL_SIZE]=${INNODB_BUFFER_POOL_SIZE:-"128m"}

for FILE in `find /etc/mysql/conf.d -type f -name zzz-*`;  do
    for KEY in "${!ENV_CONFIG[@]}"; do
        sed -i.bak "s!\%"$KEY"\%!"${ENV_CONFIG[$KEY]}"!g" $FILE
    done
done

find  /etc/mysql/conf.d -type f -name zzz-*.bak -delete

exec docker-entrypoint.sh "$@"

