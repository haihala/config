return {
	"stevearc/conform.nvim",
	opts = {
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
			markdown = { "biome-check", "prettierd", "prettier", "eslint_d" },
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
		format_on_save = {
			-- I recommend these options. See :help conform.format for details.
			lsp_format = "fallback",
			timeout_ms = 500,
		},
		stop_after_first = true,
	},
}
