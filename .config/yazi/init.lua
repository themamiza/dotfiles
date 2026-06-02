---@diagnostic disable undefined-global

-- username@hostname:
Header:children_add(function ()
    if ya.target_family() ~= "unix" then
        return ui.Line {}
    end
    --TODO: make it so the hovered item is printed in the line as well
    --local h = cx.active.current.hovered
    return ui.Line { ui.Span(ya.user_name() .. "@" .. ya.host_name()):fg("lightgreen"):bold(true), ui.Span(":") }
end, 500, Header.LEFT)

require("full-border"):setup()
