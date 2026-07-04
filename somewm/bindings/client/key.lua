local awful = require("awful")
local menubar = require("menubar")
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
local mod = require("bindings.mod")
local apps = require("config.apps")

-- client
local client_binds = {
  awful.key {
    modifiers   = { mod.super },
    key         = "f",
    on_press    = function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    description = "toggle fullscreen",
    group       = "client",
  },
  awful.key {
    modifiers   = { mod.super, "Shift" },
    key         = "c",
    on_press    = function(c) c:kill() end,
    description = "close",
    group       = "client",
  },
  awful.key {
    modifiers   = { mod.super, "Control" },
    key         = "space",
    on_press    = function(c) c.floating = not c.floating end,
    description = "toggle floating",
    group       = "client",
  },
  awful.key {
    modifiers   = { mod.super, "Control" },
    key         = "Return",
    on_press    = function(c) c:swap(awful.client.visible(c.screen)[1]) end,
    description = "move to master",
    group       = "client",
  },
  awful.key {
    modifiers   = { mod.super },
    key         = "o",
    on_press    = function(c) c:move_to_screen() end,
    description = "move to screen",
    group       = "client",
  },
  awful.key {
    modifiers   = { mod.super },
    key         = "t",
    on_press    = function(c) c.ontop = not c.ontop end,
    description = "toggle keep on top",
    group       = "client",
  },
  awful.key {
    modifiers   = { mod.super },
    key         = ",",
    on_press    = function(c) c.sticky = not c.sticky end,
    description = "toggle sticky (show on all tags)",
    group       = "client",
  },
  awful.key {
    modifiers   = { mod.super },
    key         = "n",
    on_press    = function(c) c.minimized = true end,
    description = "minimize",
    group       = "client",
  },
  awful.key {
    modifiers   = { mod.super },
    key         = "m",
    on_press    = function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    description = "(un)maximize",
    group       = "client",
  },
  awful.key {
    modifiers   = { mod.super, "Control" },
    key         = "m",
    on_press    = function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end,
    description = "(un)maximize vertically",
    group       = "client",
  },
  awful.key {
    modifiers   = { mod.super, "Shift" },
    key         = "m",
    on_press    = function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end,
    description = "(un)maximize horizontally",
    group       = "client",
  },
}

return {
  client_binds,
}
