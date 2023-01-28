require("plugins/init")

local options = {
  number = true,

  clipboard = "unnamedplus",

  encoding = "utf-8",
  fileencodings = "utf-8,euc-jp",

  expandtab = true,
  sw = 2,
  ts = 2,
  sts = 2,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

local keymap_opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap("n", ";", ":", keymap_opts)
vim.api.nvim_set_keymap("n", ":", ";", keymap_opts)
vim.api.nvim_set_keymap("n", "k", "gk", keymap_opts)
vim.api.nvim_set_keymap("n", "j", "gj", keymap_opts)

if vim.g.vscode then
  vim.api.nvim_set_keymap("n", "k", ":<C-u>call rpcrequest(g:vscode_channel, 'vscode-command', 'cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>", keymap_opts)
  vim.api.nvim_set_keymap("n", "j", ":<C-u>call rpcrequest(g:vscode_channel, 'vscode-command', 'cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>", keymap_opts)
end
