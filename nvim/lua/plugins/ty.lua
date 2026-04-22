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

            -- Prefer ty.toml or pyproject.toml that actually contains [tool.ty].
            -- Falls back to .git root, then nearest pyproject/setup file.
            local function has_ty_config(filepath)
              local f = io.open(filepath, "r")
              if not f then return false end
              local content = f:read("*a")
              f:close()
              return content:find("%[tool%.ty%]") ~= nil
            end

            local current = start
            local fallback = nil
            while true do
              for _, name in ipairs({ "ty.toml", "pyproject.toml" }) do
                local candidate = current .. "/" .. name
                local f = io.open(candidate, "r")
                if f then
                  f:close()
                  if name == "ty.toml" or has_ty_config(candidate) then
                    on_dir(current)
                    return
                  end
                  if not fallback then fallback = current end
                end
              end
              if vim.uv.fs_stat(current .. "/.git") then
                on_dir(current)
                return
              end
              local parent = vim.fs.dirname(current)
              if parent == current then break end
              current = parent
            end

            -- Last resort: nearest pyproject/setup file or original dir
            local last = vim.fs.find({
              "setup.py",
              "setup.cfg",
              "requirements.txt",
            }, { upward = true, path = start })[1]
            on_dir(last and vim.fs.dirname(last) or fallback or start)
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
