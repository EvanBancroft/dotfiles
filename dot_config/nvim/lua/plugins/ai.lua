return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			adapters = {
				openai = function()
					return require("codecompanion.adapters").extend("openai", {
						schema = {
							model = {
								default = "claude-sonnet-4-20250514",
							},
						},
					})
				end,
			},
			strategies = {
				chat = {
					adapter = "anthropic",
				},
				inline = {
					adapter = "anthropic",
				},
			},
			display = {
				chat = {
					window = {
						position = "right",
					},
				},
			},
		},
		keys = {
			{
				"<leader>cm",
				"<cmd>CodeCompanionActions<cr>",
				desc = "Open [C]ode Companion [M]enu",
				mode = { "v", "n" },
			},
			{
				"<leader>cc",
				"<cmd>CodeCompanionChat Toggle<cr>",
				desc = "Open [C]ode Companion [C]hat",
				mode = { "v", "n" },
			},
		},
	},
}
