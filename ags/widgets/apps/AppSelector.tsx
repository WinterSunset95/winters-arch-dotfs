import app from "ags/gtk4/app";
import Astal from "gi://Astal?version=4.0";
import Gdk from "gi://Gdk?version=4.0";
import Adw from "gi://Adw?version=1";
import { For, With, createBinding, createComputed, createState, onCleanup } from "ags"
import AstalBattery from "gi://AstalBattery?version=0.1"
import { Gtk } from "ags/gtk4";

export default function AppSelector({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let win: Astal.Window
  const { LEFT, TOP, BOTTOM, RIGHT } = Astal.WindowAnchor
  const [visible, setVisible] = createState(false)
  const [reveal, setReveal] = createState(false)
  const [width, setWidth] = createState(0)

  onCleanup(() => {
    // Root components (windows) are not automatically destroyed.
    // When the monitor is disconnected from the system, this callback
    // is run from the parent <For> which allows us to destroy the window
    win.destroy()
  })

  return (
    <window
      name={`app-selector`}
      $={(self) => {
        // Object.assign(self, { show, hide })
        return (win = self)
      }}
      namespace="my-bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | BOTTOM}
      application={app}
      class={"bar"}
    >
      <revealer>
        <box class={"test"}>Hello there</box>
      </revealer>
    </window>
  )
}
