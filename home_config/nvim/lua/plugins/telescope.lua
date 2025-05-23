local strings = require("utils.strings")

return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { "nvim-tree/nvim-web-devicons" },
            { "nvim-telescope/telescope-ui-select.nvim" },
        },
        config = function()
            local telescope = require('telescope')
            local builtin = require('telescope.builtin')

            telescope.setup {
                defaults = {
                    file_ignore_patterns = { ".git/", "node_modules" },
                    layout_strategy = "vertical",
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    }
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                            -- even more opts
                        },
                    }
                }
            }

            require("telescope").load_extension("ui-select")

            -- Find files
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fF', function() builtin.find_files({ no_ignore = true }) end, {})

            -- Find content
            vim.keymap.set('n', '<leader>fc', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fC', function() builtin.live_grep({ additional_args = { "--no-ignore" } }) end,
                {})

            -- Jumps
            vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})

            -- Old (recently opened) files
            vim.keymap.set('n', '<leader>fo', builtin.oldfiles, {})
            vim.keymap.set('n', '<leader>b', builtin.buffers, {})

            -- Help
            vim.keymap.set('n', '<leader>fv', builtin.help_tags, {}) -- Find vim manual
            vim.keymap.set('n', '<leader>fm', builtin.man_pages, {}) -- Find man

            -- Find previous
            vim.keymap.set('n', '<leader>fp', builtin.resume, {})

            -- Find spelling
            vim.keymap.set('n', '<leader>fs', builtin.spell_suggest, {})

            -- Git
            vim.keymap.set('n', '<leader>fgf', builtin.git_files, {})    -- Files not in .gitignore
            vim.keymap.set('n', '<leader>fgb', builtin.git_branches, {}) -- Branches
            vim.keymap.set('n', '<leader>fgc', builtin.git_commits, {})  -- Commits
            vim.keymap.set('n', '<leader>fgs', builtin.git_status, {})   -- Status (lists changed files)


            -- Visual mode
            local function get_selection_visual()
                -- Returns first line of the selection
                return vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))[1]
            end

            local function get_selection_visual_block()
                return vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"))[1]
            end

            local function get_selection()
                local mode = vim.api.nvim_get_mode()["mode"]
                if mode == 'v' then
                    return strings.trim(get_selection_visual())
                elseif mode == 'V' then
                    return strings.trim(get_selection_visual_block())
                else
                    vim.print("You are trying to get visual selection in a weird mode")
                    return nil
                end
            end

            -- Find files
            vim.api.nvim_set_keymap('v', '<leader>ff', '', {
                callback = function()
                    builtin.find_files({ default_text = get_selection() })
                end
            })
            vim.api.nvim_set_keymap('v', '<leader>fU', '', {
                callback = function()
                    builtin.find_files({ default_text = get_selection(), no_ignore = true })
                end
            })

            -- Find content
            vim.api.nvim_set_keymap('v', '<leader>fc', '', {
                callback = function()
                    builtin.live_grep({ default_text = get_selection() })
                end
            })
            vim.api.nvim_set_keymap('v', '<leader>fC', '', {
                callback = function()
                    builtin.live_grep({ default_text = get_selection(), no_ignore = true })
                end
            })
        end
    },

    -- Highlights TODO/FIXME/etc as well, but a big part is the telescope finder so it goes here
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        lazy = false,
        keys = {
            { "<leader>ft", ":TodoTelescope keywords=TODO,FIX<CR>" }
        },
        opts = {},
    },

}
