#!/bin/python3

import json
import subprocess


def lua_string(value: str) -> str:
    return json.dumps(value)


def dispatch(command: str) -> None:
    subprocess.run(["hyprctl", "dispatch", command], check=True)


result = subprocess.run(
    ["pgrep", "-a", "youtube-music"],
    capture_output=True,
    text=True,
)

music_is_open = len(result.stdout.strip()) != 0


if not music_is_open:
    dispatch('hl.dsp.exec_cmd("youtube-music", {workspace = "special:music silent"})')
else:
    subprocess.run(["playerctl", "play-pause"])
