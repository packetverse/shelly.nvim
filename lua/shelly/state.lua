local constants = require("shelly.constants")

local M = {}

local persist_file = constants.STATE_FILE

function M.save(name)
  if not name or name == "" then
    vim.notify("Cannot save empty shell name", vim.log.levels.WARN)
    return false
  end

  local ok, err = pcall(function()
    local dir = vim.fn.fnamemodify(persist_file, ":h")
    vim.fn.mkdir(dir, "p")

    local f = io.open(persist_file, "w")
    if not f then
      error("Failed to open file for writing: " .. persist_file)
    end

    f:write(name)
    f:close()
  end)

  if not ok then
    vim.notify("Failed to save shell state: " .. tostring(err), vim.log.levels.ERROR)
    return false
  end

  return true
end

function M.load()
  local ok, result = pcall(function()
    local f = io.open(persist_file, "r")
    if not f then
      return nil
    end

    local name = f:read("*l")
    f:close()
    return name
  end)

  if not ok then
    vim.notify("Failed to load shell state", vim.log.levels.WARN)
    return nil
  end

  return result
end

return M
