return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		priority = 1000,
		config = {
			dim_inactive_windows = false,
			styles = {
				transparency = true,
			},
		},
	},
	{
		"ficcdaf/ashen.nvim",
		lazy = true,
		-- configuration is optional!
		opts = {
			-- your settings here
		},
	},
	{
		"rebelot/kanagawa.nvim",
		lazy = true,
		-- configuration is optional!
		config = {
			theme = "dragon",
		},
	},
}
