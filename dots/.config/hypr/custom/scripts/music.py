#!/bin/python3

import json
import subprocess


def lua_string(value: str) -> str:
    return json.dumps(value)


def dispatch(command: str) -> None:
    subprocess.run(["hyprctl", "dispatch", command], check=True)


result = subprocess.run(
    ["pgrep", "-a", "electron"],
    capture_output=True,
    text=True,
)

music_is_open = "pear-desktop" in result.stdout


if not music_is_open:
    dispatch('hl.dsp.exec_cmd("pear-desktop", {workspace = "special:music silent"})')
else:
    subprocess.run(["playerctl", "play-pause"])
