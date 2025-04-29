-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>r", "<Nop>", { desc = "Run Menu" })

vim.keymap.set("n", "<leader>rp", function()
  vim.cmd("wa | execute 'new | setlocal buftype=nofile | terminal python ' . expand('%')")
end, { desc = "🐍 run file" })

vim.keymap.set("n", "<leader>rt", function()
  vim.cmd("wa | execute 'new | setlocal buftype=nofile | terminal pytest --pdb ' . expand('%')")
end, { desc = "🐍 run pytest" })

local pytest_runner = require("config.pytest_runner")
vim.keymap.set("n", "<leader>rf", pytest_runner.run_pytest_on_function, {
  noremap = true, -- Non-recursive mapping
  silent = true, -- Don't echo the command
  desc = "🐍 Run pytest on function under cursor", -- Description for which-key etc.
})
