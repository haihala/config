local picker = require("telescope.builtin")

local M = {}

M.on_attach = function(ev)
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
    vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action, opts)

    -- Toggle inlay Hints
    vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    end)

    -- Automatic format on save for lua
    if vim.bo.filetype == "lua" then
        vim.cmd [[autocmd BufWritePre * silent! lua vim.lsp.buf.format()]]
    end

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

M.setup = function()
    vim.lsp.config("lua_ls", {
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
        }
    })

    -- Enable LSP servers for Neovim 0.11+
    local ts_server = vim.g.lsp_typescript_server or "ts_ls" -- "ts_ls" or "vtsls" for TypeScript
    vim.lsp.enable({
        ts_server,
        "eslint",
        "html",
        "marksman", -- Markdown
        "svelte",
        "wgsl_analyzer",
        "pylsp",
        "lua_ls",
        "rust_analyzer",
        "jsonls",
    })

    -- Change the Diagnostic symbols in the sign column (gutter)
    vim.diagnostic.config({
        virtual_lines = {
            current_line = true,
        },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN] = " ",
                [vim.diagnostic.severity.HINT] = "󰠠 ",
                [vim.diagnostic.severity.INFO] = " ",
            },
            numhl = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "",
                [vim.diagnostic.severity.INFO] = "",
            },
        },
    })
end

return M
