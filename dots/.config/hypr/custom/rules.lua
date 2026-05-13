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

hl.window_rule({ match = { workspace = "special:waydroid" }, fullscreen = true })

-- Floating Terminal
hl.window_rule({ match = { title = "FloatingTerminal" }, size = { "(monitor_w*0.99)", "(monitor_h*0.4)" } })
hl.window_rule({ match = { title = "FloatingTerminal" }, move = { "(monitor_w*0.005)", "(monitor_h*0.595)" } })
hl.window_rule({ match = { title = "FloatingTerminal" }, opacity = "0.85" })
hl.window_rule({ match = { title = "FloatingTerminal" }, no_blur = true })

-- Temp Browser
hl.window_rule({ match = { class = "TempBrowser" }, size = { "(monitor_w*0.99)", "(monitor_h*0.5)" } })
hl.window_rule({ match = { class = "TempBrowser" }, move = { "(monitor_w*0.005)", "(monitor_h*0.495)" } })
hl.window_rule({ match = { class = "TempBrowser" }, opacity = "0.90" })
hl.window_rule({ match = { class = "TempBrowser" }, no_blur = true })
hl.window_rule({ match = { class = "TempBrowser" }, float = true })

-- Floating AI
hl.window_rule({ match = { class = "^brave-([a-z]+\\.)*[a-z]+\\.*(__[a-z\\-]*Default)" }, size = { "(monitor_w*0.41)", "(monitor_h*0.945)" } })
hl.window_rule({ match = { class = "^brave-([a-z]+\\.)*[a-z]+\\.*(__[a-z\\-]*Default)" }, move = { "(monitor_w*0.005)", "(monitor_h*0.045)" } })
hl.window_rule({ match = { class = "^thorium-([a-z]+\\.)*[a-z]+\\.*(__[a-z\\-]*Default)" }, size = { "(monitor_w*0.41)", "(monitor_h*0.945)" } })
hl.window_rule({ match = { class = "^thorium-([a-z]+\\.)*[a-z]+\\.*(__[a-z\\-]*Default)" }, move = { "(monitor_w*0.005)", "(monitor_h*0.045)" } })

-- MPV
hl.window_rule({ match = { class = "mpv" }, float = true })
hl.window_rule({ match = { class = "mpv" }, center = true })
hl.window_rule({ match = { class = "mpv" }, size = { "(monitor_w*0.7)", "(monitor_h*0.7)" } })
hl.window_rule({ match = { class = "mpv" }, opacity = "1" })

-- Make 100% Opaque
hl.window_rule({ match = { title = "(.*)(- YouTube)(.*)" }, opacity = "1 override" })
hl.window_rule({ match = { class = "^(virt-viewer)$" }, opacity = "1 override" })

-- Open YouTube Music to special workspace
hl.window_rule({ match = { class = "^(com.github.th_ch.youtube_music)$" }, workspace = "special:music" })

-- ######## Window rules ########

-- Uncomment to apply global transparency to all windows:
-- hl.window_rule({ match = { class = ".*" }, opacity = "0.89 override 0.89 override" })

-- Disable blur for all xwayland apps
-- hl.window_rule({ match = { xwayland = 1 }, no_blur = true })
