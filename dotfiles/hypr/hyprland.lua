-- #######################################################################################
-- HYPRLAND LUA CONFIGURATION
-- Modular Lua setup for Hyprland 0.55+
-- #######################################################################################

local home = os.getenv("HOME") or "/home/louis"
local config_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)") or (home .. "/.config/hypr/")
package.path = config_dir .. "?.lua;" .. config_dir .. "?/init.lua;" .. home .. "/.config/hypr/?.lua;" .. home .. "/.config/hypr/?/init.lua;" .. package.path

require("hyprland.monitors")
require("hyprland.programs")
require("hyprland.execs")
require("hyprland.env")
require("hyprland.general")
require("hyprland.group")
require("hyprland.decoration")
require("hyprland.animations")
require("hyprland.misc")
require("hyprland.input")
require("hyprland.keybinds")
require("hyprland.rules")
