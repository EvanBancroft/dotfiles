return {

	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "FzfLua",
		keys = {
			{ "<leader>f<", "<cmd>FzfLua resume<cr>", desc = "Resume last command" },
			{
				"<leader>fb",
				function()
					require("fzf-lua").lgrep_curbuf({
						winopts = {
							height = 0.6,
							width = 0.5,
							preview = { vertical = "up:70%" },
						},
					})
				end,
				desc = "Grep current buffer",
			},
			{ "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
			{ "<leader>fg", "<cmd>FzfLua grep_visual<cr>", desc = "Grep", mode = "x" },
			{ "<leader>fc", "<cmd>FzfLua highlights<cr>", desc = "Highlights" },
			{ "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>", desc = "Document diagnostics" },
			{ "<leader>fD", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help" },
			{
				"<leader>fr",
				function()
					-- Read from ShaDa to include files that were already deleted from the buffer list.
					vim.cmd("rshada!")
					require("fzf-lua").oldfiles()
				end,
				desc = "Recently opened files",
			},
			{ "z=", "<cmd>FzfLua spell_suggest<cr>", desc = "Spelling suggestions" },
		},
		opts = function()
			return {
				winopts = {
					height = 0.7,
					width = 0.55,
					preview = {
						scrollbar = false,
						vertical = "up:40%",
					},
				},
				previewers = {
					codeaction = { toggle_behavior = "extend", previewer = false },
				},
				lsp = {
					code_actions = {
						winopts = {
							width = 70,
							height = 20,
							relative = "cursor",
							preview = {
								hidden = true,
								vertical = "down:50%",
							},
						},
					},
				},
			}
		end,
	},
}
