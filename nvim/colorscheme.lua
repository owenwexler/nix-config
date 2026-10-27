-- Tokyo Night OLED: tokyonight-night with a true black background and white text.
-- on_colors runs after tokyonight works out its derived colors, so every
-- background (floats, sidebars, statusline, popups) ends up black, not navy.
local black = "#000000"

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      on_colors = function(c)
        c.bg = black
        c.bg_dark = black
        c.bg_dark1 = black
        c.bg_float = black
        c.bg_popup = black
        c.bg_sidebar = black
        c.bg_statusline = black
        c.fg = "#ffffff"
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
