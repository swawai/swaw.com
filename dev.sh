#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BANYAN_DEV_PORT=${BANYAN_DEV_PORT:-5120}
PUBLIC_DIR=$ROOT_DIR/public

if [ "${BANYAN_DEV_BIND:-}" = "" ]; then
  if command -v ip >/dev/null 2>&1; then
    BANYAN_DEV_BIND=$(ip route get 1 2>/dev/null | awk '{for (i = 1; i <= NF; i++) if ($i == "src") { print $(i + 1); exit }}')
  elif command -v hostname >/dev/null 2>&1; then
    BANYAN_DEV_BIND=$(hostname -I 2>/dev/null | awk '{print $1}')
  fi
  BANYAN_DEV_BIND=${BANYAN_DEV_BIND:-127.0.0.1}
fi

case "$PUBLIC_DIR" in
  "$ROOT_DIR"/public) ;;
  *)
    echo "Refusing to delete unexpected path: $PUBLIC_DIR" >&2
    exit 1
    ;;
esac

rm -rf "$PUBLIC_DIR"
cd "$ROOT_DIR"
export BANYAN_DEV_BIND
export BANYAN_DEV_PORT
echo "Starting swaw.com dev server on $BANYAN_DEV_BIND:$BANYAN_DEV_PORT"
bun run dev
