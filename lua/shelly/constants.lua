-- lua/shelly/constants.lua
local M = {}

M.STATE_DIR = vim.fn.stdpath("state")
M.STATE_FILE = M.STATE_DIR .. "/shelly_default_shell"

M.CONFIG_KEYS = {
  "shellcmdflag",
  "shellredir",
  "shellpipe",
  "shellquote",
  "shellxquote",
}

return M
