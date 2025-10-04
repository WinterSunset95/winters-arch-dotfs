import { Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import Astal from "gi://Astal?version=4.0";
import Gdk from "gi://Gdk?version=4.0";
import AstalCava from "gi://AstalCava?version=0.1";
import { createBinding, createComputed, onCleanup } from "gnim";
import Cairo from "gi://cairo"
import { timeout } from "ags/time";
import VerticalLabel from "../../common/VerticalLabel";
import { hexToRgba } from "../../lib/utils/strings";


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

export default function RightBar({ gdkmonitor }: { gdkmonitor: Gdk.Monitor }) {
  let vertical = true;
  let intensity = 2;
  let length = 200;
  let size = 20;
  let [r, g, b, a] = [1, 1, 1, 1];
  let flipStart = true;
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
      class={"bar"}
    >
      <box $type="start" orientation={Gtk.Orientation.VERTICAL}>
        <box
          // marginTop={10}
          // marginBottom={10}
          // marginStart={10}
          // marginEnd={10}
          vexpand={true}
          hexpand={true}
          widthRequest={30}
        >
          {drawing}
        </box>
        <box orientation={Gtk.Orientation.HORIZONTAL}>
          <VerticalLabel
            text={"Hello"}
            fontSize={10}
            flipped={flipStart}
            bold={false}
            alignment={Gtk.Align.START}
            minimumHeight={0}
            font={"monospace"}
            foregroundColor={createComputed(() => "#ffffff")}
          />
          <VerticalLabel
            text={"there"}
            fontSize={10}
            flipped={flipStart}
            bold={false}
            alignment={Gtk.Align.START}
            minimumHeight={0}
            font={"monospace"}
            foregroundColor={createComputed(() => "#ffffff")}
          />
        </box>
      </box>
    </window>
  );
}
