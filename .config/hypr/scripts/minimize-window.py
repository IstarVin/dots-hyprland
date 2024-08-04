#!/usr/bin/python3

import subprocess
import json
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('window', type=str)
parser.add_argument('workspace_name', type=str)
parser.add_argument('exec', type=str)
args = parser.parse_args()

clients_json = subprocess.run(['hyprctl', '-j', 'clients'], capture_output=True, text=True).stdout
clients = json.loads(clients_json)

exists = False
in_workspace = False

args_split = args.window.split(':')

if len(args_split) != 2:
    exit()

type_, name = args_split

for i in clients:
    if i[type_] == name:
        if i['workspace']['name'] == args.workspace_name:
            in_workspace = True
        exists = True

print(f'{exists=}, {in_workspace=}')

active_window_json = subprocess.run(['hyprctl', '-j', 'activewindow'], capture_output=True, text=True)
active_workspace = None
is_special_workspace = False

try:
    active_window = json.loads(active_window_json.stdout)
    active_workspace = active_window['workspace']['name']
    is_special_workspace = 'special' in active_workspace
except:
    active_workspace_json = subprocess.run(['hyprctl', '-j', 'activeworkspace'], capture_output=True, text=True).stdout
    active_workspace = json.loads(active_workspace_json)['name']

print(active_workspace, is_special_workspace)

if exists:
    if in_workspace:
        if is_special_workspace:
            # subprocess.run(['hyprctl', f'dispatch movetoworkspace 11,{args.window}'])
            subprocess.run(['hyprctl', f'dispatch workspace +1,{args.window}'])
            subprocess.run(['hyprctl', f'dispatch workspace -1,{args.window}'])
            # pass

        subprocess.run(['hyprctl', f'dispatch movetoworkspace {active_workspace},{args.window}'])
        subprocess.run(['hyprctl', f'dispatch pin {args.window}'])
    else:
        subprocess.run(['hyprctl', f'dispatch pin {args.window}'])
        subprocess.run(['hyprctl', f'dispatch movetoworkspacesilent {args.workspace_name},{args.window}'])
else:
    subprocess.run(['hyprctl', f'dispatch exec {args.exec}'])

