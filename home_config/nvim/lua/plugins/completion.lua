-- Completion: blink.cmp.
--
-- TODO(nvim-0.12-builtin): Neovim 0.12 ships a usable built-in completion
-- stack that could replace blink entirely. To migrate, drop blink.cmp from
-- config/plugins.lua and use:
--   vim.opt.autocomplete = true                -- pop completion on typing
--   vim.opt.complete = { ".", "w", "b", "u", "F", "o" }
--                                              -- buffer, windows, unloaded, completefunc, omnifunc
--   vim.opt.completeopt = { "menuone", "noselect", "popup", "nearest" }
--   vim.opt.pumborder = "single"               -- visual polish; see 'pumborder'
--   -- plus, on LspAttach:
--   vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
-- Tradeoffs: no fuzzy matching of items (prefix + 'smartcase' only),
-- no multi-source merging beyond 'complete' ordering, no icons in the menu.
-- The current config has no snippets configured, which is the main wart that
-- would otherwise need vim.snippet/LuaSnip to be set up first.

require("blink.cmp").setup({
	-- I used to have CR as a complete submission, but will try going without now
	keymap = {
		preset = "default",
		-- Unfortunately, this is my tmux prefix
		["<C-space>"] = {},
		-- For 'blink', same as default ctrl+space
		["<C-b>"] = { "show", "show_documentation", "hide_documentation" },
	},

	appearance = {
		use_nvim_cmp_as_default = true,
		nerd_font_variant = "mono",
	},

	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})

-- nvim-lsp-file-operations: react to file renames via the LSP workspace edit API.
-- Loaded as a plugin so it can hook into oil.nvim's events; needs no config.
require("lsp-file-operations").setup()

-- nvim-lspconfig itself needs no Lua setup — its only purpose in this config
-- is to ship lsp/*.lua server presets onto the runtimepath, which are then
-- enabled by vim.lsp.enable(...) over in utils/lsp.lua.
