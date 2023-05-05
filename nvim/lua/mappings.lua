vim.cmd("let mapleader =','")
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', {noremap = true})
vim.api.nvim_set_keymap('i', '<leader><Left>', ':resize', {noremap = true})
vim.api.nvim_set_keymap('v', ',d', '"_d', {noremap = true})
vim.api.nvim_set_keymap('n', ',dd', '"_dd', {noremap = true})
-- vim.api.nvim_set_keymap('n', '<C-Space>', ':call vim.lsp.diagnostic.show_line_diagnostics()', {noremap = true})

