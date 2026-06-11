require("hyprland.lib")

-- See https://wiki.hyprland.org/Configuring/Binds/
--#!
--##! User
hl.bind("CTRL + SUPER + Slash", hl.dsp.exec_cmd("xdg-open ~/.config/illogical-impulse/config.json"), { description = "Edit shell config" })
hl.bind("CTRL + SUPER + ALT + Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), { description = "Edit extra keybinds" })

-- Add stuff here
-- Use #! to add an extra column on the cheatsheet
-- Use ##! to add a section in that column
-- Add a comment after a bind to add a description, like above

local scriptsDir = "~/.config/hypr/custom/scripts"

-- Unbinds
hl.unbind("SUPER + Return")
hl.unbind("SUPER + R")
hl.unbind("SUPER + T")
hl.unbind("SUPER + W")
hl.unbind("SUPER + A")
hl.unbind("SUPER + SHIFT + W")
hl.unbind("SUPER + SHIFT + B")
hl.unbind("SUPER + SHIFT + M")
hl.unbind("SUPER + G")
hl.unbind("SUPER + C")
hl.unbind("SUPER + SHIFT + G")
hl.unbind("SUPER + E")
hl.unbind("SUPER + CTRL + SHIFT + E")
hl.unbind("SUPER + SHIFT + E")
hl.unbind("SUPER + SHIFT + Space")
hl.unbind("SUPER + CTRL + Space")
hl.unbind("SUPER + SHIFT + X")
hl.unbind("SUPER + SHIFT + Z")

hl.unbind("SUPER + S")
hl.unbind("XF86AudioPlay")
hl.unbind("SUPER + ALT + Right")
hl.unbind("SUPER + ALT + Left")

--##! Apps
hl.bind("SUPER + R", hl.dsp.exec_cmd("kitty"), { description = "Terminal (Kitty)" })
hl.bind("SUPER + T", hl.dsp.exec_cmd(scriptsDir .. "/minimize.py \"title:FloatingTerminal\" \"kitty -T FloatingTerminal\""), { description = "Floating Terminal (Kitty)" })
hl.bind("SUPER + W", hl.dsp.exec_cmd("brave"), { description = "Browser (Brave)" })
hl.bind("SUPER + A", hl.dsp.exec_cmd(scriptsDir .. "/minimize.py \"class:TempBrowser\" \"brave --class=TempBrowser --user-data-dir=/mnt/AJ/.brave/temp\""), { description = "Temp Browser (Brave)" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("brave --user-data-dir=\"/mnt/AJ/.brave/hehe\"")) -- # [hidden]
hl.bind("SUPER + SHIFT + B", hl.dsp.workspace.toggle_special("facebook"), { description = "Facebook" })
hl.bind("SUPER + SHIFT + M", hl.dsp.workspace.toggle_special("music"), { description = "Youtube Music" })
hl.bind("SUPER + G", hl.dsp.exec_cmd(scriptsDir .. "/minimize.py \"class:brave-chat.deepseek.com__-Default\" \"brave --user-data-dir=/mnt/AJ/.deepseek --app=https://chat.deepseek.com/\""), { description = "Temp Browser (Brave)" })
hl.bind("SUPER + grave", hl.dsp.exec_cmd(scriptsDir .. "/minimize.py \"class:brave-www.perplexity.ai__-Default\" \"brave --user-data-dir=/mnt/AJ/.perplexity --app=https://www.perplexity.ai/\""), { description = "Temp Browser (Brave)" })
hl.bind("SUPER + SHIFT + grave", hl.dsp.exec_cmd(scriptsDir .. "/minimize.py \"class:brave-claude.ai__new-Default\" \"brave --user-data-dir=/mnt/AJ/.claude --app=https://claude.ai/new\""), { description = "Temp Browser (Brave)" })
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd(scriptsDir .. "/minimize.py \"class:brave-chatgpt.com__-Default\" \"brave --user-data-dir=/mnt/AJ/.chatgpt --app=https://chatgpt.com/\""), { description = "Temp Browser (Brave)" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus -w"), { description = "Nautilus" })
hl.bind("SUPER + CTRL + Space", hl.dsp.exec_cmd([[kitty --title Project -e zsh -c "source ~/.zshrc && ~/.bin/sessionizer"]]), { description = "Project Tmux Launcher" })
hl.bind("SUPER + SHIFT + Space", hl.dsp.exec_cmd([[kitty -e zsh -c "source ~/.zshrc && ~/.bin/sessionizer --code"]]), { description = "Project Code Launcher" })
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd([[kitty -e zsh -c "source ~/.zshrc && ~/.bin/sessionizer --code-insider"]]), { description = "Project Code Launcher" })
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd(scriptsDir .. "/startvm.sh win11"), { description = "Windows 11 VM" })
hl.bind("SUPER + SHIFT + D", hl.dsp.workspace.toggle_special("waydroid"))

hl.bind("SUPER + SHIFT + Tab", hl.dsp.global("quickshell:oskToggle"), { description = "Toggle on-screen keyboard" })

--##! Workspace
hl.bind("SUPER + S", hl.dsp.exec_cmd(scriptsDir .. "/togglespecial.py"), { description = "Toggle Special Workspace" })
--#/# bind = ALT+SUPER, ←/→,, # Focus 10 workspace left/right
hl.bind("SUPER + ALT + Right", hl.dsp.focus({ workspace = "r+10" }))
hl.bind("SUPER + ALT + Left", hl.dsp.focus({ workspace = "r-10" }))

--##! Moving
--#/# bind = SUPER+SHIFT, Hash,, # Move to workspace # (1, 2, 3,...)
for i = 1, 10 do
    local key = i == 10 and 0 or i
    hl.bind("SUPER + SHIFT + " .. tostring(key), function()
        hl.dispatch(hl.dsp.window.move({ workspace = workspace_in_group(key) }))
    end)
end

-- Action
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(scriptsDir .. "/music.py"), { locked = true })                                                                                    -- # [hidden]
hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd("asusctl leds next"))                                                                                                       -- # [hidden]
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("asusctl leds prev"))                                                                                                     -- # [hidden]

hl.bind("XF86AudioNext", hl.dsp.exec_cmd([[playerctl next || playerctl position `bc <<< "100 * $(playerctl metadata mpris:length) / 1000000 / 100"`]]), { locked = true }) -- # [hidden]
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })                                                                                         -- # [hidden]

-- Misc
hl.bind("SUPER + CTRL + SHIFT + E", hl.dsp.exec_cmd(scriptsDir .. "/opensecret.sh /mnt/AJ/.secrets $HOME/.secrets")) -- # [hidden]
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd(scriptsDir .. "/opensecret.sh /mnt/AJ/.hehe $HOME/.hehe"))              -- # [hidden]

hl.unbind("SUPER + H")
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))                                -- # [hidden]
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))                                -- # [hidden]
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))                                -- # [hidden]
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))                                -- # [hidden]

hl.bind("SUPER + Backspace", hl.dsp.exec_cmd("loginctl lock-session"))                 -- # [hidden]

hl.bind("CTRL + ALT + A", hl.dsp.exec_cmd([[notify-send "Disabled Key Bindings"]]))    -- # [hidden]
hl.bind("CTRL + ALT + A", hl.dsp.submap("clean"))                                      -- # [hidden]
hl.define_submap("clean", function()
    hl.bind("CTRL + ALT + S", hl.dsp.exec_cmd([[notify-send "Enabled Key Bindings"]])) -- # [hidden]
    hl.bind("CTRL + ALT + S", hl.dsp.submap("reset"))                                  -- # [hidden]
end)

hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd([[notify-send "Macro Workspace"]])) -- # [hidden]
hl.bind("CTRL + ALT + W", hl.dsp.submap("macroworkspace"))                    -- # [hidden]
hl.define_submap("macroworkspace", function()
    for i = 1, 10 do
        local key = i == 10 and "0" or tostring(i)
        local workspace = (i - 1) * 10 + 1
        hl.bind(key, hl.dsp.focus({ workspace = workspace }))                     -- # [hidden]
        hl.bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace })) -- # [hidden]
    end
    hl.bind("Escape", hl.dsp.exec_cmd([[notify-send "Exited"]]))                  -- # [hidden]
    hl.bind("Escape", hl.dsp.submap("reset"))                                     -- # [hidden]
end)
