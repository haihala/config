-- Biome has no markdown support and only experimental html support, so don't
-- let it shadow prettier in those filetypes
local prettier_only = { "prettierd", "prettier" }

-- Loco mailer templates are named html.t. Prettier picks its parser from the
-- file extension and has no idea what .t is, so it bails with
-- UndefinedParserError. prettierd accepts no CLI flags at all, so it can't be
-- told either -- these files have to go to plain prettier, which conform can
-- hand an explicit parser via the ext_parsers option below.
local function html_formatters(bufnr)
	if vim.api.nvim_buf_get_name(bufnr):match("%.t$") then
		return { "prettier" }
	end
	return prettier_only
end

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		go = { "goimports", "gofmt" },
		-- You can also customize some of the format options for the filetype
		rust = { "rustfmt", lsp_format = "fallback" },
		-- You can use a function here to determine the formatters dynamically
		python = function(bufnr)
			if require("conform").get_formatter_info("ruff_format", bufnr).available then
				return { "ruff_format" }
			else
				return { "isort", "black", "autopep8" }
			end
		end,
		markdown = prettier_only,
		html = html_formatters,
		typescript = { "biome-check", "prettierd", "prettier", "eslint_d" },
		javascript = { "biome-check", "prettierd", "prettier", "eslint_d" },
		typescriptreact = { "biome-check", "prettierd", "prettier", "eslint_d" },
		javascriptreact = { "biome-check", "prettierd", "prettier", "eslint_d" },
		json = { "biome-check", "prettierd", "prettier", "eslint_d" },
		svelte = { "prettierd", "prettier", "eslint_d" }, -- As of writing, biome is experimental in sveltekit

		-- Use the "*" filetype to run formatters on all filetypes.
		-- ["*"] = { "codespell" },

		-- Use the "_" filetype to run formatters on filetypes that don't
		-- have other formatters configured.
		["_"] = { "trim_whitespace" }, -- trim_whitespace is built-in to conform.nvim
	},
	formatters = {
		prettier = {
			options = {
				-- .t is loco's mailer template extension
				ext_parsers = { t = "html" },
			},
		},
	},
	format_on_save = {
		-- I recommend these options. See :help conform.format for details.
		lsp_format = "fallback",
		timeout_ms = 500,
		stop_after_first = true,
	},
	stop_after_first = true,
})
