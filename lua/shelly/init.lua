local M = {}

local state = require("shelly.state")
local detection = require("shelly.detection")
local settings = require("shelly.settings")
local utils = require("shelly.utils")
local config = require("shelly.config")

local _setup_done = false

function M.setup(opts)
  if _setup_done then
    return
  end

  _setup_done = true
  opts = opts or {}

  if opts.preferred and #opts.preferred > 0 then
    config.preferred_order = vim.list_extend(vim.deepcopy(opts.preferred), config.preferred_order)
  end

  if opts.shells then
    config.shell_configs = vim.tbl_deep_extend("force", vim.deepcopy(config.shell_configs), opts.shells or {})
  end

  if opts.auto_load ~= false then
    M.load()
  end
end

function M.set(name)
  if not name then
    return
  end

  name = vim.trim(name or "")
  if name == "" then
    vim.notify("Please provide a shell name", vim.log.levels.WARN)
    return
  end

  if not utils.is_executable(name) then
    vim.notify("Shell not found or not executable: " .. name, vim.log.levels.ERROR)
    return
  end

  local ok, err = pcall(function()
    vim.opt.shell = name
    settings.apply(name)
  end)

  if not ok then
    vim.notify("Failed to set shell: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  state.save(name)
  vim.notify("Shell set to " .. name .. " (" .. utils.normalize_shell(name) .. ")", vim.log.levels.INFO)
end

function M.load_default()
  local installed = detection.get_installed_shells()

  -- If no installed shells return default
  if #installed == 0 then
    return vim.o.shell
  end

  -- Try to pick from preferred order
  local best = detection.pick_best(installed)
  if best then
    return best
  end

  -- Fallback: use saved shell
  local saved = state.load()
  if saved and utils.is_executable(saved) then
    return saved
  end

  -- Final fallback: try login shell from ENV vars
  local detected = detection.detect_login_shell()
  if detected and utils.is_executable(detected) then
    return detected
  end

  -- Last resort
  return vim.o.shell
end

function M.load()
  vim.schedule(function()
    local shell = M.load_default()
    vim.opt.shell = shell
    settings.apply(shell)
  end)
end

function M.select()
  require("shelly.ui").select(M.set)
end

return M
