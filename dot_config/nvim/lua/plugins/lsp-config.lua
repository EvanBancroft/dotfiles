return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		config = true,
		version = "1.11.0",
	},
	{ "mason-org/mason-lspconfig.nvim", version = "1.32.0" },
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "mason-org/mason.nvim", config = true },
			"saghen/blink.cmp",

			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			{
				"j-hui/fidget.nvim",
				opts = {
					notification = {
						window = {
							winblend = 0,
						},
					},
				},
			},

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function(_, opts)
			-- local lspconfig = vim.lsp.config()
			-- lspconfig.handlers = {
			-- 	["tsserver"] = function() end, -- handled by typescript_tools.lua
			-- }

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("<leader>gd", function()
						vim.lsp.buf.definition()
					end, "[G]oto Definition")

					map("<leader>vws", function()
						vim.lsp.buf.workspace_symbol()
					end, "[V]iew [W]orkspace [S]ymbol")
					map("<leader>vd", function()
						vim.diagnostic.open_float()
					end, "[V]iew [D]iagnostic")

					map(
						"<leader>ca",
						"<cmd>FzfLua lsp_code_actions previewer=false winopts.row=0.25 winopts.width=0.7 winopts.height=0.42<cr>",
						"[C]ode [A]ction",
						{ "n", "x" }
					)

					vim.keymap.set("n", "<leader>vrr", function()
						vim.lsp.buf.references()
					end)
					vim.keymap.set("n", "<leader>vrn", function()
						vim.lsp.buf.rename()
					end)
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				gopls = {},
				ts_ls = {},
				ruby_lsp = {},
				cssls = {
					settings = {
						css = {
							lint = {
								unknownAtRules = "ignore",
							},
						},
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			for server, config in pairs(servers) do
				-- passing config.capabilities to blink.cmp merges with the capabilities in your
				-- `opts[server].capabilities, if you've defined it
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end

			require("mason").setup()

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"prettier",
				"prettierd",
				"rustywind",
				"shfmt",
				"bash-language-server",
				"astro-language-server",
				"eslint_d",
				"rubocop",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			---@diagnostic disable-next-line: missing-fields
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						vim.lsp.config(server_name, server)
						vim.lsp.enable(server_name)
					end,
				},
			})
		end,
	},
}
