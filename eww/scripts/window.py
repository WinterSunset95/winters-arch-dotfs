#!/usr/bin/python

import subprocess
import os
import socket
import json
from time import sleep
from i3ipc import Connection, Event

i3 = Connection()

def mainPrint(string):
    subprocess.run(f"echo '{string}'", shell=True)

def hyprlandWorkspaces():
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    server_address = f'{os.environ["XDG_RUNTIME_DIR"]}/hypr/{os.environ["HYPRLAND_INSTANCE_SIGNATURE"]}/.socket2.sock'
    sock.connect(server_address)

    # Before the loop starts, first echo out the currently active window
    try:
        currWindow = os.popen("hyprctl activewindow -j").read()
        currWindow = json.loads(currWindow)
        currWindow = currWindow['title']
        if len(currWindow) > 60:
            currWindow = currWindow[:60] + "..."
        subprocess.run(f"echo '{currWindow}'", shell=True)
    except:
        subprocess.run(f"echo 'No active window'", shell=True)

    # Infinite loop to keep track of the currently open window
    while True:
        new_event = sock.recv(4096).decode("utf-8")
        for line in new_event.split('\n'):
            if "activewindow>>" in line:
                activeWindow = line.split(",")[1]
                if len(activeWindow) > 60:
                    activeWindow = activeWindow[:60] + "..."
                subprocess.run(f"echo '{activeWindow}'", shell=True)

def activeWindow(i3, e):
    focused = i3.get_tree().find_focused()
    if len(focused.name) > 2:
        windowName = focused.name
        if len(windowName) > 60:
            windowName = windowName[:60] + "..."
        mainPrint(f"{windowName}")
    else:
        mainPrint("No Window Opened")

activeWindow(i3, {})
i3.on(Event.WINDOW, activeWindow)
i3.on(Event.WORKSPACE, activeWindow)
i3.main()
