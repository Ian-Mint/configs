return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- pyright = { enabled = false },
        ty = {
          root_dir = require("lspconfig.util").root_pattern("ty.toml", ".git"),
        },
      },
    },
  },
}
