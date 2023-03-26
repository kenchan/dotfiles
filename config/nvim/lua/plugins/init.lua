local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local no_vscode = function()
  return vim.g.vscode ~= 1
end

local conf = function(plugin_name)
  return "require 'plugins/"..plugin_name.."'"
end

require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use {
    "vimwiki/vimwiki",
    config = conf("vimwiki"),
  }

  use {
    "glepnir/template.nvim",
    config = conf("template"),
  }

  use {
    "Pocco81/auto-save.nvim",
    config = conf("auto-save"),
  }

  use {
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" } },
    config = conf("telescope"),
    cond = no_vscode,
  }

  if packer_bootstrap then
    require("packer").sync()
  end
end)
