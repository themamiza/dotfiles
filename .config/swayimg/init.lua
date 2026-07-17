swayimg.text.set_font("FiraCodeNerdFont")
swayimg.text.set_size(16)

-- Set background in different modes
swayimg.gallery.on_key("w", function ()
    local image = swayimg.gallery.get_image()
    os.execute("setbg "..image.path)
end)
swayimg.viewer.on_key("w", function ()
    local image = swayimg.viewer.get_image()
    os.execute("setbg "..image.path)
end)


-- Vim navigations
local PAN_STEP = 0.10
local HALF_PAGE = 0.50

local function pan(mode, dx, dy)
    local window = swayimg.get_window_size()
    local position = mode.get_position()

    mode.set_abs_position(
        math.floor(position.x + window.width * dx),
        math.floor(position.y + window.height * dy)
    )
end

local function bind_view_mode(mode)
    -- Quit
    mode.on_key("q", swayimg.exit)

    -- Pan with h/j/k/l
    mode.on_key("h", function()
        pan(mode, PAN_STEP, 0)
    end)

    mode.on_key("j", function()
        pan(mode, 0, -PAN_STEP)
    end)

    mode.on_key("k", function()
        pan(mode, 0, PAN_STEP)
    end)

    mode.on_key("l", function()
        pan(mode, -PAN_STEP, 0)
    end)

    -- Half-page vertical movement
    mode.on_key("Ctrl-d", function()
        pan(mode, 0, -HALF_PAGE)
    end)

    mode.on_key("Ctrl-u", function()
        pan(mode, 0, HALF_PAGE)
    end)

    -- Previous/next image
    mode.on_key("Shift-h", function()
        mode.switch_image("prev")
    end)

    mode.on_key("Shift-l", function()
        mode.switch_image("next")
    end)

    -- First/last image
    mode.on_key("g", function()
        mode.switch_image("first")
    end)

    mode.on_key("Shift-g", function()
        mode.switch_image("last")
    end)

    -- Reset zoom and position
    mode.on_key("0", function()
        mode.reset()
    end)

    -- Open gallery
    mode.on_key("v", function()
        swayimg.set_mode("gallery")
    end)
end

bind_view_mode(swayimg.viewer)
bind_view_mode(swayimg.slideshow)

local gallery_select = swayimg.gallery.select or swayimg.gallery.switch_image

-- Gallery navigation
swayimg.gallery.on_key("q", swayimg.exit)

swayimg.gallery.on_key("h", function()
    gallery_select("left")
end)

swayimg.gallery.on_key("j", function()
    gallery_select("down")
end)

swayimg.gallery.on_key("k", function()
    gallery_select("up")
end)

swayimg.gallery.on_key("l", function()
    gallery_select("right")
end)

swayimg.gallery.on_key("Ctrl-u", function()
    gallery_select("pgup")
end)

swayimg.gallery.on_key("Ctrl-d", function()
    gallery_select("pgdown")
end)

swayimg.gallery.on_key("g", function()
    gallery_select("first")
end)

swayimg.gallery.on_key("Shift-g", function()
    gallery_select("last")
end)

swayimg.gallery.on_key("Return", function()
    swayimg.set_mode("viewer")
end)
