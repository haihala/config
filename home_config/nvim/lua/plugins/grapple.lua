return {
    {
        "cbochs/grapple.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            scope = "git", -- also try out "git_branch"
        },
        event = { "BufReadPost", "BufNewFile" },
        cmd = "Grapple",
        keys = {
            { "<leader>m", "<cmd>Grapple toggle<cr>",      desc = "Grapple toggle tag" },
            { "<leader>M", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
            unpack((function()
                local nums = {}
                for i = 1, 9 do
                    table.insert(nums, { "<A-" .. i .. ">", "<cmd>Grapple select index=" .. i .. "<cr>" })
                end
                return nums
            end)()),
        },
    },
}
