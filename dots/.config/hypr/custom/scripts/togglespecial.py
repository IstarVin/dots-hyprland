#!/bin/python

import json
import os
import subprocess


def lua_string(value: str) -> str:
    return json.dumps(value)


def dispatch(command: str) -> None:
    subprocess.run(["hyprctl", "dispatch", command], check=True)


active_window_json = subprocess.run(
    ["hyprctl", "-j", "activewindow"], capture_output=True, text=True, check=True
)
active_window = json.loads(active_window_json.stdout)
# subprocess.run(["notify-send", active_window_json.stdout])

sw_file = "/tmp/specialworkspace"
if active_window and "special" in active_window["workspace"]["name"]:
    dispatch('hl.dsp.workspace.toggle_special("dummy")')
    dispatch('hl.dsp.workspace.toggle_special("dummy")')

    with open(sw_file, "w+") as specialworkspace:
        specialworkspace.write(active_window["workspace"]["name"].split(":")[1])

else:
    if os.path.isfile(sw_file):
        with open(sw_file, "r") as specialworkspace:
            sw = specialworkspace.read()
            dispatch(f"hl.dsp.workspace.toggle_special({lua_string(sw)})")
