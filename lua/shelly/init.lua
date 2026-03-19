local M = {}

local state = require("shelly.state")
local detection = require("shelly.detection")
local settings = require("shelly.settings")
local utils = require("shelly.utils")

function M.setup(opts)
  opts = opts or {}

  local config = require("shelly.config")

  if opts.shells then
    config.shell_configs = vim.tbl_deep_extend("force", config.shell_configs, opts.shells)
  end

  if opts.preferred then
    config.preferred_order = opts.preferred
  end

  if opts.auto_load ~= false then
    M.load()
  end
end

function M.set(name)
  if not name then
    return
  end

  if utils.is_executable(name) then
    vim.opt.shell = name
    state.save(name)
    vim.notify("Shell set to " .. name .. " (" .. utils.normalize_shell(name) .. ")", vim.log.levels.INFO)
    settings.apply(name)
  else
    vim.notify("Shell not found: " .. name, vim.log.levels.ERROR)
  end
end

function M.load_default()
  local saved = state.load()

  if saved and utils.is_executable(saved) then
    return saved
  end

  local detected = detection.detect_login_shell()
  if detected and utils.is_executable(detected) then
    return detected
  end

  local installed = detection.get_installed_shells()
  return detection.pick_best(installed) or vim.o.shell
end

function M.load()
  local shell = M.load_default()
  vim.opt.shell = shell
  settings.apply(shell)
end

function M.select()
  require("shelly.ui").select(M.set)
end

return M
