-- ~/.config/nvim/lua/custom/pytest_runner.lua

local M = {}

--- Runs pytest on the specific function under the cursor in the current file.
-- Opens the command in a new Neovim terminal buffer.
function M.run_pytest_on_function()
  -- 1. Get the word under the cursor
  local word = vim.fn.expand("<cword>") -- <cword> gets the word under the cursor

  -- 2. Get the full path to the current file
  -- '%:p' expands to the full path of the current buffer
  local current_file = vim.fn.expand("%:p")

  -- Basic validation
  if word == "" then
    vim.notify("No word under cursor to run pytest on.", vim.log.levels.WARN)
    return
  end

  if current_file == "" then
    vim.notify("Cannot determine file path. Buffer might not be saved?", vim.log.levels.WARN)
    return
  end

  -- 3. Construct the pytest command
  -- NOTE: We use vim.fn.shellescape on the file path to handle spaces or special characters.
  -- The function name (word) usually doesn't need escaping for pytest, but it depends
  -- on specific pytest plugins or parameterization syntax if used directly.
  local command = string.format("pytest %s::%s", vim.fn.shellescape(current_file), word)

  -- 4. Execute the command in a Neovim terminal
  -- ':terminal' opens a new terminal buffer and runs the command
  -- We use vim.cmd() to execute Ex commands from Lua
  vim.cmd("tabnew") -- Optional: Open in a new tab
  vim.cmd("terminal " .. command)
  vim.notify("Running: " .. command, vim.log.levels.INFO)
end

return M
