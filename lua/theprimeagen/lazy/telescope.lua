return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        local telescope = require('telescope')
        telescope.setup({
            defaults = {
                layout_strategy = 'horizontal',
                layout_config= {
                  bottom_pane = {
                    height = 25,
                    preview_cutoff = 120,
                    prompt_position = "top"
                  },
                  center = {
                    height = 0.4,
                    preview_cutoff = 40,
                    prompt_position = "top",
                    width = 0.5
                  },
                  cursor = {
                    height = 0.9,
                    preview_cutoff = 40,
                    width = 0.8
                  },
                  horizontal = {
                    height = 0.9,
                    preview_cutoff = 100,
                    preview_width = 0.45,
                    prompt_position = "bottom",
                    width = 0.9
                  },
                  vertical = {
                    height = 0.9,
                    preview_cutoff = 40,
                    prompt_position = "bottom",
                    width = 0.8
                  }
                },
                mappings = {
                    i = {
                        -- map actions.which_key to <C-h> (default: <C-/>)
                        -- actions.which_key shows the mappings for your picker,
                        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                        -- ["<C-k>"] = "move_selection_next",
                        -- ["<C-j>"] = "move_selection_previous"
                    }
                }
            }
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>fp', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        -- vim.keymap.set('n', '<leader>pws', function()
        --     local word = vim.fn.expand("<cword>")
        --     builtin.grep_string({ search = word })
        -- end)
        -- vim.keymap.set('n', '<leader>pWs', function()
        --     local word = vim.fn.expand("<cWORD>")
        --     builtin.grep_string({ search = word })
        -- end)
        vim.keymap.set('n', '<leader>fg', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end,
}

