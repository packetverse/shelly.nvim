local config = require("shelly.config")
local utils = require("shelly.utils")

local M = {}

function M.get_installed_shells()
  local shells, seen = {}, {}

  for _, shell in ipairs(config.known_shells) do
    if utils.is_executable(shell) then
      local normalized = utils.normalize_shell(shell)
      if not seen[normalized] then
        table.insert(shells, shell)
        seen[normalized] = true
      end
    end
  end

  return shells
end

function M.pick_best(installed)
  local lookup = {}

  for _, s in ipairs(installed) do
    lookup[utils.normalize_shell(s)] = s
  end

  for _, preferred in ipairs(config.preferred_order) do
    if lookup[preferred] then
      return lookup[preferred]
    end
  end

  return installed[1]
end

function M.detect_login_shell()
  local shell = os.getenv("SHELL")
  if shell and shell ~= "" then
    return shell
  end

  local comspec = os.getenv("COMSPEC")
  if comspec and comspec ~= "" then
    return comspec
  end
end

return M
