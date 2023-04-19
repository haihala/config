local lsp = require('lsp-zero').preset({
    set_basic_mappings = false,
    set_extra_mappings = false,
})

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'pylsp',
    'lua_ls',
    'rust_analyzer',
})

-- Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

local cmp = require('cmp')

cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }
})

lsp.on_attach(function(client, bufnum)
    lsp.default_keymaps({ buffer = bufnum })

    local opts = { buffer = bufnum, remap = false }

    -- Show
    vim.keymap.set("n", "<leader>h", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)

    -- Diagnostics
    vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

    -- Actions
    vim.keymap.set("n", "<leader>r", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>a", function() vim.lsp.buf.code_action() end, opts)

    -- Automatic format on save
    vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
end)

lsp.setup()
