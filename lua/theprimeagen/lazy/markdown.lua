return {

    "MeanderingProgrammer/render-markdown.nvim", -- Make Markdown buffers look beautiful
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },            -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
    dependencies = { 'nvim-treesitter/nvim-treesitter'}, --, 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    ft = { "markdown", "codecompanion" },
    opts = {

        link = {
            enabled = false
        },
        render_modes = true, -- Render in ALL modes
        sign = {
            enabled = false, -- Turn off in the status column
        },

        code = {
            style = "full",
            sign = false,
        },

        defaults = {
            file_icons = false,
            -- ...
        },
        checkbox = {
            enabled = true,
            render_modes = false,
            bullet = false,
            left_pad = 0,
            right_pad = 1,
            unchecked = {
                icon = '-/',
                highlight = 'RenderMarkdownUnchecked',
                scope_highlight = nil,
            },
            checked = {
                icon = '//',
                highlight = 'RenderMarkdownChecked',
                scope_highlight = nil,
            },
            custom = {
                todo = { raw = '[-]', rendered = '-', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
            },
            scope_priority = nil,
        },
        bullet = {
            enabled = true,
            render_modes = false,
            icons = { '●', '○', '◆', '◇' },
            ordered_icons = function(ctx)
                local value = vim.trim(ctx.value)
                local index = tonumber(value:sub(1, #value - 1))
                return ('%d.'):format(index > 1 and index or ctx.index)
            end,
            left_pad = 0,
            right_pad = 0,
            highlight = 'RenderMarkdownBullet',
            scope_highlight = {},
            scope_priority = nil,
        },
        heading = {
            enabled = true,
            render_modes = false,
            atx = true,
            setext = true,
            sign = true,
            icons = { '', '', '', '', '', '' },
            position = 'overlay',
            signs = { '' },
            width = 'full',
            left_margin = 0,
            left_pad = 0,
            right_pad = 0,
            min_width = 0,
            border = false,
            border_virtual = false,
            border_prefix = false,
            above = '▄',
            below = '▀',
            backgrounds = {
                'RenderMarkdownH1Bg',
                'RenderMarkdownH2Bg',
                'RenderMarkdownH3Bg',
                'RenderMarkdownH4Bg',
                'RenderMarkdownH5Bg',
                'RenderMarkdownH6Bg',
            },
            foregrounds = {
                'RenderMarkdownH1',
                'RenderMarkdownH2',
                'RenderMarkdownH3',
                'RenderMarkdownH4',
                'RenderMarkdownH5',
                'RenderMarkdownH6',
            },
            custom = {},
        },
    },
};
