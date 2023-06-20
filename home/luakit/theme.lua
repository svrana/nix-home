--------------------------
-- Default luakit theme --
--------------------------

local theme = {}

-- Default settings
theme.font = "18px DejaVu Sans Mono"
theme.fg = "#fff"
theme.bg = "#000"

-- Genaral colours
local base03 = "#002b36"
local base02 = "#073642"
local base01 = "#586e75"
local base00 = "#657b83"
local base0 = "#839496"
local base1 = "#93a1a1"
local base2 = "#eee8d5"
local base3 = "#fdf6e3"
local yellow = "#b58900"
local orange = "#cb4b16"
local red = "#dc322f"
local magenta = "#d33682"
local violet = "#6c71c4"
local blue = "#268bd2"
local cyan = "#2aa198"
local green = "#859900"
local white = "#fff"
local black = "#000"

theme.success_fg = "#0f0"
theme.loaded_fg = "#33AADD"
theme.error_fg = "#FFF"
theme.error_bg = "#F00"

-- Warning colours
theme.warning_fg = "#F00"
theme.warning_bg = "#FFF"

-- Notification colours
theme.notif_fg = "#444"
theme.notif_bg = "#FFF"

-- Menu colours
theme.menu_fg = base00
theme.menu_bg = base02
theme.menu_selected_fg = "#000"
theme.menu_selected_bg = cyan
theme.menu_title_bg = base01
theme.menu_primary_title_fg = white
theme.menu_secondary_title_fg = "#666"

theme.menu_disabled_fg = "#999"
theme.menu_disabled_bg = theme.menu_bg
theme.menu_enabled_fg = theme.menu_fg
theme.menu_enabled_bg = theme.menu_bg
theme.menu_active_fg = "#060"
theme.menu_active_bg = theme.menu_bg

-- Proxy manager
theme.proxy_active_menu_fg = "#000"
theme.proxy_active_menu_bg = "#FFF"
theme.proxy_inactive_menu_fg = "#888"
theme.proxy_inactive_menu_bg = "#FFF"

-- Statusbar specific
theme.sbar_fg = white
theme.sbar_bg = base02

-- Downloadbar specific
theme.dbar_fg = "#fff"
theme.dbar_bg = "#000"
theme.dbar_error_fg = "#F00"

-- Input bar specific
theme.ibar_fg = white
theme.ibar_bg = base03

-- Tab label
theme.tab_fg = black
theme.tab_bg = base00
theme.tab_hover_bg = cyan
theme.tab_ntheme = "#ddd"
theme.selected_fg = white
theme.selected_bg = base1
theme.selected_ntheme = "#ddd"
theme.loading_fg = "#33AADD"
theme.loading_bg = "#000"

theme.selected_private_tab_bg = "#3d295b"
theme.private_tab_bg = "#22254a"

-- Trusted/untrusted ssl colours
theme.trust_fg = "#0F0"
theme.notrust_fg = "#F00"

-- Follow mode hints
theme.hint_font = "16px monospace, courier, sans-serif"
theme.hint_fg = base01
theme.hint_bg = base2
theme.hint_border = "1px #2aa198"
theme.hint_opacity = "0"
theme.hint_overlay_bg = "rgba(255,255,153,0.3)"
theme.hint_overlay_border = "1px dotted #000"
theme.hint_overlay_selected_bg = "rgba(0,255,0,0.3)"
theme.hint_overlay_selected_border = theme.hint_overlay_border

-- General colour pairings
theme.ok = { fg = "#000", bg = "#FFF" }
theme.warn = { fg = "#F00", bg = "#FFF" }
theme.error = { fg = "#FFF", bg = "#F00" }

-- Gopher page style (override defaults)
theme.gopher_light = { bg = "#E8E8E8", fg = "#17181C", link = "#03678D" }
theme.gopher_dark = { bg = "#17181C", fg = "#E8E8E8", link = "#f90" }

return theme

-- vim: et:sw=4:ts=8:sts=4:tw=80
