#!/system/bin/sh

MODPATH=${0%/*}

PKG="com.d4viddf.hyperbridge"
SERVICE="$PKG/com.d4viddf.hyperbridge.service.NotificationReaderService"

log() { echo "[HyperBridge] $1"; }

# Wait for boot completion
until [ "$(getprop sys.boot_completed)" = "1" ]; do
  sleep 2
done

sleep 10

log "Starting HyperBridge GOD MODE..."

# -----------------------------
# System tweaks
# -----------------------------
settings put global hidden_api_policy 1
settings put global hidden_api_policy_pre_p_apps 1
settings put global hidden_api_policy_p_apps 1

# -----------------------------
# Whitelist & permissions
# -----------------------------
cmd deviceidle whitelist +$PKG 2>/dev/null
dumpsys deviceidle whitelist +$PKG 2>/dev/null

cmd appops set $PKG RUN_IN_BACKGROUND allow 2>/dev/null
cmd appops set $PKG RUN_ANY_IN_BACKGROUND allow 2>/dev/null
cmd appops set $PKG WAKE_LOCK allow 2>/dev/null

cmd notification allow_listener "$SERVICE" 2>/dev/null

# -----------------------------
# Main loop
# -----------------------------
while true; do

  PID=$(pidof $PKG)

  if [ -z "$PID" ]; then
    log "App not running -> launching"
    am start -n $PKG/.MainActivity >/dev/null 2>&1
    sleep 5
    PID=$(pidof $PKG)
  fi

  if [ -n "$PID" ]; then
    # Max CPU priority
    renice -20 -p $PID >/dev/null 2>&1

    # Prevent killing
    echo -1000 > /proc/$PID/oom_score_adj 2>/dev/null

    # Extra lock (best effort)
    echo 1 > /proc/$PID/oom_adj 2>/dev/null
  fi

  sleep 15
done