-- Resolve image paths the way an Obsidian style vault writes them: relative to
-- the vault (repo) root rather than to the document.
--
-- The previous version shelled out to dirname/git for every candidate and had
-- two bugs: `git rev-parse` output kept its trailing newline so the root was
-- never recognised, and the root check ran *before* the directory was searched,
-- so the root itself was skipped.

local function file_exists(path)
	return vim.fn.filereadable(path) == 1
end

local function repo_root(dir)
	local git = vim.fs.find(".git", { path = dir, upward = true })[1]
	if not git then
		return nil
	end
	return vim.fs.dirname(git)
end

-- Walk up from the document, checking <dir>/<img>, <dir>/assets/<img> and
-- <dir>/images/<img> at each level. The repo root is included in the search
-- and terminates it.
local function find_image(start_dir, img_path)
	local root = repo_root(start_dir)
	local dir = start_dir

	while dir and dir ~= "" do
		for _, candidate in ipairs({
			dir .. "/" .. img_path,
			dir .. "/assets/" .. img_path,
			dir .. "/images/" .. img_path,
		}) do
			if file_exists(candidate) then
				return candidate
			end
		end

		if dir == "/" or dir == root then
			return nil
		end

		local parent = vim.fs.dirname(dir)
		if parent == dir then
			return nil
		end
		dir = parent
	end

	return nil
end

-- magick_cli processor shells out to the ImageMagick CLI (`magick`, `identify`,
-- `convert`), which is pulled in transitively by `ImageMagick-devel` in
-- dnf_install.sh. No luarock needed.
require("image").setup({
	backend = "kitty",
	processor = "magick_cli",
	integrations = {
		markdown = {
			enabled = true,
			clear_in_insert_mode = false,
			download_remote_images = true,
			only_render_image_at_cursor = true,
			-- Defaults to "popup", which renders in a float and skips the
			-- inline render entirely
			only_render_image_at_cursor_mode = "inline",
			filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
			resolve_image_path = function(document_path, image_path, fallback)
				-- Absolute, home relative and remote paths are the fallback's job
				if image_path:match("^[~/]") or image_path:match("^%a[%w+.-]*://") then
					return fallback(document_path, image_path)
				end

				local found = find_image(vim.fs.dirname(document_path), image_path)
				return found or fallback(document_path, image_path)
			end,
		},
		neorg = {
			enabled = true,
			clear_in_insert_mode = false,
			download_remote_images = true,
			only_render_image_at_cursor = false,
			filetypes = { "norg" },
		},
	},
	max_width = nil,
	max_height = nil,
	max_width_window_percentage = nil,
	max_height_window_percentage = 50,
	kitty_method = "normal",
	-- Clear images when the tmux window or session changes, otherwise they stay
	-- painted over whatever is now on screen. Relies on FocusLost firing, which
	-- needs visual-activity off in tmux.conf (it is).
	tmux_show_only_in_active_window = true,
})
