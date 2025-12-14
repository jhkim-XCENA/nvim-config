-- ~/.config/nvim/init.lua

-- 1. basic setting
-- line number
vim.opt.number = true
vim.opt.relativenumber = false
-- highlight cursor line
vim.opt.cursorline = true
-- \t == 2
vim.opt.tabstop = 2
-- auto indent width
vim.opt.shiftwidth = 2
-- use space instead of \t
vim.opt.expandtab = true
-- auto indent based on the previous line
vim.opt.autoindent = true
-- smart indent for characters like {, }
vim.opt.smartindent = true
-- disable auto line change when a long line exceeds the screen width
vim.opt.wrap = false
-- highlight the search results on the spot
vim.opt.incsearch = true
-- keep highlights after search is finished
vim.opt.hlsearch = true
-- do not check case when searching
vim.opt.ignorecase = true
-- if the pattern contains capital cases, check case even though ignorecase is true
vim.opt.smartcase = true
-- height of the bottom command line
vim.opt.cmdheight = 1
-- always show statusline
vim.opt.laststatus = 2
-- disable mode display(insert, visual..)
vim.opt.showmode = false
-- use 24-bit color if the terminal supports
vim.opt.termguicolors = true
-- don't generate swap files
vim.opt.swapfile = false
-- keep undo records even though the session is finished
vim.opt.undofile = true

-- 2. Packer bootstrap
local package_root = vim.fn.stdpath('data') .. '/site'
local install_path = package_root .. '/pack/packer/start/packer.nvim'
local is_packer_installed = vim.fn.isdirectory(install_path) == 1

if not is_packer_installed then
  print("Installing packer.nvim...")
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

-- 3. load plugin (lua/plugins.lua)
require('plugins')

-- 4. theme and sync
local function apply_theme()
    if not pcall(vim.cmd.colorscheme, 'tokyonight') then
        vim.cmd('colorscheme default')
    end
end

vim.api.nvim_create_autocmd('VimEnter', {
  group = vim.api.nvim_create_augroup('PackerStartup', { clear = true }),
  callback = function()
    pcall(require, 'lsp.lspconfig')
    apply_theme()
    
    local plugs_exists = vim.g.plugs and type(vim.g.plugs) == 'table'
    if plugs_exists then
        local needs_sync = vim.fn.len(vim.fn.filter(vim.fn.keys(vim.g.plugs), 
            'v:val!~"^packer" && !isdirectory(v:val[0].."/"..v:val[1])')) > 0
        if not is_packer_installed or needs_sync then
            vim.cmd('PackerSync')
        end
    elseif not is_packer_installed then
        vim.cmd('PackerSync')
    end
  end
})

-- ===================================
-- detour for umask
-- ===================================

vim.api.nvim_create_autocmd({'BufWritePost'}, {
  group = vim.api.nvim_create_augroup('ExecutableFiles', { clear = true }),
  pattern = {
    '*'
  },
  callback = function()
    local file_name = vim.api.nvim_buf_get_name(0)
    vim.fn.system({'chmod', '777', file_name})
  end
})
