vim.pack.add({ "https://github.com/folke/tokyonight.nvim" })

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

vim.cmd.colorscheme("tokyonight")
