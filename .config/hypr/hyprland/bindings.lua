-- Common applications --
hl.bind("SUPER +    RETURN", hl.dsp.exec_cmd("$TERMINAL"))
hl.bind("ALT   +    RETURN", hl.dsp.exec_cmd("ttmuxer"))
hl.bind("SUPER +         W", hl.dsp.exec_cmd("$BROWSER"))
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("$PRIVATE_BROWSER"))
hl.bind("SUPER +         G", hl.dsp.exec_cmd("$GUIFM"))
hl.bind("SUPER +         E", hl.dsp.exec_cmd("emacs"))
hl.bind("SUPER +         T", hl.dsp.exec_cmd("Telegram"))
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("$TERMINAL -e tux"))

-- Eco mode
hl.bind("SUPER + GRAVE", hl.dsp.exec_cmd("hypreco toggle"))

-- Volume control --
hl.bind("SUPER + minus",          hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%-; pkill --signal 44 waybar"), { repeating = true })
hl.bind("SUPER + equal",          hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 5%+; pkill --signal 44 waybar"), { repeating = true })
hl.bind("SUPER + SHIFT + minus ", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 15%-;         pkill --signal 44 waybar"), { repeating = true })
hl.bind("SUPER + SHIFT + equal",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 15%+;         pkill --signal 44 waybar"), { repeating = true })
hl.bind("XF86AudioRaiseVolume",   hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+;    pkill --signal 44 waybar"), { repeating = true })
hl.bind("XF86AudioLowerVolume",   hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-;    pkill --signal 44 waybar"), { repeating = true })
hl.bind("SUPER + SHIFT + M",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle;   pkill --signal 44 waybar"), { repeating = true })
hl.bind("XF86AudioMute",          hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle;   pkill --signal 44 waybar"), { repeating = true })
hl.bind("XF86AudioMicMute",       hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle; pkill --signal 44 waybar"), { repeating = true })
hl.bind("XF86AudioPlay",          hl.dsp.exec_cmd("playerctl play-pause"), { repeating = true })
hl.bind("XF86AudioPause",         hl.dsp.exec_cmd("playerctl play-pause"), { repeating = true })
hl.bind("XF86AudioPrev",          hl.dsp.exec_cmd("playerctl previous"), { repeating = true })
hl.bind("XF86AudioNext",          hl.dsp.exec_cmd("playerctl next"), { repeating = true })

-- Brightness control --
hl.bind("SUPER +         bracketleft" , hl.dsp.exec_cmd("brightnessctl set 10%-; pkill --signal 37 waybar"), { repeating = true })
hl.bind("SUPER +         bracketright", hl.dsp.exec_cmd("brightnessctl set 10%+; pkill --signal 37 waybar"), { repeating = true })
hl.bind("SUPER + SHIFT + bracketleft",  hl.dsp.exec_cmd("brightnessctl set 25%-; pkill --signal 37 waybar"), { repeating = true })
hl.bind("SUPER + SHIFT + bracketright", hl.dsp.exec_cmd("brightnessctl set 25%+; pkill --signal 37 waybar"), { repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 10%+; pkill --signal 37 waybar"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-; pkill --signal 37 waybar"), { repeating = true })

-- Touchpad toggle --
hl.bind("F6", hl.dsp.exec_cmd("touchpad-toggle"))

-- Screenshot --
hl.bind("Print",         hl.dsp.exec_cmd("grim               ~/pix/$(date '+%y%m%d-%H%M-%S').png"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/pix/$(date "+%y%m%d-%H%M-%S").png'))

-- Wallpaper --
hl.bind("SUPER +         n", hl.dsp.exec_cmd("find  ~/.local/share/wallpapers/* | shuf | xargs swayimg -g"))
hl.bind("SUPER + SHIFT + n", hl.dsp.exec_cmd("setbg ~/.local/share/wallpapers"))

-- Tui applications --
hl.bind("SUPER + R",         hl.dsp.exec_cmd('$TERMINAL -e "$TUIFM"'))
hl.bind("SUPER + SHIFT + H", hl.dsp.exec_cmd("$TERMINAL -e btop"))
hl.bind("SUPER + SHIFT + I", hl.dsp.exec_cmd("$TERMINAL -e nmtui"))

-- `fzf` scripts --
hl.bind("SUPER +         D", hl.dsp.exec_cmd("$TERMINAL --class fzf-launcher -e fzf-launcher"))
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("$TERMINAL --class fzf-run -e fzf-run"))
hl.bind("SUPER + BACKSPACE", hl.dsp.exec_cmd("$TERMINAL --class fzf-sysact -e fzf-sysact"))
hl.bind("CONTROL + ALT + K", hl.dsp.exec_cmd("$TERMINAL --class fzf-man -e fzf-man"))
hl.bind("CONTROL + ALT + U", hl.dsp.exec_cmd("$TERMINAL --class fzf-unicode -e fzf-unicode"))
hl.bind("CONTROL + ALT + P", hl.dsp.exec_cmd("$TERMINAL --class fzf-getpass -e fzf-getpass"))
hl.bind("CONTROL + ALT + M", hl.dsp.exec_cmd("dmenumount"))
hl.bind("CONTROL + ALT + SHIFT + M", hl.dsp.exec_cmd("dmenuumount"))

-- Toggle `waybar`
hl.bind("SUPER + B", hl.dsp.exec_cmd("pkill -SIGUSR1 waybar"))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("fzf-waybar-mode toggle-layout"))

-- Window actions --
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + SHIFT + space", hl.dsp.window.float())

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }))

hl.bind("SUPER + LEFT",  hl.dsp.window.move({ x = -25, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + RIGHT", hl.dsp.window.move({ x = 25, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + UP",    hl.dsp.window.move({ x = 0, y = -25, relative = true }), { repeating = true })
hl.bind("SUPER + DOWN",  hl.dsp.window.move({ x = 0, y = 25, relative = true }), { repeating = true })

hl.bind("SUPER + SHIFT + LEFT",  hl.dsp.window.resize({ x = -25, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.resize({ x = 25, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + UP",    hl.dsp.window.resize({ x = 0, y = -25, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + DOWN",  hl.dsp.window.resize({ x = 0, y = 25, relative = true }), { repeating = true })

-- Only works for floating windows**
hl.bind("SUPER + S", hl.dsp.window.pin())

-- Mouse movements
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspace keys --
for workspace = 1, 9 do
    local key = "code:" .. tostring(workspace + 9)
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = tostring(workspace) }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
end
