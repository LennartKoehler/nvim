-- CodeCompanion local LLM adapter configuration
local modelState = {
    ANTICIPATING_REASONING = 1,
    REASONING = 2,
    ANTICIPATING_OUTPUTTING = 3,
    OUTPUTTING = 4,
}
---@type integer
local _ollama_state


return {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    lazy = false,
    debug = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        { "<leader>cc", "<cmd>CodeCompanion /default<cr>", desc = "Code Companion Chat" },
        { "<leader>cy", "<cmd>CodeCompanionChat<cr>", desc = "Run Test Prompt" },
    },
    config = function()
        local adapters = require("codecompanion.adapters")


        require("codecompanion").setup({
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
                            model = { default = "vllm/minimax-m2.5-128k" },
                            temperature = { default = 0.7 },
                            max_tokens = { default = 2048 },
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

            --     handlers = {
            --   response = {
            --     parse_meta = function(self, data)
            --       print(">>> parse_meta called!")
            --       local extra = data.extra
            --       if extra.reasoning_content then
            --         data.output.reasoning = { content = extra.reasoning_content }
            --         if data.output.content == "" then
            --           data.output.content = nil
            --         end
            --       end
            --       if data.output.content then
            --         data.output.content = data.output.content:gsub("</think>", "[REASONING END]")
            --       end
            --       return data
            --     end,
            --   },
            -- },
            --       groups = {
            --         my_agent = {
            --           description = "My custom agent",
            --           system_prompt = function(group, ctx)
            --             return string.format([[
            -- You are a coding agent.
            --
            -- The date is %s.
            -- The user is on %s.
            --
            -- You always have access to the current file:
            --
            -- #{buffer}
            -- ]], ctx.date, ctx.os)
            --           end,
            --           tools = { "read_file", "insert_edit_into_file", "run_command" },
            --           opts = {
            --
            --             ignore_system_prompt = true,
            --             ignore_tool_system_prompt = true,
            --           },
            --         },
            --       },

            prompt_library = {
                markdown = {
                    dirs = {
                        vim.fn.getcwd() .. "/lua/prompts", -- Can be relative
                    },
                },
            },
        })
    end,
}
