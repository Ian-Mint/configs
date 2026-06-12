return {
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    keys = {
      { "<leader>a", "", desc = "AI", mode = { "n", "v" } },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle chat", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>CodeCompanionActions<cr>", desc = "Action palette", mode = { "n", "v" } },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "Inline assistant", mode = { "n", "v" } },
      { "ga", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to chat", mode = "v" },
    },
    opts = {
      adapters = {
        acp = {
          claude_code = function()
            -- Auth is inherited from the local `claude` subscription login
            -- (~/.claude/.credentials.json), so no token/key is set here.
            -- The wrapper sanitizes settings (e.g. permissions.defaultMode =
            -- "auto", which the bundled Agent SDK rejects) without touching the
            -- real ~/.claude used by the `claude` CLI. See bin/claude-acp.sh.
            local wrapper = vim.fn.stdpath("config") .. "/bin/claude-acp.sh"
            return require("codecompanion.adapters").extend("claude_code", {
              commands = {
                default = { wrapper },
                yolo = { wrapper, "--yolo" },
              },
              defaults = {
                mcpServers = {},
                timeout = 30000,
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "claude_code",
          tools = {
            ["create_file"] = {
              opts = { require_approval_before = false },
            },
            ["delete_file"] = {
              opts = { require_approval_before = false },
            },
            ["grep_search"] = {
              opts = { require_approval_before = false },
            },
            ["insert_edit_into_file"] = {
              opts = { require_approval_before = false },
            },
            ["memory"] = {
              opts = { require_approval_before = false },
            },
            ["read_file"] = {
              opts = { require_approval_before = false },
            },
            ["run_command"] = {
              opts = { require_approval_before = false, require_cmd_approval = false },
            },
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "codecompanion" },
        },
        ft = { "markdown", "codecompanion" },
      },
    },
  },
}
