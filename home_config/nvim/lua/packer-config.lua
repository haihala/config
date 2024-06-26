vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.7',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
        "stevearc/oil.nvim",
        config = function() require("oil").setup() end,
    }

    use {
        "cbochs/grapple.nvim",
        requires = { "nvim-tree/nvim-web-devicons" }
    }

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'mbbill/undotree'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat' -- This is just for vim-surround
    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'
    use 'mhinz/vim-startify'
    use 'norcalli/nvim-colorizer.lua'
    use 'sbdchd/neoformat'
    use 'christoomey/vim-tmux-navigator'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { { 'nvim-tree/nvim-web-devicons', opt = true } }
    }

    -- Highlights TODO/FIXME/etc
    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function() require("todo-comments").setup {} end
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment these if you want to manage LSP servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }

    -- Copilot slows down editing a lot if not logged in
    -- use 'github/copilot.vim'

    -- IIRC, the purpose of this is to set the cwd to the root of the project
    -- This will make certain plugins work better
    use {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                detection_methods = { "pattern" },
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", ">projects" }
            }
        end
    }
end)
