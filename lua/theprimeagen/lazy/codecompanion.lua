-- CodeCompanion: Local LLM adapter configuration
-- State machine for tracking LLM output phases
local modelState = {
    ANTICIPATING_REASONING = 1,
    REASONING = 2,
    ANTICIPATING_OUTPUTTING = 3,
    OUTPUTTING = 4,
}
---@type integer
local _ollama_state


return {
    -- "codecompanion",
    -- dir = "~/projects/codecompanion.nvim",
    -- "olimorris/codecompanion.nvim",
    "LennartKoehler/codecompanion.nvim",
    -- version = "^19.0.0",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        { "<leader>cc", "<cmd>CodeCompanion /default<cr>", desc = "Code Companion Chat" },
        { "<leader>cy", "<cmd>CodeCompanionChat<cr>", desc = "Run Test Prompt" },
    },

    -- opts = {
    --     opts = {
    --         log_level = "TRACE", -- or "TRACE"
    --     },
    -- },
    config = function()

        local adapters = require("codecompanion.adapters")
        require("codecompanion").setup({
          -- opts = {
          --   log_level = "TRACE", -- or "TRACE"
          -- },
              display = {
                diff = {
                  -- Diffs with fewer lines than this are shown directly in the chat buffer
                  -- Diffs with more lines automatically open in a floating window
                  threshold_for_chat = 0, -- adjust this number to your preference
                },
              },
            interactions = {
                chat = {
                  opts = {
                    completion_provider = "cmp", -- blink|cmp|coc|default
                  }
                }
              },
            autocomplete = false,
            debug = true,
            strategies = {
                chat = {
                    adapter = "local_llm",
                },
            },
            adapters = {
                http = {
                    local_llm = adapters.extend("openai_compatible", {
                        name = "local_llm",
                        tools = adapters.USAGE_ADAPTER_TOOLS,  -- Enable editing tools
                        formatted_name = "Local LLM",
                        roles = { system = "system", user = "user", assistant = "assistant" },
                        env = {
                            api_key = "LOCAL_LLM_API_KEY",
                            base_url = "LOCAL_LLM_URL",
                        },
                        url = "${base_url}",
                        schema = {
                            model = { default = "vllm/glm-5-fp8-200k" },
                            -- model = { default = "vllm/minimax-m2.5-128k" },
                            -- temperature = { default = 0.7 },
                            -- max_tokens = { default = 2048 },
                        },
                        ---Check for a token before starting the request
                        ---@param self CodeCompanion.Adapter
                        ---@return boolean
                        setup = function(self)
                            _ollama_state = modelState.ANTICIPATING_OUTPUTTING
                            return true
                        end,
                        handlers = {
                            chat_output = function(self, indata, tools)
                                -- normalize data: if it's a string, convert it to a table
                                local formatLine = true
                                local openai = require("codecompanion.adapters.http.openai")
                                local data = openai.handlers.chat_output(self, indata, tools)
                                if type(data) == "string" then
                                    data = { output = { content = data } }
                                elseif type(data) == "table" then
                                    data.output = data.output or {}
                                    data.output.content = data.output.content or ""
                                else
                                    -- unknown type: just return as-is
                                    return data
                                end

                                local content = data.output.content
                                local reasoning = nil

                                if string.find(content, "<think>") ~= nil then
                                    local before, after = content:match("^(.-)<think>(.*)$")

                                    if before then
                                        formatLine = false
                                        _ollama_state = modelState.ANTICIPATING_REASONING

                                        content =
                                        before ..
                                        "\n----------🎩 Putting on my thinking cap 🎩----------\n\n\t" ..
                                        after
                                    end
                                end
                                if content:find("</think>") then
                                    local before, after = content:match("^(.-)</think>(.*)$")

                                    if before then
                                        formatLine = false
                                        _ollama_state = modelState.ANTICIPATING_OUTPUTTING

                                        content =
                                        before ..
                                        "\n----------🎩 Removing my thinking cap 🎩----------\n" ..
                                        after
                                    end
                                end

                                if _ollama_state == modelState.ANTICIPATING_REASONING or _ollama_state == modelState.REASONING then
                                    if formatLine then
                                        content = content:gsub("\n", "\n\t")
                                    end
                                end

                                if _ollama_state == modelState.ANTICIPATING_OUTPUTTING then
                                    _ollama_state = modelState.OUTPUTTING
                                elseif _ollama_state == modelState.ANTICIPATING_REASONING then
                                    _ollama_state = modelState.REASONING
                                end

                                data.output.content = content or ""
                                if reasoning then
                                    data.output.reasoning = reasoning
                                end

                                return data
                            end,
                        }
                    }),
                },
            },


            prompt_library = {
                markdown = {
                    dirs = {
                        "~/.config/nvim/lua/prompts",
                    },
                },
            },
        })


    end,

}
