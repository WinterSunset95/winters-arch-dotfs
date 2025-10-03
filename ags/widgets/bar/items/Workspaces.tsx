import Hyprland from "gi://AstalHyprland"
import { For, With, createBinding, createComputed, createState, onCleanup } from "ags"

function groupByProperty(
    array: Hyprland.Workspace[],
): Hyprland.Workspace[][] {
    const map = new Map<Hyprland.Monitor, Hyprland.Workspace[]>();

    array.forEach((item) => {
        const key = item.monitor;
        if (key === null) {
            return
        }
        if (!map.has(key)) {
            map.set(key, []);
        }
        map.get(key)!.unshift(item);
    });

    return Array.from(map.values()).sort((a, b) => {
        return a[0].monitor.id - b[0].monitor.id
    });
}

function Workspaces() {
  const hyprland = Hyprland.get_default();
  const hyprlandWorkspaces = createBinding(hyprland, "workspaces",)((p) => p.sort((a, b) => a.id - b.id))

  return (
    <With value={hyprlandWorkspaces}>
      {(workspaces) => 
        <box>
        {workspaces.sort((a, b) => a.id - b.id).map((workspace) => {
          let focused = createBinding(hyprland, "focusedWorkspace")
          return (
            <With value={focused}>
              {(focusedWorkspace) =>
                <button class={`workspace-button ${focusedWorkspace === workspace ? "workspace-focused" : ""}`}>
                  <label label={workspace.id.toString()} />
                </button>
              }
            </With>
          )
        })}
        </box>
      }
    </With>
  )
}

export default Workspaces

