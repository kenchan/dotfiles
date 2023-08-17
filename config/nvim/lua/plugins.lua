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
  }
}
