local M = {}

function M.is_executable(cmd)
  if not cmd or cmd == "" then
    return false
  end

  return vim.fn.executable(cmd) == 1
end

function M.get_installed_shells()
  for _, shell in ipairs(Shelly.shells) do
    if not Shelly.state.shells_set[shell] and M.is_executable(shell) then
      table.insert(Shelly.state.shells, shell)
      Shelly.state.shells_set[shell] = true
    end
  end
  return Shelly.state.shells
end

return M
