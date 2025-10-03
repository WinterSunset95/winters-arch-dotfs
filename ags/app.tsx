import { createBinding, For, This } from "ags"
import app from "ags/gtk4/app"
import style from "./style.scss"
import Bar from "./widgets/bar/Bar"
import Menu from "./widgets/menu/Menu"

app.start({
  css: style,
  // It's usually best to go with the default Adwaita theme
  // and built off of it, instead of allowing the system theme
  // to potentially mess something up when it is changed.
  // Note: `* { all:unset }` in css is not recommended.
  gtkTheme: "Adwaita-dark",
  main(...args: Array<string>) {
    const monitors = createBinding(app, "monitors")

    return (
      <For each={monitors}>
        {(monitor) => (
          <This this={app}>
            <Bar gdkmonitor={monitor} />
            <Menu gdkmonitor={monitor} />
          </This>
        )}
      </For>
    )
  },
  requestHandler(request: string[], res: (response: any) => void) {
    print(request);
  }
})
