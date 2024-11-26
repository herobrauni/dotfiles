-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- close without asking
config.window_close_confirmation = 'NeverPrompt'

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Macchiato'

-- disable tab bar if only one tab
config.hide_tab_bar_if_only_one_tab = true

-- split pane
config.keys = {
    { key = '\\', mods = 'CMD', action = wezterm.action.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
    { key = '-', mods = 'CMD', action = wezterm.action.SplitVertical{ domain =  'CurrentPaneDomain' } },
}

-- set home dir
config.default_cwd = "/home/brauni"
-- Spawn nushell
-- config.default_prog = { '/var/home/linuxbrew/.linuxbrew/bin/nu'}
config.default_prog = { 'distrobox', 'enter', 'archbox' , '-e' , 'nu'}
-- and finally, return the configuration to wezterm
return config
