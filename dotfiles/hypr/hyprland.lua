local home = os.getenv("HOME") or "/home/louis"
package.path = home .. "/.config/hypr/?.lua;" .. package.path

local config_dir = home .. "/.config/hypr/hyprland/"

dofile(config_dir .. "env.lua")
dofile(config_dir .. "general.lua")
dofile(config_dir .. "input.lua")
dofile(config_dir .. "decoration.lua")
dofile(config_dir .. "animations.lua")
dofile(config_dir .. "group.lua")
dofile(config_dir .. "gestures.lua")
dofile(config_dir .. "misc.lua")
dofile(config_dir .. "execs.lua")
dofile(config_dir .. "keybinds.lua")
dofile(config_dir .. "rules.lua")
