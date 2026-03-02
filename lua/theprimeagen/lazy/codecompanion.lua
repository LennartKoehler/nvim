return {
  "olimorris/codecompanion.nvim",
  version = "^19.0.0",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },

  opts = function()
    local adapters = require("codecompanion.adapters")

    return {
      strategies = {
        chat = {
          adapter = "local_llm",
        },
      },

      adapters = {
        http = {
          local_llm = adapters.extend("openai_compatible", {
            name = "local_llm",
            formatted_name = "Local LLM",

            roles = { system = "system", user = "user", assistant = "assistant" },

            env = {
              api_key = "LOCAL_LLM_API_KEY",
              base_url = "LOCAL_LLM_URL",
            },

            -- Optional override for non-standard endpoints
            url = "${base_url}",

            schema = {
              model = { default = "vllm/minimax-m2.5-128k" },
              temperature = { default = 0.7 },
              max_tokens = { default = 2048 },
            },
          }),
        },
      },
    }
  end,
}
