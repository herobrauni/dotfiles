#!/bin/bash

# GeForce NOW SteamOS Spoof Script with Certificate Fix
# This script runs GeForce NOW with SteamOS /etc/os-release information
# Provides the necessary SSL certificates to prevent network errors

echo "Starting GeForce NOW with SteamOS os-release file and SSL certs..."

# Run the flatpak command with the required setup
flatpak run --user --command=bash com.nvidia.geforcenow -c '
    # Exit immediately if a command exits with a non-zero status.
    set -e

    # Create the directory that holds the os-release and SSL certs
    mkdir -p /run/host/etc/ssl

    # Create the SteamOS os-release file
    cat > /run/host/etc/os-release << EOF
NAME="SteamOS"
PRETTY_NAME="SteamOS"
VERSION_CODENAME=holo
ID=steamos
ID_LIKE=arch
ANSI_COLOR="1;35"
HOME_URL="https://www.steampowered.com/"
DOCUMENTATION_URL="https://support.steampowered.com/"
SUPPORT_URL="https://support.steampowered.com/"
BUG_REPORT_URL="https://support.steampowered.com/"
LOGO=steamos
VARIANT_ID=steamdeck
BUILD_ID=20250522.1
VERSION_ID=3.7.8
EOF

    # Recursively copy the host system'\''s SSL certificates into the sandbox
    cp -r /etc/ssl /run/host/etc/

    # Launch GeForce NOW
    echo "Launching GeForce NOW..."
    /app/bin/GeForceNOW
'

echo "GeForce NOW session ended."
