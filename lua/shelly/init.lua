-- This plugin has built-in lazy loading

local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("shelly." .. k)
    return rawget(t, k)
  end,
})

local _setup_done = false

function M.setup(opts)
  -- Prevent setup running more than once for now until it's safe
  -- if _setup_done then
  --   return
  -- end

  _setup_done = true

  -- Export module
  _G.Shelly = M

  M.opts = Shelly.config.setup(opts)

  -- Built-in lazy loading, runs after current event loop
  vim.defer_fn(function()
    Shelly.config.load()
    Shelly.config.setup_commands()
  end, 0)

  -- Export some functions
  M.picker = Shelly.config.picker
end

return M
