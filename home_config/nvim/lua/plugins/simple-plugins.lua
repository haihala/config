return {
    {
        'echasnovski/mini.surround',
        version = false,
        config = function()
            require('mini.surround').setup()
        end
    },
    {
        'windwp/nvim-ts-autotag',
        config = function() require('nvim-ts-autotag').setup() end
    },
    { 'mhinz/vim-startify' },
    {
        "stevearc/oil.nvim",
        keys = { { "<leader>o", "<CMD>Oil<CR>" } },
        config = true,
    },
    {
        'mbbill/undotree',
        keys = { { "<leader>u", vim.cmd.UndotreeToggle } },
        config = function()
            vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
            vim.opt.undofile = true
        end
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                go = { "goimports", "gofmt" },
                -- You can also customize some of the format options for the filetype
                rust = { "rustfmt", lsp_format = "fallback" },
                -- You can use a function here to determine the formatters dynamically
                python = function(bufnr)
                    if require("conform").get_formatter_info("ruff_format", bufnr).available then
                        return { "ruff_format" }
                    else
                        return { "isort", "black", "autopep8" }
                    end
                end,
                markdown = { "biome-check", "prettierd", "prettier", "eslint_d" },
                typescript = { "biome-check", "prettierd", "prettier", "eslint_d" },
                javascript = { "biome-check", "prettierd", "prettier", "eslint_d" },
                typescriptreact = { "biome-check", "prettierd", "prettier", "eslint_d" },
                javascriptreact = { "biome-check", "prettierd", "prettier", "eslint_d" },
                json = { "biome-check", "prettierd", "prettier", "eslint_d" },
                svelte = { "prettierd", "prettier", "eslint_d" }, -- As of writing, biome is experimental in sveltekit

                -- Use the "*" filetype to run formatters on all filetypes.
                -- ["*"] = { "codespell" },

                -- Use the "_" filetype to run formatters on filetypes that don't
                -- have other formatters configured.
                ["_"] = { "trim_whitespace" }, -- trim_whitespace is built-in to conform.nvim
            },
            format_on_save = {
                -- I recommend these options. See :help conform.format for details.
                lsp_format = "fallback",
                timeout_ms = 500,
            },
            stop_after_first = true,
        },
    },
    {
        "lervag/vimtex",
        lazy = false,
        init = function()
            vim.g.vimtex_view_method = "zathura"
        end
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            -- Disables fFtT repeatable overrides
            modes = { char = { enabled = false } }
        },
        -- n - normal
        -- x - visual mode
        -- s - select mode (kinda weird version of visual mode)
        -- v - visual and select modes
        -- i - insert (also used in replace mode)
        -- o - operator pending (Waiting motion, such as after d, c or y)
        -- c - command line (/ or :)
        keys = {
            { "<leader>j",  mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "<leader>tn", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter node" },
            { "r",          mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",          mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>",      mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },
}
