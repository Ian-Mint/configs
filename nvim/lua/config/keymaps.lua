-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>r", function()
  vim.cmd("wa | execute 'new | setlocal buftype=nofile | terminal python ' . expand('%')")
end, { desc = "🐍 run file" })
