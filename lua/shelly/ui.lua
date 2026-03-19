local detection = require("shelly.detection")
local utils = require("shelly.utils")

local M = {}

function M.select(callback)
  local shells = detection.get_installed_shells()

  vim.ui.select(
    shells,
    { prompt = "Select shell (current: " .. utils.normalize_shell(vim.o.shell) .. ")" },
    function(choice)
      if choice and callback then
        callback(choice)
      end
    end
  )
end

return M
