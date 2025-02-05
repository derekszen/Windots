-- Initialize Configuration
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local opacity = 1
local transparent_bg = "rgba(22, 24, 26, " .. opacity .. ")"

--- Get the current operating system
-- @return "windows"| "linux" | "macos"
local function get_os()
    local bin_format = package.cpath:match("%p[\\|/]?%p(%a+)")
    if bin_format == "dll" then
        return "windows"
    elseif bin_format == "so" then
        return "linux"
    elseif bin_format == "dylib" then
        return "macos"
    end
end

local host_os = get_os()

-- Font Configuration
local emoji_font = "Segoe UI Emoji"
config.font = wezterm.font_with_fallback({
    {
        family = "JetBrainsMono Nerd Font",
        weight = "Regular",
    },
    emoji_font,
})
config.font_size = 10

-- Color Configuration
config.colors = require("cyberdream")
config.force_reverse_video_cursor = true

-- Window Configuration
config.initial_rows = 45
config.initial_cols = 180
config.window_decorations = "TITLE"  -- Use TITLE for title bar but no resizing
config.integrated_title_buttons = { "Hide", "Maximize", "Close" } -- This line may not be necessary with TITLE
config.window_background_opacity = opacity
config.window_background_image = (os.getenv("WEZTERM_CONFIG_FILE") or ""):gsub("wezterm.lua", "bg-blurred.png")
config.window_close_confirmation = "NeverPrompt"
config.win32_system_backdrop = "Acrylic"
<<<<<<< HEAD
config.max_fps = 120
config.animation_fps = 60
config.cursor_blink_rate = 250

if os == "linux" then
    config.front_end = "WebGpu"
end
=======

-- Performance Settings
config.max_fps = 144
config.animation_fps = 60
config.cursor_blink_rate = 250
>>>>>>> c483411811366a1a9922a2d1403409bc5fc7ddf9

-- Tab Bar Configuration
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = false
config.colors.tab_bar = {
    background = transparent_bg,
    new_tab = { fg_color = config.colors.background, bg_color = config.colors.brights[6] },
    new_tab_hover = { fg_color = config.colors.background, bg_color = config.colors.foreground },
}

-- Tab Formatting
wezterm.on("format-tab-title", function(tab, _, _, _, hover)
    local background = config.colors.brights[1]
    local foreground = config.colors.foreground

    if tab.is_active then
        background = config.colors.brights[7]
        foreground = config.colors.background
    elseif hover then
        background = config.colors.brights[8]
        foreground = config.colors.background
    end

    local title = tostring(tab.tab_index + 1)
    return {
        { Foreground = { Color = background } },
        { Text = "█" },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Foreground = { Color = background } },
        { Text = "█" },
    }
end)

-- Keybindings
config.keys = {
    { key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },

    -- Switch tabs with Alt+Q and Alt+E
    { key = "q", mods = "ALT", action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = "e", mods = "ALT", action = wezterm.action({ ActivateTabRelative = 1 }) },

    -- Create new tab with Alt+C and Ctrl+T
    { key = "c", mods = "ALT", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "t", mods = "CTRL", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
}

-- Default Shell Configuration
config.default_prog = { "pwsh", "-NoLogo" }

-- OS-Specific Overrides
if host_os == "linux" then
    emoji_font = "Noto Color Emoji"
    config.default_prog = { "zsh" }
    config.front_end = "WebGpu"
    config.window_background_image = os.getenv("HOME") .. "/.config/wezterm/bg-blurred.png"
    config.window_decorations = nil -- use system decorations
end

return config
