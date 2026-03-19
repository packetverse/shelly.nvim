local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local themes = require("telescope.themes")

local function shell_picker(opts)
  opts = themes.get_dropdown(opts or {})

  local shells = require("shelly.detection").get_installed_shells()
  if #shells == 0 then
    vim.notify("No shells detected!", vim.log.levels.WARN)
    return
  end

  local current_shell = vim.o.shell

  pickers
    .new(opts, {
      prompt_title = "Select Shell",
      finder = finders.new_table({
        results = shells,
        entry_maker = function(entry)
          local display = entry
          if entry == current_shell then
            display = display .. " [current]"
          end
          return {
            value = entry,
            display = display,
            ordinal = entry,
          }
        end,
      }),
      sorter = config.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            require("shelly").set(selection.value)
          end
        end)
        return true
      end,
    })
    :find()
end

return require("telescope").register_extension({
  exports = {
    shelly = shell_picker,
  },
})
