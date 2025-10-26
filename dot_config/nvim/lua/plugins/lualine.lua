return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	priority = 999,
	config = function()
		local git_blame = require("gitblame")
		-- This disables showing of the blame text next to the cursor
		vim.g.gitblame_display_virtual_text = 0

		require("lualine").setup({
			options = {
				disabled_filetypes = { "neo-tree", "oil", "alpha" },
				component_separators = "|",
				section_separators = "",
				theme = "rose-pine",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "diff", "diagnostics", { "filename", file_status = false, path = 1 } },
				lualine_c = {
					{ git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
				},

				lualine_x = { { "filetype", icon_only = true, icon = { align = "left" } } },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = { "mode" },
				lualine_b = { "diff", "diagnostics", { "filename", file_status = false, path = 1 } },
				lualine_c = {},
				lualine_x = { { "filetype", icon_only = true, icon = { align = "left" } } },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
