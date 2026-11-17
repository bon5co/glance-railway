#!/bin/sh
# Railway boot for Glance. Volume at /app/config holds glance.yml and the session secret.
set -e
CFG=/app/config/glance.yml
KEYFILE=/app/config/.session-secret
mkdir -p /app/config

: "${PORT:=8080}"
export PORT
if [ -z "$ADMIN_PASSWORD" ]; then
  echo "[railway] ADMIN_PASSWORD is not set; refusing to start a dashboard with no login" >&2
  exit 1
fi

# session secret: created once, kept on the volume so logins survive a redeploy
if [ ! -s "$KEYFILE" ]; then
  /app/glance secret:make > "$KEYFILE"
  chmod 600 "$KEYFILE"
fi
GLANCE_SECRET_KEY="$(cat "$KEYFILE")"
export GLANCE_SECRET_KEY

# config: a GLANCE_CONFIG variable (full YAML) replaces the file at every boot; otherwise the default is written once
if [ -n "$GLANCE_CONFIG" ]; then
  printf '%s\n' "$GLANCE_CONFIG" > "$CFG"
  echo "[railway] config written from GLANCE_CONFIG"
elif [ ! -s "$CFG" ]; then
  cp /app/default-glance.yml "$CFG"
  echo "[railway] default config written to $CFG"
fi

/app/glance --config "$CFG" config:validate
echo "[railway] port=$PORT config=$CFG owner=$(stat -c %u:%g /app/config)"
exec /app/glance --config "$CFG"
