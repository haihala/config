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
        'williamboman/mason.nvim',
        dependencies = { 'williamboman/mason-lspconfig.nvim' },
        config = function()
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'ts_ls',
                    'eslint',
                    'pylsp',
                    'lua_ls',
                    'rust_analyzer',
                },
                automatic_installation = true,
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            'saghen/blink.cmp',
            'nvim-telescope/telescope.nvim',
            { 'williamboman/mason-lspconfig.nvim' },
            { -- Automatically do stuff on file rename, maybe with oil?
                "antosha417/nvim-lsp-file-operations",
                config = true,
            },
        },
        config = function()
            local lspconfig = require("lspconfig")
            local picker = require("telescope.builtin")

            local on_attach = function(ev)
                local opts = { silent = true, remap = false, buffer = ev.buf }
                -- Info popup
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Inspect

                -- Jump
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gr", function() picker.lsp_references({ include_declaration = false, }) end,
                    opts)
                -- Overlaps with Find Spelling
                -- vim.keymap.set("n", "<leader>fs", picker.lsp_document_symbols, opts) -- find symbols

                -- Diagnostics
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "<leader>fd", picker.diagnostics, opts) -- Find diagnostics
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

                -- Actions
                vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)

                -- Toggle inlay Hints
                vim.keymap.set("n", "<leader>th", function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
                end)

                -- Automatic format on save except with typescript language server (prefer prettier)
                vim.cmd [[autocmd BufWritePre * silent! lua vim.lsp.buf.format({filter = function(c) return c.name ~="ts_ls" end})]]

                for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
                    local default_diagnostic_handler = vim.lsp.handlers[method]
                    vim.lsp.handlers[method] = function(err, result, context, config)
                        if err ~= nil and err.code == -32802 then
                            return
                        end
                        return default_diagnostic_handler(err, result, context, config)
                    end
                end
            end

            local capabilities = require('blink.cmp').get_lsp_capabilities()

            -- Change the Diagnostic symbols in the sign column (gutter)
            local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
            end

            -- This allows for per language server configs
            require("mason-lspconfig").setup_handlers({
                -- default
                function(server_name)
                    lspconfig[server_name].setup({
                        on_attach = on_attach,
                        capabilities = capabilities
                    })
                end,
                ["lua_ls"] = function()
                    -- configure lua server (with special settings)
                    lspconfig["lua_ls"].setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                -- make the language server recognize "vim" global
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                completion = {
                                    callSnippet = "Replace",
                                },
                            },
                        },
                    })
                end,
            })
        end
    },
}
