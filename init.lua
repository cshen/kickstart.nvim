-- CS: [ 8-Oct-2024 14:55]
--[[
  Kickstart.nvim is *not* a distribution.
  Kickstart.nvim is a starting point for your own configuration.
  Next, run AND READ `:help`.
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'plugins'

-- CS: I config colorscheme etc in options file, so it must be loaded at the last
-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
