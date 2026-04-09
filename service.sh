#!/system/bin/sh
MODPATH=${0%/*}

ui_print() { echo "$1"; }

ui_print "Starting HyperBridge Notification Listener Service..."

while true; do
  cmd notification allow_listener com.d4viddf.hyperbridge/com.d4viddf.hyperbridge.service.NotificationReaderService
  sleep 5
done