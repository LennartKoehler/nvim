vim.api.nvim_create_augroup("DapGroup", { clear = true })

local function navigate(args)
    local buffer = args.buf

    local wid = nil
    local win_ids = vim.api.nvim_list_wins() -- Get all window IDs
    for _, win_id in ipairs(win_ids) do
        local win_bufnr = vim.api.nvim_win_get_buf(win_id)
        if win_bufnr == buffer then
            wid = win_id
        end
    end

    if wid == nil then
        return
    end

    vim.schedule(function()
        if vim.api.nvim_win_is_valid(wid) then
            vim.api.nvim_set_current_win(wid)
        end
    end)
end

local function create_nav_options(name)
    return {
        group = "DapGroup",
        pattern = string.format("*%s*", name),
        callback = navigate
    }
end

local function get_window(name_pattern)
    -- Find buffer matching the pattern (e.g., "DAP Watches")
    local buf_pattern = "*" .. name_pattern .. "*"
    local buf_id = vim.fn.bufnr(buf_pattern, true)

    if buf_id == -1 then
        vim.notify("DAP " .. name_pattern .. " not found", vim.log.levels.WARN)
        return -1
    end

    -- Get window ID containing this buffer
    local win_id = vim.fn.bufwinid(buf_id)

    if win_id == -1 then
        vim.notify("DAP " .. name_pattern .. " window not open", vim.log.levels.WARN)
        return -1
    end
    return win_id
end

local function focus_dap_window(name_pattern)
    local win_id = get_window(name_pattern)
    vim.api.nvim_set_current_win(win_id)
end

local function focus_main_code_window()
    -- Get all windows
    local win_ids = vim.api.nvim_list_wins()


    -- DAP UI filetypes to exclude
    -- We check the filetype instead of the buffer name as it's more reliable
    local dap_filetypes = {
        "dap-repl",
        "dapui-watches",
        "dapui_watches",
        "dapui_scopes",
        "dapui-scopes",
        "dapui-stacks",
        "dapui_stacks",
        "dapui-breakpoints",
        "dapui_breakpoints",
        "dapui-console",
        "dapui_console",
        "dapui-terminal",
        "dapui_terminal",
        "dapui_hover",
    }

    local function is_dap_buffer(bufnr)
        local ft = vim.bo[bufnr].filetype
        -- If the filetype matches any in our list, it's a DAP window
        for _, pattern in ipairs(dap_filetypes) do
            if ft == pattern then
                return true
            end
        end
        return false
    end

    for _, win_id in ipairs(win_ids) do
        local bufnr = vim.api.nvim_win_get_buf(win_id)
        local name = vim.api.nvim_buf_get_name(bufnr)

        -- Skip if empty buffer name or DAP UI buffer
        if not is_dap_buffer(bufnr) then
            vim.api.nvim_set_current_win(win_id)
            return
        end
    end

    -- vim.notify("Could not find main code window", vim.log.levels.WARN)
end
return {
    {
    "mfussenegger/nvim-dap",
    lazy = false,
    config = function()
    local dap = require("dap")
        dap.set_log_level("DEBUG")
        dap.defaults.fallback.focus_frame = false
        dap.defaults.fallback.exception_breakpoints = {"uncaught"}
        vim.keymap.set('n', '<F5>', require 'dap'.continue)
        vim.keymap.set('n', '<F7>', require 'dap'.step_over)
        vim.keymap.set('n', '<F8>', require 'dap'.step_into)
        vim.keymap.set('n', '<F9>', require 'dap'.step_out)
        vim.keymap.set('n', '<F10>', function() dap.run_to_cursor() end)
        vim.keymap.set('n', '<F6>', function()
                require 'dap'.terminate()
                require 'dapui'.close()
            end)
        vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)
        vim.keymap.set("n", "<leader>B", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Debug: Set Conditional Breakpoint" })

    end
    },


    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")


            vim.keymap.set("n", "<leader>dw", function() focus_dap_window("DAP Watches") end, { desc = "Focus DAP Watches window" })
            vim.keymap.set("n", "<leader>dr", function() focus_dap_window("dap-repl") end, { desc = "Focus DAP REPL window" })
            vim.keymap.set("n", "<leader>ds", function() focus_dap_window("DAP Stacks") end, { desc = "Focus DAP Stacks window" })
            vim.keymap.set("n", "<leader>dc", function() focus_dap_window("DAP Scopes") end, { desc = "Focus DAP Scopes window" })
            vim.keymap.set("n", "<leader>dm", function() focus_main_code_window() end, { desc = "Focus main code window" })
            -- local function layout(name)
            --     return {
            --         elements = {
            --             { id = name },
            --         },
            --         enter = true,
            --         size = 40,
            --         position = "right",
            --     }
            -- end
            -- local name_to_layout = {
            --     repl = { elements = { { id = "repl" } }, size = 10, position = "bottom" },
            --     console = { elements = { { id = "console" } }, size = 10, position = "bottom" },
            --     scopes = { elements = { { id = "scopes" } }, size = 40, position = "right" },
            --     stacks = { elements = { { id = "stacks" } }, size = 40, position = "right" },
            --     watches = { elements = { { id = "watches" } }, size = 15, position = "left" },
            --     breakpoints = { elements = { { id = "breakpoints" } }, size = 15, position = "left" },
            -- }
            -- local layouts = {}
            --
            -- for name, config in pairs(name_to_layout) do
            --     table.insert(layouts, config.layout)
            --     name_to_layout[name].index = #layouts
            -- end
            --
            -- local function toggle_debug_ui(name)
            --     dapui.close()
            --     local layout_config = name_to_layout[name]
            --
            --     if layout_config == nil then
            --         error(string.format("bad name: %s", name))
            --     end
            --
            --     local uis = vim.api.nvim_list_uis()[1]
            --     if uis ~= nil then
            --         layout_config.size = uis.width
            --     end
            --
            --     pcall(dapui.toggle, layout_config.index)
            -- end

            -- vim.keymap.set("n", "<leader>dr", function() toggle_debug_ui("repl") end, { desc = "Debug: toggle repl ui" })
            -- vim.keymap.set("n", "<leader>ds", function() toggle_debug_ui("stacks") end,
            --     { desc = "Debug: toggle stacks ui" })
            -- vim.keymap.set("n", "<leader>dw", function() toggle_debug_ui("watches") end,
            --     { desc = "Debug: toggle watches ui" })
            -- vim.keymap.set("n", "<leader>db", function() toggle_debug_ui("breakpoints") end,
            --     { desc = "Debug: toggle breakpoints ui" })
            -- vim.keymap.set("n", "<leader>dS", function() toggle_debug_ui("scopes") end,
            --     { desc = "Debug: toggle scopes ui" })
            -- vim.keymap.set("n", "<leader>dc", function() toggle_debug_ui("console") end,
            --     { desc = "Debug: toggle console ui" })
            --
            vim.api.nvim_create_autocmd("BufEnter", {
                group = "DapGroup",
                pattern = "*dap-repl*",
                callback = function()
                    vim.wo.wrap = true
                end,
            })

            vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("dap-repl"))
            vim.api.nvim_create_autocmd("BufWinEnter", create_nav_options("DAP Watches"))

            dapui.setup({
                controls = {
                icons = {
                  expanded = "+",        -- for expanded panels
                  collapsed = "-",       -- for collapsed panels
                  current_frame = ">",   -- current frame indicator
                  breakpoint = "B",      -- breakpoint marker
                  stopped = "S",         -- stopped state
                  -- Debug actions
                  disconnect = "X",      -- disconnect
                  pause = "||",          -- pause
                  play = ">",            -- play / continue
                  run_last = "R",        -- rerun last
                  step_back = "<-",      -- step back
                  step_into = "v",       -- step into
                  step_out = "^",        -- step out
                  step_over = "->",      -- step over
                  terminate = "!"        -- terminate / stop
                },
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25, name = "Scopes" },
                            { id = "stacks", size = 0.25, name = "Stacks" },
                            { id = "watches", size = 0.25, name = "Watches" },
                            { id = "breakpoints", size = 0.25, name = "Breakpoints" },
                        },
                        size = 40,
                        position = "right",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.5, name = "REPL" },
                            { id = "console", size = 0.5, name = "Console" },
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
                enter = true,
            })
            dap.listeners.before.attach.dapui_config = function()
                local current_win = vim.api.nvim_get_current_win()
                dapui.open()
                vim.schedule(function()
                    vim.api.nvim_set_current_win(current_win)
                end)
            end
            dap.listeners.before.launch.dapui_config = function()
                local current_win = vim.api.nvim_get_current_win()
                dapui.open()
                vim.schedule(function()
                    vim.api.nvim_set_current_win(current_win)
                end)
            end
            dap.listeners.after.terminated.dapui_config = function()
                dapui.close()
                print("closing ui")
            end
            dap.listeners.after.event_output.dapui_config = function(_, body)
                if body.category == "console" then
                    dapui.eval(body.output) -- Sends stdout/stderr to Console
                end
            end
        end,
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = {
                    "cppdbg",
                },
                automatic_installation = true,
                handlers = {
                    function(config)
                        require("mason-nvim-dap").default_setup(config)
                    end,

                },
            })
        end,
    },

}
