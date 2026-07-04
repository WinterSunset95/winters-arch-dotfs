local awful = require("awful")

local global_mouse = {
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
}

return {
  global_mouse
}
