local function move_cursor_to_match(name)
	-- Open the styles file
	local styles_file = vim.fn.expand("%:p:h") .. "/{styles.*,*.module.css}"

	local files = vim.fn.glob(styles_file, true, true)

	for _, file in ipairs(files) do
		-- Open each matching file in a new buffer
		vim.cmd("e " .. file)

		-- Perform the search using Vim's command-line mode
		local search_cmd = "silent! /\\<" .. name .. "\\>"
		vim.cmd(search_cmd)

		vim.cmd("norm! zz")
	end
end

function Open_styles_file()
	-- Get the name under the cursor
	local name = vim.fn.expand("<cword>")

	-- Move cursor to the match in the styles file
	move_cursor_to_match(name)
end

-- Bind the function to a keymap
vim.api.nvim_set_keymap("n", "<leader>os", "<cmd>lua Open_styles_file()<CR>", { noremap = true, silent = true })
