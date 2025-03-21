#!/usr/bin/env bash

SERVICE="org.kde.KWin"
DBUS_PATH="/org/kde/KWin/InputDevice"
INTERFACE="org.kde.KWin.InputDevice"
METHOD_GET="org.freedesktop.DBus.Properties.Get"
METHOD_SET="org.freedesktop.DBus.Properties.Set"

# sudo libinput list-devices
declare -A devices=(
    ["SYNA32CB:00 06CB:CE7D Touchpad"]=''
    ["AT Translated Set 2 keyboard"]=''
    ["HP WMI hotkeys"]=''
)
# Device:           ELAN2513:00 04F3:2F96
# Device:           ELAN2513:00 04F3:2F96 Stylus
# Device:           ELAN2513:00 04F3:2F96 Keyboard
# Device:           ELAN2513:00 04F3:2F96 Mouse
# Device:           SYNA32CB:00 06CB:CE7D Mouse
# Device:           SYNA32CB:00 06CB:CE7D Touchpad
# Device:           AT Translated Set 2 keyboard
find_devices() {
    local DM_INTERFACE="org.kde.KWin.InputDeviceManager"
    local DM_PROPERTY="devicesSysNames"

    for sysname in $(qdbus "$SERVICE" "$DBUS_PATH" "$METHOD_GET" "$DM_INTERFACE" "$DM_PROPERTY"); do
        name=$(qdbus "$SERVICE" "${DBUS_PATH}/${sysname}" "$METHOD_GET" "$INTERFACE" name)

        for device in "${!devices[@]}"; do
            if [ "$name" == "$device" ]; then
                devices["$device"]="$sysname"
            fi
        done
    done
}

check_devices() {
    local return_code=0
    for device in "${!devices[@]}"; do
        sysname=${devices["$device"]}
        if [ -z "$device" ]; then
            echo "Failed to find device ($device)"
            return_code=1
        fi
    done
    return "$return_code"
}

get_device_status() {
    qdbus "$SERVICE" "${DBUS_PATH}/$1" "$METHOD_GET" "$INTERFACE" "enabled"
}

set_device_status() {
    qdbus "$SERVICE" "${DBUS_PATH}/$1" "$METHOD_SET" "$INTERFACE" "enabled" "$2"
}

toggle_device() {
    status=$(get_device_status "$1")
    status=$([[ "$status" == "false" ]] && echo true || echo false)
    set_device_status "$1" "$status"
}

find_devices
if ! check_devices; then
    exit 1
fi

for device in "${!devices[@]}"; do
    sysname=${devices["$device"]}
    case "$1" in
        "enable") set_device_status "$sysname" true ;;
        "disable") set_device_status "$sysname" false ;;
        "toggle") toggle_device "$sysname" ;;
        "status") echo "$device: $(get_device_status "$sysname" )"
    esac
done