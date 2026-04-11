#!/system/bin/sh

PKG="com.d4viddf.hyperbridge"
SERVICE="$PKG/com.d4viddf.hyperbridge.service.NotificationReaderService"

log() { echo "[HyperBridge] $1"; }

# Wait for boot completion
until [ "$(getprop sys.boot_completed)" = "1" ]; do
  sleep 2
done

sleep 10

log "Starting Notification Listener ONLY mode..."

# -----------------------------
# Disable battery restrictions
# -----------------------------
cmd deviceidle whitelist +$PKG 2>/dev/null

# -----------------------------
# Enable notification listener
# -----------------------------
cmd notification allow_listener "$SERVICE" 2>/dev/null

# -----------------------------
# Keep service alive (NO app launching)
# -----------------------------
while true; do

  # Re-apply whitelist (HyperOS resets sometimes)
  cmd deviceidle whitelist +$PKG 2>/dev/null

  # Ensure listener is still enabled
  ENABLED=$(cmd notification get_enabled_notification_listeners 2>/dev/null)
  echo "$ENABLED" | grep -q "$SERVICE"

  if [ $? -ne 0 ]; then
    log "Re-enabling notification listener..."
    cmd notification allow_listener "$SERVICE"
  fi

  sleep 30
done