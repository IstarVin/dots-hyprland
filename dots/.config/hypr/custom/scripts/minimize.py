#!/usr/bin/python3

import argparse
import json
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument("window", type=str)
parser.add_argument("exec", type=str)
args = parser.parse_args()


def lua_string(value: str) -> str:
    return json.dumps(value)


def workspace_value(value: str | int) -> str:
    if isinstance(value, int):
        return str(value)
    return lua_string(value)


def dispatch(command: str) -> None:
    subprocess.run(["hyprctl", "dispatch", command], check=True)


clients_json = subprocess.run(
    ["hyprctl", "-j", "clients"], capture_output=True, text=True, check=True
).stdout
clients = json.loads(clients_json)

win_attr, win_data = args.window.split(":")

exists = False
window = None

for i in clients:
    if i[win_attr] == win_data:
        window = i
        exists = True
        break

if not exists:
    dispatch(f"hl.dsp.exec_cmd({lua_string(args.exec)}, {{ float = true }})")
    dispatch(f"hl.dsp.focus({{ window = {lua_string(args.window)} }})")
    print("started")
    exit()

current_window_json = subprocess.run(
    ["hyprctl", "-j", "activewindow"], capture_output=True, text=True, check=True
).stdout
current_window = json.loads(current_window_json)

if current_window != {}:
    current_workspace = current_window["workspace"]["id"]
    ws = current_window["workspace"]["name"]
else:
    current_wokrspace_json = subprocess.run(
        ["hyprctl", "-j", "activeworkspace"], capture_output=True, text=True, check=True
    ).stdout
    current_workspace = json.loads(current_wokrspace_json)["id"]
    ws = current_workspace


if window["workspace"]["id"] != current_workspace:
    dispatch(
        "hl.dsp.window.move({ "
        f"workspace = {workspace_value(ws)}, "
        f"window = {lua_string(args.window)}, "
        "follow = false })"
    )
    dispatch(f"hl.dsp.focus({{ window = {lua_string(args.window)} }})")

else:
    if window["focusHistoryID"] == 0:
        dispatch(
            "hl.dsp.window.move({ "
            f"workspace = 99, window = {lua_string(args.window)}, follow = false "
            "})"
        )
    else:
        dispatch(f"hl.dsp.focus({{ window = {lua_string(args.window)} }})")
