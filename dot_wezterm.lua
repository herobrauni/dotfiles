-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Macchiato'

-- disable tab bar if only one tab
config.hide_tab_bar_if_only_one_tab = true

-- set home dir
config.default_cwd = "/home/brauni"
-- Spawn nushell
config.default_prog = { '/var/home/linuxbrew/.linuxbrew/bin/nu'}

-- and finally, return the configuration to wezterm
return config
