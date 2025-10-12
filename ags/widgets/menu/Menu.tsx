import app from "ags/gtk4/app";
import Astal from "gi://Astal?version=4.0";
import Gdk from "gi://Gdk?version=4.0";
import Adw from "gi://Adw?version=1";
import { For, With, createBinding, createComputed, createState, onCleanup } from "ags"
import AstalBattery from "gi://AstalBattery?version=0.1"
import { Gtk } from "ags/gtk4";
import AstalWp from "gi://AstalWp?version=0.1";
import Slider, { SliderProps } from "./components/Slider";

export default function Menu({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let win: Astal.Window
  const { LEFT, TOP, BOTTOM, RIGHT } = Astal.WindowAnchor
  const [visible, setVisible] = createState(false)
  const [reveal, setReveal] = createState(false)
  const [width, setWidth] = createState(0)

  // For audio controls
  const wireplumber = AstalWp.get_default();
  const volume = createBinding(wireplumber.defaultSpeaker, "volume")
  const volumeIcon = createBinding(wireplumber.defaultSpeaker, "volumeIcon")
  const devices = createBinding(wireplumber, "devices")

  function show() {
    setVisible(true)
    setReveal(true)
  }

  function hide() {
    setReveal(false)
  }

  onCleanup(() => {
    // Root components (windows) are not automatically destroyed.
    // When the monitor is disconnected from the system, this callback
    // is run from the parent <For> which allows us to destroy the window
    win.destroy()
  })

  const bindings = createComputed((get) => {
    let devicesArr = get(devices)
    print("")
    devicesArr.map((device) => {
      print(device.id)
    })
    print("")

    let speakerProps: SliderProps = {
      icon: get(volumeIcon),
      value: get(volume),
      setValue: (value) => {
        wireplumber.defaultSpeaker.set_volume(value)
      },
      subItems: []
    }

    return {
      speaker: speakerProps,
    }
  })

  return (
    <window
      name={`menu-section`}
      $={(self) => {
        Object.assign(self, { show, hide })
        return (win = self)
      }}
      visible={visible}
      namespace="my-bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | RIGHT}
      application={app}
      class={"nobg"}
    >
      <revealer
        transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
        revealChild={reveal}
        onNotifyChildRevealed={({ childRevealed }) => {
          setVisible(childRevealed)
        }}
      >
        <With value={bindings}>
          {(bindings) => (
            <box
              spacing={5}
              orientation={Gtk.Orientation.VERTICAL}
              class={"nobg"}
            >
              <box class={"menu-box"}>
                <Slider {...bindings.speaker} />
              </box>
              <box class={"menu-box"}>Hello there</box>
            </box>
          )}
        </With>
      </revealer>
    </window>
  )
}
