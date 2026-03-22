local M = {}

-- Default config
M.defaults = {
  preferred = {},
  shells = {
    pwsh = {
      shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';",
      shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode',
      shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode',
      shellquote = "",
      shellxquote = "",
    },
    powershell = {
      shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';",
      shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
      -- shellpipe = "2>&1 | Tee-Object -Encoding UTF8 %s; exit $LastExitCod",
      shellpipe = "> %s 2>&1",
      shellquote = "",
      shellxquote = "",
    },
    cmd = {
      shell = "cmd",
      shellcmdflag = "/c",
      shellredir = "2>&1 > %s",
      shellpipe = "2>&1 | tee %s",
      shellquote = '"',
      shellxquote = "",
    },
    sh = {
      shell = "sh",
      shellcmdflag = "-c",
      shellredir = "> %s 2>&1",
      shellpipe = "2>&1 | tee %s",
      shellquote = '"',
      shellxquote = "",
    },
  },
}

local function get_shell()
  -- Get saved shell if set
  local saved_shell = Shelly.state.load_saved_shell()
  if saved_shell and Shelly.state.shells_set[saved_shell] then
    return saved_shell
  end

  -- If no installed shells found return default
  if #Shelly.state.shells == 0 then
    return vim.opt.shell:get()
  end

  -- Check preferred order
  for _, shell in ipairs(Shelly.opts.preferred) do
    if Shelly.state.shells_set[shell] then
      return shell
    end
  end

  -- Get shell from ENV vars, on unix systems try $SHELL on windows try $ComSpec
  local env_shell = nil
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    env_shell = vim.fn.getenv("ComSpec")
  else
    env_shell = vim.fn.getenv("SHELL")
  end

  if env_shell and Shelly.state.shells_set[env_shell] then
    return env_shell
  end

  -- Last resort: return first installed shell or just default vim.opt.shell value
  return Shelly.state.shells[1] or vim.opt.shell:get()
end

-- Merge config
function M.setup(opts)
  return vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
end

-- Apply all settings
function M.apply()
  if Shelly.opts.shells[Shelly.state.current_shell] then
    for k, v in pairs(Shelly.opts.shells[Shelly.state.current_shell]) do
      vim.opt[k] = v
    end
  end
end

function M.set(shell)
  if not shell or shell == "" then
    return
  end

  vim.opt.shell = shell
  Shelly.state.current_shell = shell
  Shelly.state.save_current_shell(shell)

  M.apply()
end

function M.load()
  Shelly.util.get_installed_shells()
  M.set(get_shell())
end

function M.picker()
  vim.ui.select(
    Shelly.state.shells,
    { prompt = "Select shell (current: " .. vim.opt.shell:get() .. ")" },
    function(choice)
      if choice then
        M.set(vim.trim(choice))
      end
    end
  )
end

function M.setup_commands()
  vim.api.nvim_create_user_command("ShellySet", function(opts)
    M.set(opts.args)
  end, {
    nargs = 1,
    complete = function()
      return Shelly.state.shells
    end,
  })

  vim.api.nvim_create_user_command("ShellyPicker", function()
    M.picker()
  end, {})

  vim.api.nvim_create_user_command("ShellyCurrent", function()
    vim.notify("Current shell: " .. vim.o.shell)
  end, {})

  vim.api.nvim_create_user_command("ShellyListInstalled", function()
    vim.print(Shelly.state.shells)
  end, {})

  vim.api.nvim_create_user_command("ShellyListSupported", function()
    vim.print(Shelly.shells)
  end, {})
end

return M
