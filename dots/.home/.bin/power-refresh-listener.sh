#!/bin/bash

apply_profile() {
    case "$(powerprofilesctl get)" in
        power-saver)
            gdctl set -L -p -M eDP-1 -m 1920x1080@60.004+vrr
            ;;
        balanced|performance)
            gdctl set -L -p -M eDP-1 -m 1920x1080@144.003+vrr
            ;;
    esac
}

# Apply at startup
apply_profile

gdbus monitor --system --dest net.hadess.PowerProfiles |
while read -r line; do
    [[ "$line" == *"PropertiesChanged"* ]] && apply_profile
done
