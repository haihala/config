return {
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        -- dependencies = 'rafamadriz/friendly-snippets',

        version = '*',
        opts = {
            -- I used to have CR as a complete submission, but will try going without now
            keymap = {
                preset = 'default',
                -- Unfortunately, this is my tmux prefix
                ['<C-space>'] = {},
                -- For 'blink', same as default ctrl+space
                ['<C-b>'] = { 'show', 'show_documentation', 'hide_documentation' },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
        },
        opts_extend = { "sources.default" }
    },
    {
        'neovim/nvim-lspconfig',
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            'saghen/blink.cmp',
            'nvim-telescope/telescope.nvim',
            { -- Automatically do stuff on file rename, maybe with oil?
                "antosha417/nvim-lsp-file-operations",
                config = true,
            },
        },
    },
}
