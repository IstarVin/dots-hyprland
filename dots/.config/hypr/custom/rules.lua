-- You can put custom rules here
-- Window/layer rules: https://wiki.hyprland.org/Configuring/Window-Rules/
-- Workspace rules: https://wiki.hyprland.org/Configuring/Workspace-Rules/

-- Special Workspace
hl.workspace_rule({ workspace = "special:facebook", on_created_empty = [[brave --app="https://facebook.com"]] })
hl.workspace_rule({ workspace = "special:music", on_created_empty = "youtube-music" })
hl.workspace_rule({ workspace = "special:deepseek", on_created_empty = [[brave --user-data-dir="/mnt/AJ/.deepseek" --app="https://chat.deepseek.com/"]] })
hl.workspace_rule({ workspace = "special:chatgpt", on_created_empty = [[brave --user-data-dir="/mnt/AJ/.chatgpt" --app="https://chatgpt.com/"]] })
hl.workspace_rule({ workspace = "special:win11", on_created_empty = "looking-glass-client -F" })
hl.workspace_rule({ workspace = "special:waydroid", on_created_empty = "waydroid show-full-ui" })

-- # Window Rules
hl.window_rule({ match = { workspace = "special:waydroid" }, fullscreen = true })

hl.window_rule({
    match = { title = "FloatingTerminal" },
    size = { "(monitor_w*0.99)", "(monitor_h*0.4)" },
    move = { "(monitor_w*0.005)", "(monitor_h*0.595)" },
    opacity = "0.85",
    no_blur = true
})

hl.window_rule({
    match = { class = "TempBrowser" },
    size = { "(monitor_w*0.99)", "(monitor_h*0.5)" },
    move = { "(monitor_w*0.005)", "(monitor_h*0.495)" },
    opacity = "0.90",
    float = true,
    no_blur = true
})

-- Floating AI
local browsers = { "brave", "thorium" }
for i = 1, #browsers do
    local class_regex = "^" .. browsers[i] .. "-([a-z]+\\.)*[a-z]+\\.*(__[a-z\\-]*Default)"
    hl.window_rule({
        match = { class = class_regex },
        move = { "(monitor_w*0.005)", "(monitor_h*0.045)" },
        size = { "(monitor_w*0.35)", "(monitor_h*0.945)" },
        opacity = "0.89 override",
        no_blur = true
    })
end

hl.window_rule({ match = { class = "(.*)facebook\\.com(.*)" }, opaque = true })

-- MPV
hl.window_rule({
    match = { class = "mpv" },
    float = true,
    center = true,
    size = { "(monitor_w*0.7)", "(monitor_h*0.7)" },
    opacity = "1"
})

-- Open YouTube Music to special workspace
hl.window_rule({ match = { class = "^(com.github.th_ch.youtube_music)$" }, workspace = "special:music" })

local blur_classes = { "code", "org.gnome.Nautilus", "kitty" }
for i = 1, #blur_classes do
    hl.window_rule({ match = { class = blur_classes[i] }, opacity = "0.89 override 0.89 override", no_blur = false })
end

-- Uncomment to apply global transparency to all windows:
-- hl.window_rule({ match = { class = ".*" }, opacity = "0.89 override 0.89 override" })

-- Disable blur for all xwayland apps
-- hl.window_rule({ match = { xwayland = 1 }, no_blur = true })

-- Make 100% Opaque
hl.window_rule({ match = { title = "(.*)(- YouTube)(.*)" }, opacity = "1 override" })
hl.window_rule({ match = { class = "^(virt-viewer)$" }, opacity = "1 override" })

-- Layer Rules
hl.layer_rule({ match = { namespace = "code" }, no_anim = true })
