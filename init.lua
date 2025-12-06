-- ===== MINIMAL NEOVIM CONFIG =====

if vim.g.vscode then
    -- VSCode Neovim
    require "user.vscode_keymaps"
else
    -- Ordinary Neovim
    vim.opt.number = true
    vim.opt.relativenumber = true
end
