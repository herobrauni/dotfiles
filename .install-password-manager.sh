#!/bin/sh

# exit immediately if password-manager-binary is already in $PATH
type rbw >/dev/null 2>&1 && exit

case "$(uname -s)" in
Darwin)
    # commands to install password-manager-binary on Darwin
    ;;
Linux)
    # commands to install password-manager-binary on Linux
    paru -S rbw --noconfirm
    ;;
*)
    echo "unsupported OS"
    exit 1
    ;;
esac
