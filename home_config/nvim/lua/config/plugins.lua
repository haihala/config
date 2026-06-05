-- Central plugin manifest using Neovim 0.12's built-in vim.pack.
-- Plugins are loaded eagerly (no lazy-loading by design — the small startup cost
-- is acceptable and removes a class of debugging headaches).
--
-- Each plugin source is declared here; per-plugin configuration lives in
-- the corresponding lua/plugins/*.lua module, required after vim.pack.add.

-- Build hooks: run when a plugin is freshly installed or updated.
-- Must be registered BEFORE vim.pack.add so install-time triggers fire.
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind
		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			-- Download/build the native Rust fuzzy matcher. pwait blocks but
			-- shows progress; without it the matcher would silently fall back
			-- to the slower Lua implementation.
			require("blink.cmp").build():pwait()
		end
	end,
})

vim.pack.add({
	-- Completion + LSP presets
	"https://github.com/saghen/blink.lib",
	"https://github.com/saghen/blink.cmp",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/antosha417/nvim-lsp-file-operations",

	-- Formatting
	"https://github.com/stevearc/conform.nvim",

	-- Treesitter: parser/query installer only (highlight/folds/incsel come from built-in vim.treesitter)
	"https://github.com/nvim-treesitter/nvim-treesitter",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	"https://github.com/windwp/nvim-ts-autotag",

	-- Telescope + finders
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
	"https://github.com/folke/todo-comments.nvim",

	-- UI
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/rcarriga/nvim-notify",
	"https://github.com/folke/noice.nvim",
	"https://github.com/3rd/image.nvim",
	"https://github.com/mhinz/vim-startify",

	-- Git
	"https://github.com/tpope/vim-fugitive",
	"https://github.com/lewis6991/gitsigns.nvim",

	-- Navigation / editing
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/cbochs/grapple.nvim",
	"https://github.com/folke/flash.nvim",
	"https://github.com/echasnovski/mini.surround",
	"https://github.com/mbbill/undotree",
	"https://github.com/christoomey/vim-tmux-navigator",

	-- Language-specific
	"https://github.com/lervag/vimtex",
})

-- :Packupdate and :Packdel user commands. As of Nvim 0.12.2 only the Lua
-- API (vim.pack.update / vim.pack.del) is exposed; the built-in lowercase
-- :packupdate / :packdel commands exist on master and will land in a future
-- release. Remove these wrappers once they do.
vim.api.nvim_create_user_command("Packupdate", function(opts)
	vim.pack.update(#opts.fargs > 0 and opts.fargs or nil)
end, { nargs = "*", desc = "Update vim.pack plugins (optionally by name)" })

vim.api.nvim_create_user_command("Packdel", function(opts)
	vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Remove vim.pack plugins from disk" })

-- Per-plugin configuration. Order matters where there are dependencies
-- (e.g. noice must be set up before lualine reads from it).
require("plugins.treesitter")
require("plugins.completion")
require("plugins.conform")
require("plugins.git")
require("plugins.grapple")
require("plugins.image")
require("plugins.noice")
require("plugins.lualine")
require("plugins.multiplex-nav")
require("plugins.simple-plugins")
require("plugins.telescope")
