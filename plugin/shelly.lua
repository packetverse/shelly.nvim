local ok, shelly = pcall(require, "shelly")
if not ok then
  return
end

shelly.load()

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

vim.api.nvim_create_user_command("ShellyCurrent", function()
  vim.notify("Current shell: " .. vim.o.shell)
end, {})
