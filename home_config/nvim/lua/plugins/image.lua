local function shell_output(cmd)
	local handle = io.popen(cmd)
	if handle == nil then
		return nil
	end
	local content = handle:read("a")
	handle:close()
	return content
end

local function all_trim(s)
	return s:match("^%s*(.-)%s*$")
end

local function parent_dir(path)
	return all_trim(shell_output("dirname " .. '"' .. path .. '"'))
end

local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

local function crawl_to_git_root(current_dir, img_path)
	if current_dir == "/" then
		return nil
	end

	local git_root = shell_output("git rev-parse --show-toplevel")

	if current_dir == git_root then
		return nil
	end

	local options = { "assets", "images" }
	for _, option in ipairs(options) do
		local opt_path = current_dir .. "/" .. option .. "/" .. img_path
		local exists = file_exists(opt_path)
		if exists then
			return opt_path
		end
	end

	return crawl_to_git_root(parent_dir(current_dir), img_path)
end

return {
	{
		"3rd/image.nvim",
		event = "VeryLazy",
		build = false,
		opts = {
			backend = "kitty",
			processor = "magick_cli",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = true,
					filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
					resolve_image_path = function(document_path, image_path, fallback)
						local document_dir = parent_dir(document_path)
						local result = crawl_to_git_root(document_dir, image_path)

						if result then
							return result
						else
							-- Default behavior
							return fallback(document_path, image_path)
						end
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
		},
	},
}
