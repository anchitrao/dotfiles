return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {}, -- Linting and formatting
        -- Disable pyright in favor of pyrefly
        pyright = {
          mason = false,
          autostart = false,
        },
        -- Enable pyrefly for type checking and LSP features (go-to-definition, hover, etc.)
        pyrefly = {
          mason = false, -- pyrefly not in mason yet, installed via pip
        },
      },
    },
  },
}
