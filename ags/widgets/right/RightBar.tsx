import { Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import Astal from "gi://Astal?version=4.0";
import Gdk from "gi://Gdk?version=4.0";
import AstalCava from "gi://AstalCava?version=0.1";
import { createBinding, createComputed, onCleanup, With } from "gnim";
import Cairo from "gi://cairo"
import { timeout } from "ags/time";
import VerticalLabel from "../../common/VerticalLabel";
import { hexToRgba } from "../../lib/utils/strings";
import AstalMpris from "gi://AstalMpris?version=0.1";


function getCoordinate(
    value: number,
    size: number,
    flipStart: boolean,
    intensity: number,
) {
    const magicSize = size * intensity
    if (flipStart) {
        // subtract 1 to make it align with the bar if the line should be flat
        return Math.min(size, (value * magicSize) - 1)
    }
    // add 1 to make it align with the bar if the line should be flat
    return Math.max(0, size - (value * magicSize) + 1)
}

function moveTo(
    cr: Cairo.Context,
    vertical: boolean,
    length: number,
    size: number,
) {
    if (vertical) {
        // @ts-ignore
        cr.moveTo(size, length)
    } else {
        // @ts-ignore
        cr.moveTo(length, size)
    }
}

function lineTo(
    cr: Cairo.Context,
    vertical: boolean,
    length: number,
    size: number,
) {
    if (vertical) {
        // @ts-ignore
        cr.lineTo(size, length)
    } else {
        // @ts-ignore
        cr.lineTo(length, size)
    }
}

// Weird things happen if there are over 200 bars
function setBars(cava: AstalCava.Cava, length: number) {
    cava.bars = Math.min(200, length / 10)
}

function Spotify() {
  let flipStart = true;
  const spotify = AstalMpris.Player.new("spotify")
  const title = createBinding(spotify, "title")((p) => p.length >= 20 ? p.slice(0, 18) + "..." : p)
  const artist = createBinding(spotify, "artist")((p) => p.length >= 20 ? p.slice(0, 20) + "..." : p)
  const playbackStatus = createBinding(spotify, "playbackStatus")
  const watchlist = createComputed((get) => ({
    artist: get(artist),
    title: get(title),
    playbackStatus: get(playbackStatus),
  }))
  return (
    <With value={watchlist}>
      {(watchlist) => (
        <box
            orientation={Gtk.Orientation.VERTICAL}
            marginStart={5}
            marginEnd={5}
        >
              <box 
                hexpand={true}
                halign={Gtk.Align.CENTER}
                orientation={Gtk.Orientation.HORIZONTAL}
                heightRequest={200}
              >
                <VerticalLabel
                  text={watchlist.artist}
                  fontSize={10}
                  flipped={flipStart}
                  bold={false}
                  alignment={Gtk.Align.CENTER}
                  font={"monospace"}
                  foregroundColor={createComputed(() => "#ffffff")}
                />
                <VerticalLabel
                  text={watchlist.title}
                  fontSize={15}
                  flipped={flipStart}
                  bold={true}
                  alignment={Gtk.Align.CENTER}
                  font={"monospace"}
                  foregroundColor={createComputed(() => "#ffffff")}
                />
              </box>
              <box
                valign={Gtk.Align.CENTER}
                orientation={Gtk.Orientation.VERTICAL}
                spacing={5}
                marginTop={30}
                marginBottom={30}
              >
                <button class={"player-button"} onClicked={() => spotify.next()}>
                  <label label={"󰒭"} />
                </button>
                <button class={"player-button"} onClicked={() => spotify.play_pause()}>
                  <image iconName={`${watchlist.playbackStatus ? "media-playback-start-symbolic" : "media-playback-pause-symbolic"}`}/>
                </button>
                <button class={"player-button"} onClicked={() => spotify.previous()}>
                  <label label={"󰒮"} />
                </button>
              </box>
        </box>
      )}
    </With>
  )
}

export default function RightBar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let vertical = true;
  let intensity = 2;
  let length = 100;
  let size = 40;
  let [r, g, b, a] = [1, 1, 1, 1];
  let expand = true;

  const { TOP, LEFT, RIGHT, BOTTOM } = Astal.WindowAnchor;

  const cava = new AstalCava.Cava()
  cava.input = AstalCava.Input.PIPEWIRE

  setBars(cava, length)

  onCleanup(() => {
    cava.set_active(false)
  })

  const drawing = new Gtk.DrawingArea({
    hexpand: vertical ? false : expand,
    vexpand: vertical ? expand : false,
    height_request: vertical ? length : size,
    width_request: vertical ? size : length,
  })

  drawing.set_draw_func((
    area: Gtk.DrawingArea,
    cr: Cairo.Context,
    drawWidth: number,
    drawHeight: number
  ) => {
    const drawLength = vertical ? drawHeight : drawWidth
    const drawSize = vertical ? drawWidth : drawHeight
    let flip = false

    // @ts-ignore
    cr.setSourceRGBA(r, g, b, a)

    // @ts-ignore
    cr.setLineWidth(2)

    let x = 0
    const values = cava.values
    // add one to even the ends out
    const spacing = drawLength / (values.length * 2 + 1)

    values.reverse()

    // add or subtract 1 to make it align with the bar if the line should be flat
    moveTo(cr, vertical, x, flip ? -1 : drawSize + 1)

  values.forEach((value) => {
    x = x + spacing
    lineTo(cr, vertical, x, getCoordinate(value, drawSize, flip, intensity))
  })

  values.reverse()

  values.forEach((value) => {
    x = x + spacing
    lineTo(cr, vertical, x, getCoordinate(value, drawSize, flip, intensity))
  })

  // add or subtract 1 to make it align with the bar if the line should be flat
  lineTo(cr, vertical, drawLength, flip ? -1 : drawSize + 1)

  // @ts-ignore
  cr.stroke()
  })

  // Unsubscribe when the waveform isn't visible
  let unsubscribe: (() => void) | null = null

  drawing.connect("map", () => {
    // set the number of bars after 2 seconds so that size has been allocated.  Not sure how to detect allocation,
    // so just using a timer
    timeout(2000, () => {
      const drawLength = vertical
        ? drawing.get_height()
        : drawing.get_width()
        if (drawLength > 0) {
          setBars(cava, drawLength)
        }
    })

    unsubscribe = createBinding(cava, "values").subscribe(() => {
      drawing.queue_draw()
    })
  })

  drawing.connect("unmap", () => {
    if (unsubscribe) {
      unsubscribe()
      unsubscribe = null
    }
  })


  return (
    <window
      visible
      namespace="my-bar"
      name={`right-bar`}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | BOTTOM | RIGHT}
      application={app}
      class={"bar right"}
    >
      <box $type="start" orientation={Gtk.Orientation.VERTICAL}>
        <box
          marginTop={50}
          marginBottom={50}
          marginStart={0}
          marginEnd={0}
          vexpand={true}
          hexpand={true}
        >
          {drawing}
        </box>
        <Spotify />
      </box>
    </window>
  );
}
