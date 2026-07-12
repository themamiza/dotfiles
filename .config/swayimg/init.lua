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
swayimg.gallery.on_key("h", function ()
    swayimg.gallery.switch_image("left")
end)
swayimg.gallery.on_key("j", function ()
    swayimg.gallery.switch_image("down")
end)
swayimg.gallery.on_key("k", function ()
    swayimg.gallery.switch_image("up")
end)
swayimg.gallery.on_key("l", function ()
    swayimg.gallery.switch_image("right")
end)
