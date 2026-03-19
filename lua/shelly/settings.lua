local config = require("shelly.config")
local utils = require("shelly.utils")

local M = {}

local current_shell = nil

function M.apply(name)
  local normalized = utils.normalize_shell(name)

  if current_shell == normalized then
    return
  end

  current_shell = normalized

  local cfg =
    vim.tbl_deep_extend("force", {}, config.shell_configs.default or {}, config.shell_configs[normalized] or {})

  for key, value in pairs(cfg) do
    vim.o[key] = value
  end
end

return M
