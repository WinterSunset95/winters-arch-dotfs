#!/usr/bin/python

import subprocess
import os
import socket
import json
try:
    from i3ipc import Connection, Event
    i3 = Connection()
except:
    pass
from time import sleep


def mainPrint(string):
    subprocess.run(f"echo '{string}'", shell=True)

# Not used anymore, but i'll leave it anyways
def hyprlandWorkspaces():
    def update_workspace(active_workspace):
        openWorkspaces = os.popen("hyprctl workspaces -j").read()
        workspaces = json.loads(openWorkspaces)
        openWorkspaces = [];
        for workspace in workspaces:
            openWorkspaces.append(workspace['id'])
        openWorkspaces.sort()

        # startStr = f"(box :class \"workspaces\" :orientation \"h\" :halign \"start\" "
        startStr = f"(box :class \"workspaces\" :orientation \"v\" :valign \"start\" :vexpand false "
        middleStr = f""
        endStr = f")"

        for ws in openWorkspaces:
            if ws == active_workspace:
                #currStr = f"(button :class \"active_workspace\" :onclick \"hyprctl dispatch workspace {ws}\" \"\")"
                # currStr = f"(button :height \"25\" :class \"active_workspace ws\" :onclick \"hyprctl dispatch workspace {ws}\" \"{ws}\")"
                currStr = f"(button :height \"30\" :class \"active_workspace\" :onclick \"hyprctl dispatch workspace {ws}\" \"{ws}\")"
            else:
                #currStr = f"(button :onclick \"hyprctl dispatch workspace {ws}\" \"\")"
                #currStr = f"(button :height \"25\" :class \"ws\" :onclick \"hyprctl dispatch workspace {ws}\" \"{ws}\")"
                currStr = f"(button :height \"30\" :class \"ws\" :onclick \"hyprctl dispatch workspace {ws}\" \"{ws}\")"
            middleStr = middleStr + currStr
        prompt = f"{startStr}{middleStr}{endStr}"

        subprocess.run(f"echo '{prompt}'", 
                       shell=True)

    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    server_address = f'{os.environ["XDG_RUNTIME_DIR"]}/hypr/{os.environ["HYPRLAND_INSTANCE_SIGNATURE"]}/.socket2.sock'
    sock.connect(server_address)

# Before the loop starts we need to first output an initialization message
    activeWs = os.popen("hyprctl activeworkspace -j").read()
    activeWs = json.loads(activeWs)
    activeWs = activeWs['id']
    update_workspace(activeWs)

# The loop will run until the connection is closed
    while True:
        new_event = sock.recv(4096).decode("utf-8")
        for item in new_event.split("\n"):
            if "workspace>>" == item[0:11]:
                workspaces_num = item[-1]
                update_workspace(int(workspaces_num))

def updateWorkspaces(i3, e):
    workspacesList = i3.get_workspaces()
    startStr = f"(box :class \"workspaces\" :orientation \"v\" :valign \"start\" :vexpand false "
    middleStr = f""
    endStr = f")"
    for item in workspacesList:
        if item.visible:
            ws = item.name
            currStr = f"(button :height \"30\" :class \"active_workspace\" :onclick \"i3-msg workspace {ws}\" \"{ws}\")"
            middleStr = middleStr + currStr
        else:
            ws = item.name
            currStr = f"(button :height \"30\" :class \"ws\" :onclick \"i3-msg workspace {ws}\" \"{ws}\")"
            middleStr = middleStr + currStr
    mainPrint(f"{startStr}{middleStr}{endStr}")

# updateWorkspaces(i3, {})
# i3.on(Event.WORKSPACE, updateWorkspaces)
# i3.main()

hyprlandWorkspaces()
