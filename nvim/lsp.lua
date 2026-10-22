return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- harper-ls is installed via Mason, and mason-lspconfig auto-enables every
        -- installed server. Disabling it here also excludes it from auto-enable.
        harper_ls = { enabled = false },
        -- vtsls and ts_ls are both installed and would both attach to TS/JS files,
        -- duplicating diagnostics. Keep vtsls (LazyVim's choice).
        ts_ls = { enabled = false },
        -- denols needs no override: nvim-lspconfig only attaches it when deno.json/deno.lock
        -- is present, and vtsls skips those projects, so the two don't overlap.
      },
    },
  },
}
