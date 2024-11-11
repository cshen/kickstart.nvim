-- CS:  9-Oct-2024 15:57
-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
-- Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Sync buffers automatically and disable vim generating a swap file
vim.opt.autoread = true
vim.opt.swapfile = false

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Workaround for a lazyvim bug, https://github.com/neovim/neovim/issues/29900
-- https://github.com/LazyVim/LazyVim/blob/12818a6cb499456f4903c5d8e68af43753ebc869/lua/lazyvim/config/autocmds.lua#L130
vim.g.bigfile_size = 1024 * 1024 * 1 -- 1M

vim.cmd 'colorscheme evening'
vim.cmd ":iab <expr> ttime strftime('CS: %e-%b-%Y %H:%M')"

-- left/right arrow keys change line
vim.cmd 'set whichwrap+=<,>,[,]'

-- I load some VIM scipt here. They are in lua/local/*
-- vim.cmd 'source $HOME/.config/nvim/lua/local/supertab.vim' -- Now loaded as a plugin
vim.cmd 'source $HOME/.config/nvim/lua/local/mswin.vim'
vim.cmd 'source $HOME/.config/nvim/lua/local/_user.vim'

-- https://github.com/neovim/neovim/issues/19204#issuecomment-1327498068
-- copying from Neovim to Windows clipboard
vim.opt.clipboard = 'unnamedplus'
if vim.fn.has 'wsl' == 1 then
  vim.g.clipboard = {
    name = 'pbcopy',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = 0,
  }
end
-- vim: ts=2 sts=2 sw=2 et
