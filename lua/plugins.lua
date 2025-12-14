return require('packer').startup(function(use)
  -- manage packer itselt
  use 'wbthomason/packer.nvim'

  -- (optional) status line: nvim-lualine
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' } -- plugin for icons
  }

  -- (optional) file explorer: nvim-tree
  use 'nvim-tree/nvim-tree.lua'
  
  -- (optional) color schema: tokyonight
  use 'folke/tokyonight.nvim'

  use 'neovim/nvim-lspconfig'
end)
