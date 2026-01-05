return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  built = ":TSUpdate",

  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      ensure_installed = { "lua", "markdown", "yaml" },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
