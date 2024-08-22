require("open_force")
require("toggle_layout")
require("wrap")
require("chmod")
require("full-border"):setup()

function Linemode:fullsize()
	local size = self._file:size()
	return ui.Line(string.format(" %s ", size and ya.readable_size(size) or "-"))
end

Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ui.Line {}
	end
	return ui.Span(ya.host_name() .. " "):fg("blue")
end, 500, Header.LEFT)
