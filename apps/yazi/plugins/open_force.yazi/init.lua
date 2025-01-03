--- @sync entry
return {
  entry = function(self, job)
    local h = cx.active.current.hovered
    if h and h.cha.is_dir then
      ya.manager_emit("enter", {})
      return
    end

    if #job.args > 0 and job.args[1] == "detatch" then
      os.execute(string.format("kodama -e sh -c \"micro %s\" &", h.url))
    else
      ya.manager_emit("open", {})
    end
  end,
}
