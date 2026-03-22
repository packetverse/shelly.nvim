local M = {}

M.shells = {}
M.shells_set = {} -- O(1) lookup table
M.current_shell = nil

---@return boolean
function M.save_current_shell(name)
  if not name or name == "" then
    vim.notify("Cannot save empty shell name", vim.log.levels.WARN)
    return false
  end

  local ok, err = pcall(function()
    -- Ensure parent directory exists
    local dir = vim.fn.fnamemodify(Shelly.constants.SAVED_SHELL_PATH, ":h")
    vim.fn.mkdir(dir, "p")

    local f, ferr = io.open(Shelly.constants.SAVED_SHELL_PATH, "w")
    if not f then
      error("Failed to open file for writing: " .. tostring(ferr))
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

---@return string|nil
function M.load_saved_shell()
  local f, err = io.open(Shelly.constants.SAVED_SHELL_PATH, "r")
  if not f then
    if vim.loop.fs_stat(Shelly.constants.SAVED_SHELL_PATH) then
      vim.notify("Failed to open saved shell file: " .. tostring(err), vim.log.levels.WARN)
    end
    return nil
  end

  local name = f:read("*l")
  f:close()
  return name
end

return M
