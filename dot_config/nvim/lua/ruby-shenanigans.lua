-- Ensure files end with a newline
vim.opt.endofline = true
vim.opt.fixendofline = true

-- Ruby-specific settings (optional)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "ruby",
	callback = function()
		vim.opt_local.endofline = true
		vim.opt_local.fixendofline = true
	end,
})
