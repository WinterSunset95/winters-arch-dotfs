import app from "ags/gtk4/app";
import Astal from "gi://Astal?version=4.0";
import Gdk from "gi://Gdk?version=4.0";
import Adw from "gi://Adw?version=1";
import { For, With, createBinding, createComputed, createState, onCleanup } from "ags"
import AstalBattery from "gi://AstalBattery?version=0.1"
import { Gtk } from "ags/gtk4";

interface SubItem {
  label: string,
  value: number,
  setValue: (value: number) => void
}

export interface SliderProps {
  icon: string,
  value: number,
  setValue: (value: number) => void,
  subItems: SubItem[]
}
export default function Slider(props: SliderProps) {
  const { icon, value, setValue, subItems } = props
  const [open, setOpen] = createState(false)

  return (
    <box orientation={Gtk.Orientation.VERTICAL}>
      <box>
        <box>
          <image iconName={icon} />
        </box>
        <slider
          widthRequest={300}
          value={value}
          onChangeValue={({ value }) => setValue(value)}
        />
        <With value={open}>
          {(open) => (
            <button onClicked={() => setOpen(!open)}>
              {open ? "" : ""}
            </button>
          )}
        </With>
      </box>
      <revealer
        transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
        revealChild={open}
      >
        <box orientation={Gtk.Orientation.VERTICAL}
          heightRequest={100}
        >
          {subItems.length > 0 && (
            <box>Empty!!</box>
          )}
          {subItems.map((item) => {
            return (
              <box>Hi</box>
            )
          })}
        </box>
      </revealer>
    </box>
  )
}


