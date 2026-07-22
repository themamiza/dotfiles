-- Reload desktop components after a Hyprland config reload
hl.on("config.reloaded", function ()
    hl.exec_cmd("swaync-client -R -rs")
    hl.exec_cmd("pkill waybar; waybar")
end)

-- Autostarts
hl.on("hyprland.start", function ()
    hl.exec_cmd("hypreco")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("bluemon")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hyprctl setcursor Breeze_Light 24")
    -- Execute `waybar` after `swaync` so its notification module can connect (both should be last)
    hl.exec_cmd("pgrep -x swaync || swaync")
    hl.exec_cmd("waybar")
    hl.exec_cmd("v2rayn")
end)
