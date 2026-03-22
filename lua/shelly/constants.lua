local M = {}

-- base
M.SHELLY_PATH = vim.fn.stdpath("state") .. "/shelly"

-- persisted shell
M.SAVED_SHELL_PATH = M.SHELLY_PATH .. "/shell"

return M
