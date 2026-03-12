return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure ty is the only active Python language server.
        basedpyright = false,
        pyright = false,
        pylsp = false,
        jedi_language_server = false,
        ruff = false,
        ruff_lsp = false,
        ty = {
          mason = false,
          cmd = { "ty", "server" },
          filetypes = { "python" },
          root_dir = function(bufnr, on_dir)
            local path = vim.api.nvim_buf_get_name(bufnr)
            if path == "" then
              return
            end

            local start = vim.fs.dirname(path)
            local root = vim.fs.find({
              "ty.toml",
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              ".git",
            }, { upward = true, path = start })[1]

            on_dir(root and vim.fs.dirname(root) or start)
          end,
          settings = {
            ty = {
              -- Analyze the full workspace, not only open files.
              diagnosticMode = "workspace",
              disableLanguageServices = false,
              completions = {
                autoImport = true,
              },
              inlayHints = {
                variableTypes = true,
                callArgumentNames = true,
              },
            },
          },
        },
      },
    },
  },
}
