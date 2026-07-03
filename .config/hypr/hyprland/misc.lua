hl.config({
    misc = {
        -- Default behavior
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,

        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,

        -- Window swallowing
        enable_swallow = true,
        swallow_regex = "Alacritty|kitty|xterm-256color",

        focus_on_activate = true,

        middle_click_paste = true
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true
    }
})
