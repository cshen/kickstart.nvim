-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- NOTE normal mode, cc --> toggle comment on/off. This is defined in plugin Comment.nvim

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode

-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit insert in terminal mode' })
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode to get into normal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- CS: My keymaps, 8-Oct-2024
vim.keymap.set('n', '<C-s>', '<cmd>write<cr>', { desc = 'Save' })
vim.keymap.set('i', '<C-s>', '<ESC><cmd>write<cr>', { desc = 'Save' })

-- https://stackoverflow.com/questions/4945132/remap-s-to-save-a-file-in-vim
-- I mapped cmd-s to send hex code 0x1b 0x4f 0x51 which corresponds to F2 (e.g., using iTerm2's "Send Text"). Then,
-- imap <F2> <C-O>:update<CR>
vim.keymap.set('n', '<F2>', '<cmd>write<cr>', { desc = 'Save' })
vim.keymap.set('i', '<F2>', '<ESC><cmd>write<cr>', { desc = 'Save' })

-- Copy to clipboard
vim.keymap.set({ 'n', 'x' }, '<C-c>', '"+y', { desc = 'Copy to clipboad' })
-- Paste
vim.keymap.set({ 'n', 'x' }, '<C-v>', '"+p')
vim.keymap.set({ 'n', 'x' }, '<C-x>', '"+d', { desc = 'Cut' })

-- Termial mode
vim.keymap.set('t', '<C-l>', 'clear', { desc = 'Clear screen' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- CS: 17-Oct-2024 14:29
-- Editing
vim.keymap.set('i', 'jj', '<ESC>', { silent = true, desc = 'Return to normal mode' })

-- Terminal
local function toggle_terminal()
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    local buffer_name = vim.api.nvim_buf_get_name(buffer)
    if string.sub(buffer_name, 1, 7) == 'term://' then
      vim.api.nvim_win_set_buf(0, buffer)

      return
    end
  end
  vim.api.nvim_command ':terminal'
end
vim.keymap.set('n', '<Leader>t', toggle_terminal) -- ", + t" --> get into the Termial
vim.keymap.set('t', '<C-o>', '<C-\\><C-n><C-o>')

-- vim: ts=2 sts=2 sw=2 et
