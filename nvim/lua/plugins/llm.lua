return {
  {
    "huggingface/llm.nvim",
    opts = {
      backend = "ollama",
      model = "qwen2.5-coder:1.5b",
      url = "http://localhost:11434",
      request_body = {
        options = {
          temperature = 0.2,
          top_p = 0.95,
        },
      },
      tokens_to_clear = { "<|endoftext|>" },
      fim = {
        enabled = true,
        prefix = "<|fim_prefix|>",
        middle = "<|fim_middle|>",
        suffix = "<|fim_suffix|>",
      },
      context_window = 4096,
      tokenizer = nil,
      debounce_ms = 200,
      accept_keymap = "<Tab>",
      dismiss_keymap = "<S-Tab>",
      enable_suggestions_on_startup = true,
      enable_suggestions_on_files = "*",
    },
  },
}
