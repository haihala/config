local lsp_zero = require("lsp-zero").preset({
    set_basic_mappings = false,
    set_extra_mappings = false,
})
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'tsserver',
        'eslint',
        'pylsp',
        'lua_ls',
        'rust_analyzer',
    },
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require("lspconfig").lua_ls.setup(lua_opts)
        end
    }
})
local cmp = require("cmp")
cmp.setup({
    formatting = lsp_zero.cmp_format(),
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }
})

local picker = require("telescope.builtin")

lsp_zero.on_attach(function(client, bufnum)
    local opts = { buffer = bufnum, remap = false }

    -- Info popup
    vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, opts) -- Inspect

    -- Jump
    vim.keymap.set("n", "<leader>jd", picker.lsp_definitions, opts)
    vim.keymap.set("n", "<leader>jr", picker.lsp_references, opts)

    -- Diagnostics
    vim.keymap.set("n", "<leader>di", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>dl", picker.diagnostics, opts)
    vim.keymap.set("n", "<leader>d[", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>d]", vim.diagnostic.goto_prev, opts)

    -- Actions
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)

    -- Automatic format on save
    vim.cmd [[autocmd BufWritePre * silent! lua vim.lsp.buf.format({filter = function(c) return c.name ~="tsserver" end})]]
end)

lsp_zero.setup()
