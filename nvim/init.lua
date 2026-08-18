vim.pack.add({
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/ibhagwan/fzf-lua",
})

vim.g.mapleader = " "

vim.o.number = true
vim.o.clipboard = "unnamedplus"
vim.o.fileencodings = "utf-8,euc-jp"
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2

vim.keymap.set("n", ";", ":")
vim.keymap.set("n", ":", ";")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "j", "gj")

local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>ff", fzf.files)
vim.keymap.set("n", "<leader>fg", fzf.live_grep)
vim.keymap.set("n", "<leader>fb", fzf.buffers)
vim.keymap.set("n", "<leader>fh", fzf.helptags)

vim.cmd.colorscheme("tokyonight")
