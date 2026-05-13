#!/usr/bin/python3

import argparse
import json
import subprocess


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("window", type=str)
    parser.add_argument("exec", type=str)
    return parser.parse_args()


def lua_string(value: str) -> str:
    return json.dumps(value)


def workspace_value(value: str | int) -> str:
    if isinstance(value, int):
        return str(value)
    return lua_string(value)


def dispatch(command: str) -> None:
    subprocess.run(["hyprctl", "dispatch", command], check=True)


def hyprctl_json(command: str) -> dict | list:
    stdout = subprocess.run(
        ["hyprctl", "-j", command], capture_output=True, text=True, check=True
    ).stdout
    return json.loads(stdout)


def focus_window(window: str) -> None:
    dispatch(f"hl.dsp.focus({{ window = {lua_string(window)} }})")
    dispatch(
        f'hl.dsp.window.alter_zorder({{mode="top", window = {lua_string(window)}}})'
    )


def main():
    args = parse_args()
    clients = hyprctl_json("clients")

    win_attr, win_data = args.window.split(":", 1)

    window = next(
        (client for client in clients if client.get(win_attr) == win_data), None
    )

    if window is None:
        dispatch(f"hl.dsp.exec_cmd({lua_string(args.exec)}, {{ float = true }})")
        dispatch(f"hl.dsp.focus({{ window = {lua_string(args.window)} }})")
        print("started")
        return

    current_window = hyprctl_json("activewindow")

    if current_window:
        current_workspace = current_window["workspace"]["id"]
        ws = current_window["workspace"]["name"]
    else:
        current_workspace = hyprctl_json("activeworkspace")["id"]
        ws = current_workspace

    if window["workspace"]["id"] != current_workspace:
        dispatch(
            "hl.dsp.window.move({ "
            f"workspace = {workspace_value(ws)}, "
            f"window = {lua_string(args.window)}, "
            "})"
        )
        focus_window(args.window)

    elif window["focusHistoryID"] == 0:
        dispatch(
            "hl.dsp.window.move({ "
            f"workspace = 99, window = {lua_string(args.window)}, follow = false "
            "})"
        )
    else:
        focus_window(args.window)


if __name__ == "__main__":
    main()
