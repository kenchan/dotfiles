local no_vscode = function()
  return vim.g.vscode ~= 1
end

return {
  "wbthomason/packer.nvim",

  {
    "vimwiki/vimwiki",
    init = function()
      require("plugins/vimwiki")
    end
  },

  "Pocco81/auto-save.nvim",

  "machakann/vim-sandwich",

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("plugins/telescope")
    end
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("plugins/treesitter")
    end
  },

  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      require("claude-code").setup()
    end
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd[[colorscheme tokyonight]]
    end
  }
}

