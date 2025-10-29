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
  desc = "🐍 Run pytest on function under cursor",
})

-- emacs motions
vim.keymap.set("n", "<C-a>", "^", { desc = "Go to beginning of line (Emacs Ctrl+a)" })
vim.keymap.set("n", "<C-e>", "$", { desc = "Go to end of line (Emacs Ctrl+e)" })
vim.keymap.set("v", "<C-a>", "^", { desc = "Go to beginning of line (Emacs Ctrl+a)" })
vim.keymap.set("v", "<C-e>", "$", { desc = "Go to end of line (Emacs Ctrl+e)" })

local function surround_visual(open, close)
  local keys = vim.api.nvim_replace_termcodes("c" .. open .. "<C-r>\"" .. close .. "<Esc>", true, true, true)
  local was_disabled = vim.g.minipairs_disable
  vim.g.minipairs_disable = true
  vim.api.nvim_feedkeys(keys, "x", false)
  vim.schedule(function()
    vim.g.minipairs_disable = was_disabled
  end)
end

for _, mapping in ipairs({
  { '"', '"' },
  { "'", "'" },
  { "`", "`" },
  { "(", ")" },
  { "[", "]" },
  { "{", "}" },
}) do
  local open, close = mapping[1], mapping[2]
  vim.keymap.set("x", open, function()
    surround_visual(open, close)
  end, { desc = ("Wrap selection with %s%s"):format(open, close) })
end
