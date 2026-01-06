#!/system/bin/sh

MODPATH=${0%/*}

ui_print() { echo "$1"; }
abort() { exit 1; }

ui_print "Installing HyperBridge Module"
ui_print "Original App by: D4vidDf"
ui_print "Module by: Mohamed Zaitoon"
ui_print ""

# -----------------------------
# Android 16+ (SDK 36)
ANDROID_SDK=$(getprop ro.build.version.sdk)
[ -n "$ANDROID_SDK" ] || abort
[ "$ANDROID_SDK" -ge 36 ] || abort

# -----------------------------
# HyperOS 3+ only
HYPER_CODE=$(getprop ro.mi.os.version.code)
HYPER_NAME=$(getprop ro.mi.os.version.name)

if [ -n "$HYPER_CODE" ]; then
  [ "$HYPER_CODE" -ge 3 ] || abort
elif [ -n "$HYPER_NAME" ]; then
  echo "$HYPER_NAME" | grep -q "3" || abort
else
  abort
fi

# -----------------------------
# Installation handled automatically by Magisk / KernelSU

ui_print ""
ui_print "HyperBridge has been successfully installed as a system app."
exit 0