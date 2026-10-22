-- ~/.config/nvim/lua/config/keymaps.lua
-- Appended by omarchy/install.sh. Safe to run more than once -- the installer
-- replaces the block between the BEGIN/END markers instead of stacking copies.

-- Leader key.
-- Omarchy's Neovim is LazyVim, and LazyVim's leader is already <Space>, so this
-- is normally a no-op assertion. It matters that it is set BEFORE the maps
-- below: vim.keymap.set resolves <leader> at definition time, not at press
-- time. (Setting it here cannot change what lazy.nvim already handed to plugin
-- specs -- for that it has to live in lua/config/options.lua before
-- lazy.setup(). install.sh checks for that case and warns if it finds a
-- different leader.)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set

-- Pick the first picker that's actually installed. LazyVim >= 14 defaults to
-- snacks.picker; older setups and the Telescope extra use Telescope; fzf-lua is
-- the third common option. Hard-coding <cmd>Telescope find_files<cr> breaks with
-- "Not an editor command" on a stock Omarchy install.
local function has(mod)
  return pcall(require, mod)
end

local find_files, live_grep

if _G.Snacks and _G.Snacks.picker then
  find_files = function() Snacks.picker.files() end
  live_grep = function() Snacks.picker.grep() end
elseif has("telescope") then
  find_files = function() require("telescope.builtin").find_files() end
  live_grep = function() require("telescope.builtin").live_grep() end
elseif has("fzf-lua") then
  find_files = function() require("fzf-lua").files() end
  live_grep = function() require("fzf-lua").live_grep() end
else
  find_files = function() vim.cmd("find " .. vim.fn.input("File: ")) end
  live_grep = function() vim.cmd("grep " .. vim.fn.input("Grep: ")) end
end

-- Fuzzy find files
keymap("n", "<leader>ff", find_files, { desc = "Fuzzy Find Files" })

-- Live grep / find text
-- (lowercase fs -- the draft had <leader>Fs, which needs Shift and doesn't
-- match the leader-fs in OVERVIEW.md)
keymap("n", "<leader>fs", live_grep, { desc = "Live Grep Text" })

-- Toggle file explorer
keymap("n", "<leader>ee", function()
  if pcall(vim.cmd, "Neotree toggle") then
    return
  end
  if _G.Snacks and _G.Snacks.explorer then
    Snacks.explorer()
    return
  end
  vim.cmd("Lexplore")
end, { desc = "Toggle Explorer" })
