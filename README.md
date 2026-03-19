# 🐚 `shelly.nvim`

A simple Neovim plugin to easily manage your shell. Automatically sets `vim.opt.shell` with the approriate flags for your chosen shell, provides a picker UI, Telescope integration, persistence, and notifications.

## ✨ Features
- Automatically sets `vim.opt.shell`, `vim.opt.shellcmdflag`, `vim.opt.shellpipe`, and other related options based on the shell you select.
- Lets you pick your shell interactively using `vim.ui.select`.
- Integrates with Telescope so you can pick shells via fuzzy finding.
- Remembers your last chosen shell and restores it on startup.
- Sends notifications using `vim.notify` whenever your shell changes.
- Lightweight and focused, designed to simplify shell management without unncessary complexity.

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

Try running the `ShellySelect` command.
