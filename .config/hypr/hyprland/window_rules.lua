hl.window_rule({
    name = "fzf-popups",
    match = {
        class = "fzf-.*"
    },
    float = true,
    size = { 1080, 720 },
    center = true,
    pin = true,

    stay_focused = true
})

hl.window_rule({
    name = "thunar",
    match = {
        class = "thunar",
        title = "Rename.*"
    },
    float = true,
    size = { 512, 128 },
    center = true
})

-- BROKEN: Investigate why the opacity does not apply
hl.window_rule({
  name = "SKLauncher",
  match = {
    class = "pl-skmedix.*",
    title = "SKlauncher.*"
  },
  float = true,
  center = true,
  opacity = "1.0 override",
})

hl.window_rule({
  name = "Telegram",
  match = {
    initial_class = "org.telegram.desktop",
    initial_title = "Media viewer"
  },
  float = true,
  size = { 1080, 720 },
  center = true
})

-- Fix some dragging issues with XWayland.
hl.window_rule({
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },
  no_focus = true,
})
