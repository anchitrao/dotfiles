return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {}, -- Basic setup for ruff
        -- If you're replacing another LSP like pyright, you might need to disable it:
        pyright = {
          mason = false, -- If you manage pyright with mason, disable it here
          autostart = false,
        },
      },
      -- You can also pass init_options for ruff-lsp if needed
      -- ruff = {
      --   init_options = {
      --     settings = {
      --       -- Your ruff-specific settings here, e.g.,
      --       lint = {
      --         ignore = { "E701", "E702" },
      --       },
      --     },
      --   },
      -- },
    },
  },
}
