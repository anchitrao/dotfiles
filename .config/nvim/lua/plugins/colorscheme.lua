return {
  -- add flexoki colorscheme
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
  },

  -- Configure LazyVim to load flexoki dark
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "flexoki-dark",
    },
  },
}
