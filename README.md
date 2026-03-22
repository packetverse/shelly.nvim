# 🐚 `shelly.nvim`

A simple Neovim plugin to easily manage your shell. Automatically sets `vim.opt.shell` with the appropriate flags for your chosen shell, provides a picker UI, Telescope integration, persistence, and notifications.

## ✨ Features
- Automatically sets `vim.opt.shell`, `vim.opt.shellcmdflag`, `vim.opt.shellpipe`, and other related options based on the shell you select.
- Lets you pick your shell interactively using `vim.ui.select`.
- Integrates with Telescope so you can pick shells via fuzzy finding.
- Remembers your last chosen shell and restores it on startup.
- Sends notifications using `vim.notify` whenever your shell changes.
- Lightweight and focused, designed to simplify shell management without unnecessary complexity.
- Lets you define your own shell configs with ease.
- Defaults for `pwsh` and `powershell` already include `-NoLogo`, `-NoProfile`, and UTF-8 encoding, so no additional configuration is needed for standard usage.

## 📦 Installation

<details>
<summary>lazy.nvim</summary>

```lua
{
  "packetverse/shelly.nvim",
  opts = {},
}
```

</details>

## 🚀 Usage

You can start with this simple config:

> [!IMPORTANT]
> Don't forget to call `require("shelly").setup()` to enable the plugin.

Lazy-loading is unneeded as it is already handled internally.

```lua
require("shelly").setup({
  shells = {
    pwsh = {
      shellpipe = "2>&1 | Tee-Object %s",
    },
  },
})
```

You can also bind a key to the interactive shell picker:

```lua
{
  "packetverse/shelly.nvim",
  opts = {},
  keys = {
    {
      "<leader>us",
      function() require("shelly").picker() end,
      desc = "Open Shelly picker",
    },
  },
}
```

It also comes with the following commands:

- `:ShellyCurrent` – Shows the current shell.
- `:ShellySet` – Sets a new shell and persists it for the next startup (supports completion).
- `:ShellyPicker` – Opens an interactive picker for setting and persisting a shell.
- `:ShellyListInstalled` – Outputs all installed shells that the plugin detected.
- `:ShellyListSupported` – Outputs all shells the plugin supports.

## 🔭 Telescope Integration

**shelly.nvim** automatically registers a Telescope extension. You can try it using: `:Telescope shelly`

## ⚙️ Configuration

**shelly.nvim** comes with the following defaults:

```lua
{
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
      shellpipe = "2>&1 | Tee-Object -Encoding UTF8 %s; exit $LastExitCode",
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
```

> These defaults ensure that shells work correctly in Neovim without extra configuration. You can still override any value in your own setup if needed.

## 💡 How It Works

**shelly.nvim** sets Neovim's shell options automatically based on your selected shell. This includes:

- `shellcmdflag`
- `shellredir`
- `shellpipe`
- `shellquote`
- `shellxquote`

It handles everything needed for `:!` commands, terminal buffers, and output capturing, letting you focus on working without worrying about shell quirks.
