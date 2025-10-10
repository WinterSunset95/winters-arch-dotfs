import app from "ags/gtk4/app"
import GLib from "gi://GLib"
import Astal from "gi://Astal?version=4.0"
import Gtk from "gi://Gtk?version=4.0"
import Gdk from "gi://Gdk?version=4.0"
import AstalBattery from "gi://AstalBattery"
import AstalPowerProfiles from "gi://AstalPowerProfiles"
import AstalWp from "gi://AstalWp"
import AstalNetwork from "gi://AstalNetwork"
//import AstalTray from "gi://AstalTray"
import AstalMpris from "gi://AstalMpris"
import AstalApps from "gi://AstalApps"
import Hyprland from "gi://AstalHyprland"
import { For, With, createBinding, createComputed, createState, onCleanup } from "ags"
import { createPoll } from "ags/time"
import { execAsync } from "ags/process"
import AstalBluetooth from "gi://AstalBluetooth?version=0.1"

function toggleMenu() {
  let menu = app.get_window('menu-section')
  if (!menu) {
    print("Window: menu not found")
    return
  }
  if (menu.visible) {
    menu.hide()
  } else {
    menu.show()
  }
}

interface WirelessProps {
  wifi: AstalNetwork.Wifi,
  wired: AstalNetwork.Wired
}
function Wireless({ wifi, wired }: WirelessProps) {
  return (
    <button onClicked={toggleMenu}>
      <box>
        {wired.state === AstalNetwork.DeviceState.ACTIVATED && " "}
        {wifi.state === AstalNetwork.DeviceState.ACTIVATED && wifi.enabled ? "󰤨 " : "󰖪 "}
        {wifi.ssid}
      </box>
    </button>
  )
}

interface BatteryProps {
  visible: boolean,
  color: string,
  percent: number
}
function Battery({ visible, color, percent }: BatteryProps) {
  return (
    <button 
      onClicked={toggleMenu}
      visible={visible}
      css={`
        color: ${color};
        border: 2px solid ${color};
      `}
    >
      <label label={percent.toString()} />
    </button>
  )
}

interface BluetoothProps {
  icon: string,
  device: string,
  color: string,
  bg: string
}
function Bluetooth({ icon, device, color }: BluetoothProps) {
  return (
    <button
      onClicked={toggleMenu}
      css={`
        color: ${color};
        border: 2px solid ${color};
      `}
    >
      <box>
        <label label={icon} />
        <label label={device} />
      </box>
    </button>
  )
}

export default function RightUtilities() {
  const battery = AstalBattery.get_default();
  const bluetooth = AstalBluetooth.get_default()
  const wp = AstalWp.get_default()
  const network = AstalNetwork.get_default()

  const isPowered = createBinding(bluetooth, "isPowered")
  const isConnected = createBinding(bluetooth, "isConnected")
  const batteryState = createBinding(battery, "state")
  const connectedTo = createBinding(bluetooth, "devices")((devices) => {
    let connectedDevices = devices.filter((device) => device.connected).map((device) => device.name)
    if (connectedDevices.length === 0) {
      return "Not Connected"
    }
    return connectedDevices[0]
  })

  const wifi = createBinding(network, "wifi")
  const wired = createBinding(network, "wired")

  const percent = createBinding(
    battery,
    "percentage",
  )((p) => `${Math.floor(p * 100)}%`)

  const listeners = createComputed((get) => {
    let wireless: WirelessProps = {
      wifi: get(wifi),
      wired: get(wired)
    }
    let percentage = parseInt(get(percent))
    let battery: BatteryProps = {
      visible: true,
      percent: parseInt(get(percent)),
      color: "red"
    }
    if (get(batteryState) === AstalBattery.State.CHARGING) {
      battery.color = "aqua"
    } else {
      if (percentage >= 90) {
        battery.color = "green"
      } else if (percentage >= 50) {
        battery.color = "yellow"
      } else {
        battery.color = "red"
      }
    }
    let bluetooth: BluetoothProps = {
      icon: !get(isPowered) ? "󰂲 " : get(isConnected) ? "󰂰 " : "󰂯",
      device: !get(isPowered) ? "Off" : get(connectedTo),
      color: !get(isPowered) ? "white" : get(isConnected) ? "aqua" : "green",
      bg: !get(isPowered) ? "white" : get(isConnected) ? "darkblue" : "blue"
    }
    print({ wireless, battery, bluetooth })
    return {
      wireless,
      battery,
      bluetooth
    }
  })

  return (
    <With value={listeners}>
      {(listeners) => (
        <box
          spacing={10}
          orientation={Gtk.Orientation.HORIZONTAL}
        >
          <Bluetooth {...listeners.bluetooth} />
          <Wireless {...listeners.wireless} />
          <Battery {...listeners.battery} />
        </box>
      )}
    </With>
  )
}
