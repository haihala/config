vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
        'nvim-telescope/telescope-file-browser.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use({ 'dracula/vim', as = 'dracula' })
    vim.cmd('colorscheme dracula')

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use 'ThePrimeagen/harpoon'
    use 'mbbill/undotree'
    use 'tpope/vim-fugitive'
    use 'airblade/vim-gitgutter'
    use 'mhinz/vim-startify'
    use 'APZelos/blamer.nvim'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { { 'nvim-tree/nvim-web-devicons', opt = true } }
    }

    use {
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function() require("todo-comments").setup {} end
    }

    use({
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },   -- Required
            {
                'williamboman/mason.nvim', -- Optional
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    })

    use 'jwalton512/vim-blade'

    -- Null-ls was mostly used for prettier, which now comes from neoformat
    -- use 'jose-elias-alvarez/null-ls.nvim'

    -- Copilot slows down editing a lot if not logged in
    -- use 'github/copilot.vim'

    use {
        "ahmedkhalf/project.nvim",
        config = function()
            require("project_nvim").setup {
                detection_methods = { ">Repos" },
                patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile" }
            }
        end
    }

    use 'sbdchd/neoformat'

    use 'christoomey/vim-tmux-navigator'
end)
