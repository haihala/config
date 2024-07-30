return {
    { 'tpope/vim-surround', },
    { 'tpope/vim-repeat' }, -- This is just for vim-surround,
    { 'mhinz/vim-startify', },
    { 'norcalli/nvim-colorizer.lua', },

    {
        "stevearc/oil.nvim",
        keys = {
            { "<leader>o", "<CMD>Oil<CR>", { desc = "Open parent directory" } }
        },
    },

    {
        "cbochs/grapple.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local grapple = require("grapple")
            vim.keymap.set("n", "<leader>m", grapple.toggle)
            vim.keymap.set("n", "<leader>M", grapple.toggle_tags)
            for i = 1, 9 do
                vim.keymap.set("n", "<A-" .. i .. ">", "<cmd>Grapple select index=" .. i .. "<cr>")
            end
        end,
    },

    {
        'mbbill/undotree',
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
            vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
            vim.opt.undofile = true
        end

    },

    {
        'sbdchd/neoformat',
        config = function()
            vim.g.neoformat_try_node_exe = 1
            vim.cmd [[autocmd BufWritePre * silent! Neoformat]]
        end
    },
    {
        'christoomey/vim-tmux-navigator',
        keys = {
            { "<A-h>", ":TmuxNavigateLeft<CR>" },
            { "<A-j>", ":TmuxNavigateDown<CR>" },
            { "<A-k>", ":TmuxNavigateUp<CR>" },
            { "<A-l>", ":TmuxNavigateRight<CR>" },
        }
    },
    -- Highlights TODO/FIXME/etc
    {
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        keys = {
            { "<leader>ft", ":TodoTelescope keywords=TODO,FIX<CR>" }
        }
    },
    -- IIRC, the purpose of this is to set the cwd to the root of the project
    -- This will make certain plugins work better
    {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                detection_methods = { "pattern" },
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", ">projects" }
            }
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { { 'nvim-tree/nvim-web-devicons', lazy = true } },
        opts = {
            options = {
                icons_enabled = true,
                theme = 'dracula',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { 'branch', 'diff', 'diagnostics' },
                lualine_c = { 'filename' },
                lualine_x = { 'encoding', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        },
    },

    {
        'tpope/vim-fugitive',
        keys = {
            { "<leader>gs", vim.cmd.Git },
            { "<leader>gd", ":Git diff<CR>" },
            { "<leader>gb", ":Git blame<CR>" },
            { "<leader>ga", ":Gwrite<CR>" },
            { "<leader>gu", ":Gread<CR>" },
            { "<leader>gc", ":Git commit<CR>" },
            { "<leader>gp", ":Git push<CR>" },
        }
    },
    {
        'lewis6991/gitsigns.nvim',
        opts = {

            signs                        = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
            numhl                        = true,  -- Toggle with `:Gitsigns toggle_numhl`
            linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir                 = {
                follow_files = true
            },
            auto_attach                  = true,
            attach_to_untracked          = false,
            current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts      = {
                virt_text = true,
                virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
            },
            current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
            sign_priority                = 6,
            update_debounce              = 100,
            status_formatter             = nil,   -- Use default
            max_file_length              = 40000, -- Disable if file is longer than this (in lines)
            preview_config               = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },

            on_attach                    = function(bufnr)
                local gitsigns = require('gitsigns')

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']h', function()
                    gitsigns.nav_hunk('next')
                end)

                map('n', '[h', function()
                    gitsigns.nav_hunk('prev')
                end)

                -- Actions
                map('n', '<leader>hs', gitsigns.stage_hunk)
                map('n', '<leader>hr', gitsigns.reset_hunk)
                map('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                map('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                map('n', '<leader>hS', gitsigns.stage_buffer)
                map('n', '<leader>hu', gitsigns.undo_stage_hunk)
                map('n', '<leader>hR', gitsigns.reset_buffer)
                map('n', '<leader>hp', gitsigns.preview_hunk)
                map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end)
                map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
                map('n', '<leader>hd', gitsigns.diffthis)
                map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
                map('n', '<leader>td', gitsigns.toggle_deleted)

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
        }
    },
}
