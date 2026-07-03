-- Restart `waybar`
hl.on("config.reloaded", function ()
    hl.exec_cmd("pkill waybar; waybar")
end)

-- Autostarts
hl.on("hyprland.start", function ()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("bluemon")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hyprctl setcursor Breeze_Light 24")
    -- Execute `waybar` last
    hl.exec_cmd("waybar")
end)
