local awful = require("awful")
local mod = require("bindings.mod")

local client_mouse = {
  awful.button({ }, 1, function(c)
    c:activate { context = "mouse_click" }
  end),
  awful.button({ mod.super }, 1, function(c)
    c:activate { context = "mouse_click", action = "mouse_move" }
  end),
  awful.button({ mod.super }, 3, function(c)
    c:activate { context = "mouse_click", action = "mouse_resize" }
  end),
}

return {
  client_mouse
}
