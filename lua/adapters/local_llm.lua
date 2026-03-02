---@class CodeCompanion.HTTPAdapter
local LocalLLMAdapter = {
    name = "local_llm",
    formatted_name = "Local LLM",

    -- Map CodeCompanion roles to your LLM roles
    roles = {
        system = "system",
        user = "user",
        assistant = "assistant",
    },

    -- URL of your local LLM endpoint
    url = "${url}",

    -- Environment variables to inject
    env = {
        api_key = "LOCAL_LLM_API_KEY",  -- Lua will look for this in your system env
        url = "LOCAL_LLM_URL",          -- URL of your local LLM
    },

    -- Headers, including API key auth
    headers = {
        ["Authorization"] = "Bearer ${api_key}",
        ["Content-Type"] = "application/json",
    },

    -- Default parameters (depends on your LLM API)
    parameters = {
        model = "gpt-4",    -- replace with your local model name
        temperature = 0.7,
        max_tokens = 2048,
    },

    -- Body template (your LLM might require messages or prompt)
    body = {
        prompt = "${prompt}",  -- we'll inject the prompt in handlers
    },

    -- Handlers: the real "magic" of request/response mapping
    handlers = {
        lifecycle = {
            setup = function(self)
                -- Optional pre-request setup
            end,
            on_exit = function(self, data)
                -- Optional post-request handling
            end,
            teardown = function(self)
                -- Optional cleanup
            end,
        },
        request = {
            build_parameters = function(self, params, messages)
                -- Inject prompt/messages into body
                local body = { prompt = table.concat(messages, "\n") }
                return body
            end,
            build_messages = function(self, messages)
                -- Transform CodeCompanion messages to your LLM format
                return messages
            end,
        },
        response = {
            parse_chat = function(self, data)
                -- Extract text from your LLM's response
                return data.text or data.response
            end,
        },
    },

    -- Schema for user-configurable parameters in chat buffer
    schema = {
        model = { type = "string", default = "gpt-4" },
        temperature = { type = "number", default = 0.7 },
        max_tokens = { type = "number", default = 2048 },
    },
}

return LocalLLMAdapter
