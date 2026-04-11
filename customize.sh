#!/system/bin/sh

MODPATH=${0%/*}

ui_print() { echo "$1"; }
abort() { 
  ui_print "Installation aborted!"
  exit 1
}

ui_print "Installing HyperBridge Module"
ui_print "Original App by: D4vidDf"
ui_print "Module by: Mohamed Zaitoon"
ui_print ""

# -----------------------------
# Android 15+ (SDK 35)
# -----------------------------
ANDROID_SDK=$(getprop ro.build.version.sdk)
[ -n "$ANDROID_SDK" ] || abort
[ "$ANDROID_SDK" -ge 35 ] || abort

# -----------------------------
# HyperOS 3+ (Required for Native Live Updates)
# -----------------------------
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
# Check HyperOS version (3.0.300.0+ recommended)
# -----------------------------
HYPER_VER=$(getprop ro.mi.os.version.incremental)

if [ -n "$HYPER_VER" ]; then
  echo "$HYPER_VER" | grep -qE "3\.0\.(3|[4-9])" || {
    ui_print "Warning:"
    ui_print "Native Live Updates may not work properly."
    ui_print "Recommended HyperOS version: 3.0.300.0 or higher."
  }
fi

# -----------------------------
# Installation handled automatically by Magisk / KernelSU
# -----------------------------

# Start service.sh in background
/system/bin/sh $MODPATH/service.sh &

# -----------------------------
# Post-install notes
# -----------------------------
ui_print ""
ui_print "HyperBridge installed successfully!"
ui_print ""
ui_print "IMPORTANT:"
ui_print "- You may need to reconfigure Engine Options"
ui_print "  (Native / Xiaomi) after updating."
ui_print ""
ui_print "System Requirements:"
ui_print "- Native Live Updates requires HyperOS 3.0.300.0+"
ui_print "  or the latest System UI Plugin update."
ui_print ""

exit 0