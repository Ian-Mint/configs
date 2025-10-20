local node_path = vim.env.HOME .. "/.local/share/nvm/v22.20.0/bin/node"

local function get_copilot_node()
  if vim.fn.executable(node_path) == 1 then
    return node_path
  end
end

return {
  {
    "zbirenbaum/copilot.lua",
    opts = function(_, opts)
      opts = opts or {}
      local node = get_copilot_node()
      if node then
        opts.copilot_node_command = node
      else
        vim.notify("Copilot node executable not found at " .. node_path, vim.log.levels.WARN)
      end
      return opts
    end,
  },
}
