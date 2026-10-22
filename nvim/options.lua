-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
require("config.remote_clipboard").setup()

-- Wrap long lines at word boundaries (LazyVim disables wrap by default)
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.relativenumber = true
vim.g.autoformat = false
