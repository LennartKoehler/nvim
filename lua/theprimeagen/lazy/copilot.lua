return {

    {
        "github/copilot.vim",
        config = function()
            -- Disable inline suggestions completely
            vim.g.copilot_enabled = false
        end,
    },

    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        opts = {
            interactions = {
                chat = {
                    adapter = "copilot",
                    model = "gpt-4.1"
                },
            },
            -- NOTE: The log_level is in `opts.opts`
            opts = {
                log_level = "TRACE",
            },
        },
        keys = {
            { "<leader>cc", "<cmd>CodeCompanionChat<cr>", desc = "CodeCompanion Chat" },
        },
    },
}
--  "CopilotC-Nvim/CopilotChat.nvim", -- Copilot Chat
--   {
--     "CopilotC-Nvim/CopilotChat.nvim",
--     dependencies = {
--       "github/copilot.vim",
--       "nvim-lua/plenary.nvim",
--     },
--     build = "make tiktoken",
--     opts = {
--       debug = false,
--         mappings = {
--
--             close = {
--           insert = "",  -- disable internal close on C-c
--           normal = "",  -- disable close in normal mode too
--         },
--       },
--     },
--
--     config = function(_, opts)
--       require("CopilotChat").setup(opts)
--
--       -- Add our own <C-c> as <Esc> inside the chat
--       vim.api.nvim_create_autocmd("FileType", {
--         pattern = "copilot-chat",
--         callback = function(event)
--           local bufnr = event.buf
--
--           -- Set <C-c> to exit insert mode
--           vim.keymap.set("i", "<C-c>", "<Esc>", { buffer = bufnr })
--         end,
--       })
--     end,
--     keys = {
--       { "<leader>cc", "<cmd>CopilotChat<cr>", desc = "Copilot Chat" },
--       { "<leader>ce", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Explain Code" },
--       { "<leader>cr", "<cmd>CopilotChatReview<cr>", mode = "v", desc = "Review Code" },
--       { "<leader>cf", "<cmd>CopilotChatFix<cr>", mode = "v", desc = "Fix Code" },
--     },
--   },
-- }
