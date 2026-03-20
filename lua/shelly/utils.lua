local config = require("shelly.config")

local M = {}

function M.normalize_shell(name)
  if not name or name == "" then
    return ""
  end

  local base = vim.fn.fnamemodify(name, ":t")

  if config.shell_aliases and config.shell_aliases[base] then
    return config.shell_aliases[base]
  end

  return base
end

function M.is_executable(cmd)
  if not cmd or cmd == "" then
    return false
  end

  ---@diagnostic disable-next-line: undefined-field
  return vim.fn.executable(cmd) == 1 or vim.loop.fs_stat(cmd) ~= nil
end

return M
