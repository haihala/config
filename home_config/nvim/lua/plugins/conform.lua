-- Prefer biome everywhere it can format, but never override a repo that has
-- opted into prettier. conform's biome formatter adapts --indent-style and
-- --indent-width to the buffer when no biome.json exists, so it follows the
-- editor rather than imposing biome's tab default.
local prettier_configs = {
	".prettierrc",
	".prettierrc.json",
	".prettierrc.json5",
	".prettierrc.yml",
	".prettierrc.yaml",
	".prettierrc.js",
	".prettierrc.cjs",
	".prettierrc.mjs",
	".prettierrc.ts",
	".prettierrc.toml",
	"prettier.config.js",
	"prettier.config.cjs",
	"prettier.config.mjs",
	"prettier.config.ts",
}

local function biome_allowed(_, ctx)
	if vim.fs.find(prettier_configs, { path = ctx.dirname, upward = true })[1] then
		return false
	end
	-- prettier also reads a "prettier" key out of package.json
	local pkg = vim.fs.find("package.json", { path = ctx.dirname, upward = true })[1]
	if pkg then
		local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), "\n"))
		if ok and type(data) == "table" and data.prettier ~= nil then
			return false
		end
	end
	return true
end

-- Stylesheets: biome when allowed, prettier otherwise.
local styles = { "biome", "prettierd", "prettier" }

-- Prettier owns these outright. Biome has no markdown, yaml or vue support,
-- and its html support is still experimental.
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
		-- Neovim calls any {% %} template htmldjango, whatever the engine. Tera
		-- is a Jinja dialect, so djlint's jinja profile is the right fit; see
		-- the djlint formatter options below.
		htmldjango = { "djlint" },
		jinja = { "djlint" },
		css = styles,
		scss = styles,
		vue = prettier_only,
		-- conform matches compound filetypes component by component, so this
		-- also covers yaml.docker-compose and yaml.gitlab from settings.lua
		yaml = prettier_only,
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
		biome = { condition = biome_allowed },
		["biome-check"] = { condition = biome_allowed },
		prettier = {
			options = {
				-- .t is loco's mailer template extension
				ext_parsers = { t = "html" },
			},
		},
		djlint = {
			-- djlint has a real tera profile, so use it rather than jinja.
			-- Indent 2 to match prettier, since djlint defaults to 4. It also
			-- strips every blank line by default (--max-blank-lines 0), so
			-- allow one, which is what prettier does: keep single spacers,
			-- collapse longer runs. --max-line-length decides when djlint
			-- joins tags back onto one line; its 120 default would undo the
			-- wrapping done at textwidth=80 on every save.
			prepend_args = {
				"--profile",
				"tera",
				"--indent",
				"2",
				"--max-blank-lines",
				"1",
				"--max-line-length",
				"80",
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
