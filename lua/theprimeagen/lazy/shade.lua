return{
    "LennartKoehler/shade.nvim",

    config = function()
        require'shade'.setup({
            overlay_opacity = 80,
            opacity_step = 1,
            keys = {
                brightness_up    = '<C-Up>',
                brightness_down  = '<C-Down>',
                toggle           = '<Leader>s',
            },
          exclude_filetypes = { "TelescopePrompt", "TelescopeResults" },
          exclude_buftypes = { "nofile", "prompt" },
        })
    end,
}
