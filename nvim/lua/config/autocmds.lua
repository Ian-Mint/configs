-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "ty" then
      return
    end

    local bufnr = args.buf
    if vim.bo[bufnr].filetype ~= "python" then
      return
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
      buffer = bufnr,
      silent = true,
      desc = "Go to Definition",
    })
  end,
})
