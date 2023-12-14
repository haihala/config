vim.filetype.add({ extension = { wgsl = "wgsl" } })

require('nvim-treesitter.configs').setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "javascript", "typescript", "python", "rust", "c", "lua", "vim", "vimdoc", "query" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },

    indent = { enable = true },

    textobjects = {
        select = {
            enable = true,
            lookahead = true,

            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",

                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",

                ["a="] = "@assignment.outer",
                ["i="] = "@assignment.inner",
                ["l="] = "@assignment.lhs",
                ["r="] = "@assignment.rhs",
            },
        },

        swap = {
            enable = true,

            swap_next = {
                ["<leader>sp"] = "@parameter.inner",
            },
            swap_previous = {
                ["<leader>sP"] = "@parameter.inner",
            },
        },

        move = {
            enable = true,
            set_jumps = true,

            goto_next_start = {
                ["]f"] = "@function.outer",
                ["]t"] = "@class.outer", -- T for type
                ["]l"] = "@loop.*",
                ["]="] = "@assignment.outer",
                ["]b"] = "@block.outer",
            },

            goto_previous_start = {
                ["[f"] = "@function.outer",
                ["[t"] = "@class.outer",
                ["[l"] = "@loop.*",
                ["[="] = "@assignment.outer",
                ["[b"] = "@block.outer",
            },

            goto_next = {
                ["]c"] = "@conditional.outer",
            },

            goto_previous = {
                ["[c"] = "@conditional.outer",
            }
        },
    }
}

vim.keymap.set("n", "<leader>st", ":InspectTree<CR>")

-- This makes motions like ]f repeatable with ; and ,
local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)
