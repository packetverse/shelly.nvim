local ok, shelly = pcall(require, "shelly")
if not ok then
  return
end

vim.api.nvim_create_user_command("ShellySet", function(opts)
  shelly.set(opts.args)
end, {
  nargs = 1,
  complete = function()
    return require("shelly.detection").get_installed_shells()
  end,
})

vim.api.nvim_create_user_command("ShellySelect", function()
  shelly.select()
end, {})

-- alias to ShellySelect
vim.api.nvim_create_user_command("ShellyPicker", function()
  shelly.select()
end, {})

-- telescope picker
vim.api.nvim_create_user_command("ShellyTelescope", function()
  vim.cmd("Telescope shelly")
end, {})

vim.api.nvim_create_user_command("ShellyCurrent", function()
  vim.notify("Current shell: " .. vim.o.shell)
end, {})

vim.api.nvim_create_user_command("ShellyListInstalled", function()
  local shells = require("shelly.detection").get_installed_shells()
  vim.print(shells)
end, {})

vim.api.nvim_create_user_command("ShellyListSupported", function()
  local shells = require("shelly.config").known_shells
  vim.print(shells)
end, {})
