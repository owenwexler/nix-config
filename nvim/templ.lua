return {
  {
    "mason-org/mason.nvim",
    -- templ starts gopls internally for embedded Go code.
    opts = { ensure_installed = { "gopls" } },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "templ", "go", "css" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Use the templ CLI already installed in ~/go/bin.
        templ = { mason = false },
      },
    },
  },
}
