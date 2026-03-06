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
          cursor_agent = function()
            return require("codecompanion.adapters").extend("gemini_cli", {
              name = "cursor_agent",
              formatted_name = "Cursor Agent",
              commands = {
                default = {
                  os.getenv("HOME") .. "/.local/bin/agent",
                  "acp",
                },
              },
              defaults = {
                auth_method = "cursor_login",
                mcpServers = {},
                timeout = 30000,
              },
              env = {},
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "cursor_agent",
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
