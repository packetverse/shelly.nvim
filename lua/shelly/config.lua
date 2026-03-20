local M = {}

M.known_shells = {
  "pwsh",
  "powershell",
  "cmd",
  "bash",
  "zsh",
  "fish",
  "sh",
  "nu",
}

M.preferred_order = {
  "pwsh",
  "bash",
  "zsh",
  "fish",
  "sh",
  "cmd",
}

M.shell_aliases = {}

M.shell_configs = {
  pwsh = {
    shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';",
    shellredir = '2>&1 | %{ "$_" } | Out-File %s; exit $LastExitCode',
    shellpipe = '2>&1 | %{ "$_" } | Tee-Object %s; exit $LastExitCode',
    shellquote = "",
    shellxquote = "",
  },
  powershell = {
    shellcmdflag = "-NoLogo -Command", -- Simpler flags for legacy version
    shellredir = "2>&1 | Out-File %s; exit $LastExitCode",
    shellpipe = "2>&1 | Tee-Object %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  },
  bash = {
    shellcmdflag = "-c",
    shellredir = ">%s 2>&1",
    shellpipe = "2>&1 | tee %s",
  },
  zsh = {
    shellcmdflag = "-c",
    shellredir = ">%s 2>&1",
    shellpipe = "2>&1 | tee %s",
  },
  fish = {
    shellcmdflag = "-c",
    shellredir = ">%s ^&1",
    shellpipe = "^&1 | tee %s",
  },
  default = {
    shellcmdflag = "-c",
    shellredir = ">%s 2>&1",
    shellpipe = "2>&1 | tee %s",
  },
}

return M
