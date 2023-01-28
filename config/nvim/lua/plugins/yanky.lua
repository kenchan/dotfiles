require("yanky").setup({
  highlight = {
    on_put = false,
    on_yank = false,
    timer = 0,
  }
})

vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleBackward)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleForward)")
