-- ===== VSCODE NEOVIM KEYMAPS =====
-- All custom keybindings for VSCode/Cursor

-- Use VSCode's clipboard
vim.g.clipboard = vim.g.vscode_clipboard

-- Basic search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- IMPORTANT: Unmap Space first, THEN set as leader!
vim.keymap.set({'n', 'v'}, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load VSCode API
local vscode = require('vscode')

-- ===== CLIPBOARD =====
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })

-- ===== SPLIT MANAGEMENT =====
vim.keymap.set('n', '<leader>v', function()
    vscode.action('workbench.action.splitEditorRight')
end, { desc = 'Split vertically' })

vim.keymap.set('n', '<leader>s', function()
    vscode.action('workbench.action.splitEditorDown')
end, { desc = 'Split horizontally' })

vim.keymap.set('n', '<leader>q', function()
    vscode.action('workbench.action.closeActiveEditor')
end, { desc = 'Close pane' })

-- ===== PANE NAVIGATION =====
vim.keymap.set('n', '<leader>h', function()
    vscode.action('workbench.action.focusLeftGroup')
end, { desc = 'Focus left pane' })

vim.keymap.set('n', '<leader>j', function()
    vscode.action('workbench.action.focusBelowGroup')
end, { desc = 'Focus below pane' })

vim.keymap.set('n', '<leader>k', function()
    vscode.action('workbench.action.focusAboveGroup')
end, { desc = 'Focus above pane' })

vim.keymap.set('n', '<leader>l', function()
    vscode.action('workbench.action.focusRightGroup')
end, { desc = 'Focus right pane' })

-- ===== SYMBOL NAVIGATION =====
vim.keymap.set('n', 'gn', function()
    vscode.action('workbench.action.gotoSymbol')
end, { desc = 'Go to symbol in file' })

-- ===== PASTE BEHAVIOR =====
-- Paste without overwriting register (preserve yank)
vim.keymap.set('v', 'p', '"_dP', { desc = 'Paste without yanking replaced text' })

-- ===== CODE ACTIONS & UTILITIES =====
-- Quick fix / code actions (import, refactor, etc.)
vim.keymap.set({'n', 'v'}, '<leader>a', function()
    vscode.action('editor.action.quickFix')
end, { desc = 'Quick fix / code actions' })

-- Quick open file (like Cmd+P)
vim.keymap.set({'n', 'v'}, '<leader>ff', function()
    vscode.action('workbench.action.quickOpen')
end, { desc = 'Quick open file' })

-- Format document
vim.keymap.set({'n', 'v'}, '<leader>fd', function()
    vscode.action('editor.action.formatDocument')
end, { desc = 'Format document' })
