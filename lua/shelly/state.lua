local M = {}

local persist_file = vim.fn.stdpath("state") .. "/default_shell"

function M.save(name)
  vim.fn.mkdir(vim.fn.fnamemodify(persist_file, ":h"), "p")

  local f = io.open(persist_file, "w")
  if f then
    f:write(name)
    f:close()
  end
end

function M.load()
  local f = io.open(persist_file, "r")
  if not f then
    return nil
  end

  local name = f:read("*l")
  f:close()
  return name
end

return M
