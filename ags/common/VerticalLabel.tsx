import Cairo from "cairo";
import {Gtk} from "ags/gtk4";
import {Accessor, createComputed, onCleanup, With} from "ags";
import { isAccessor } from "../lib/utils/bindings";
import { hexToRgba } from "../lib/utils/strings";

export default function VerticalLabel(
    {
        text,
        fontSize,
        flipped,
        bold,
        alignment = Gtk.Align.CENTER,
        minimumHeight = 0,
        font,
        foregroundColor,
    }:
    {
        text: string | Accessor<string>,
        fontSize: number,
        flipped: boolean | Accessor<boolean>,
        bold: boolean,
        alignment?: Gtk.Align,
        minimumHeight?: number,
        font: string,
        foregroundColor: Accessor<string>
    }
) {
    const area = new Gtk.DrawingArea()
    area.set_content_width(fontSize)

    let realText = ""
    if (isAccessor(text)) {
        const unsub = text.subscribe(() => {
            realText = text.get()
            area.queue_draw()
        })
        onCleanup(unsub)
        realText = text.get()
    } else {
        realText = text
    }

    let realFlipped = false
    if (isAccessor(flipped)) {
        const unsub = flipped.subscribe(() => {
            realFlipped = flipped.get()
            area.queue_draw()
        })
        onCleanup(unsub)
        realFlipped = flipped.get()
    } else {
        realFlipped = flipped
    }

    let [r, g, b, a] = hexToRgba(foregroundColor.get())

    const unsub = foregroundColor.subscribe(() => {
        [r, g, b, a] = hexToRgba(foregroundColor.get())
        area.queue_draw()
    })
    onCleanup(unsub)

    area.set_draw_func((widget, cr, width, height) => {
        // @ts-ignore
        cr.save()
        // @ts-ignore
        cr.translate(realFlipped ? width / 4 : width * 3/4, (height / 2) - 8)
        // @ts-ignore
        cr.rotate(realFlipped ? Math.PI / 2 : -Math.PI / 2) // 90 degrees counterclockwise
        // @ts-ignore
        cr.setSourceRGBA(r, g, b, a)
        // @ts-ignore
        cr.selectFontFace(font, Cairo.FontSlant.NORMAL, bold ? Cairo.FontWeight.BOLD : Cairo.FontWeight.NORMAL)// @ts-ignore
        cr.setFontSize(fontSize)

        // @ts-ignore
        const extents = cr.textExtents(realText)
        const textWidth = extents.width
        const textHeight = extents.height

        // align the text
        let y
        if (alignment === Gtk.Align.CENTER) {
            y = -textWidth / 2
        } else if ((alignment === Gtk.Align.START && flipped) || (alignment === Gtk.Align.END && !flipped)) {
            y = -height / 2
        } else {
            y = (height / 2) - textWidth
        }

        const x = (width - textHeight) / 2
        // @ts-ignore
        cr.moveTo(y, x)

        // @ts-ignore
        cr.showText(realText)
        // @ts-ignore
        cr.restore()

        // textWidth is height when rotated
        area.set_content_height(textWidth)
    })

    return <box
        heightRequest={minimumHeight}>
        {area}
    </box>
}

