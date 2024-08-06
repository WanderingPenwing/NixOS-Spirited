require("open_force")
require("toggle_layout")
require("wrap")
require("chmod")
require("full-border"):setup()

function Linemode:fullsize()
	local size = self._file:size()
	return ui.Line(string.format(" %s ", size and ya.readable_size(size) or "-"))
end
