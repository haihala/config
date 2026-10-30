-- Line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Cursor visualization
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- Indents
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true -- Make spaces instead of tabs when pressing tab
vim.opt.smarttab = true -- Always put tabs at the start of the line

vim.opt.autoindent = true
vim.opt.smartindent = true

-- Swap files
vim.opt.swapfile = false
vim.opt.backup = false

-- Search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true -- Searching with upper case character is case sensitive

-- Text wrapping
vim.opt.showbreak = "> "
vim.opt.breakindent = true
vim.opt.breakindentopt = { "shift:2" }

-- Automatically reload and save files upon navigation
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.autowriteall = true

-- Spell checks
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Neovide
if vim.g.neovide then
	vim.o.guifont = "Source Code Pro:h10"
end

-- Misc
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- Folding: treesitter produces many more fold candidates than indent-based
-- folding. Start with everything unfolded so files open expanded.
vim.opt.foldlevelstart = 99
vim.opt.foldlevel = 99

-- Filetype detection for filetypes that language servers advertise but Nvim
-- has no built-in rule for. Without these, :checkhealth vim.lsp warns about
-- "Unknown filetype" and the server never attaches to those files.
vim.filetype.add({
	extension = {
		-- marksman
		mdx = "markdown.mdx",
		-- gopls. Plain .tmpl is handled below, since it is not Go-specific.
		gotmpl = "gotmpl",
		gohtml = "gotmpl",
		tpl = "gotmpl",
	},
	filename = {
		-- yamlls uses these dotted filetypes to pick a JSON schema
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
		[".gitlab-ci.yml"] = "yaml.gitlab",
		[".gitlab-ci.yaml"] = "yaml.gitlab",
	},
	pattern = {
		["docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",
		["compose%..*%.ya?ml"] = "yaml.docker-compose",
		[".*%.gitlab%-ci%.ya?ml"] = "yaml.gitlab",
		-- A values.yaml under charts/ is unambiguously Helm. This also has to
		-- be a literal string, not a function: vim.filetype._get_known_filetypes
		-- (which :checkhealth vim.lsp uses) skips function-valued entries, so a
		-- filetype that only ever appears inside a function stays "unknown".
		[".*/charts/.*/values%.ya?ml"] = "yaml.helm-values",
		-- Only treat a bare values.yaml as Helm values when it sits in a chart
		["values%.ya?ml"] = function(path)
			local dir = vim.fs.dirname(path)
			if vim.fn.filereadable(dir .. "/Chart.yaml") == 1 then
				return "yaml.helm-values"
			end
			return "yaml"
		end,
		-- Go templates: .tmpl is used by plenty of non-Go tools, so only claim
		-- it for gopls inside a Go module.
		[".*%.tmpl"] = function(path)
			if vim.fs.find("go.mod", { path = vim.fs.dirname(path), upward = true })[1] then
				return "gotmpl"
			end
			return "template"
		end,
	},
})
