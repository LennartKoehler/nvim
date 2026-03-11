return {

    "MeanderingProgrammer/render-markdown.nvim", -- Make Markdown buffers look beautiful
    ft = { "markdown", "codecompanion" },
    opts = {
      render_modes = true, -- Render in ALL modes
      sign = {
        enabled = false, -- Turn off in the status column
      },

        code = {
            style = "full",
            sign = false,
        },
        heading = {
            icons = {},  -- Disables icons
            render = true,
            style = "bold",  -- Makes text bold
            -- Add background highlight to make headings "pop" more
            highlight = {
                "RenderMarkdownH1",
                "RenderMarkdownH2",
                "RenderMarkdownH3",
            },
        },
        conceal = {
            enabled = true,
        }
    },
};
