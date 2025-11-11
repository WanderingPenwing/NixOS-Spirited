--- @sync entry
local function entry(state, job)
	if #job.args < 0 then
	   ya.err("no argument")
	   return
	end
	
	if state.old then
		Tab.layout, state.old = state.old, nil
	else
		state.old = Tab.layout

		local current_size = 0
		local preview_size = 0
		
		if job.args[1] == "current" then
			current_size = 100
		else
			preview_size = 100
		end
			
		Tab.layout = function(self)
			self._chunks = ui.Layout()
				:direction(ui.Layout.HORIZONTAL)
				:constraints({
					ui.Constraint.Percentage(0),
					ui.Constraint.Percentage(current_size),
					ui.Constraint.Percentage(preview_size),
				})
				:split(self._area)
		end
	end
	ya.app_emit("resize", {})
end

return { entry = entry }
