#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

ps -eo pid,comm,args \
  | grep -E '[n]ode|[h]ugo' \
  | grep "$ROOT_DIR" \
  || true
