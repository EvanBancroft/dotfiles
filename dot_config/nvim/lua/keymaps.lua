vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader>bv", "<cmd>:vsplit<cr>")
vim.keymap.set("n", "<leader>bh", "<cmd>:split<cr>")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux display-popup -E tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "ss", ":write<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>px", ":PxToRemCursor<CR>", { noremap = true })
vim.keymap.set("n", "<leader>pxl", ":PxToRemLine<CR>", { noremap = true })

--------------
-- obsidian --
--------------
--
-- >>> oo # from shell, navigate to vault (optional)
-- navigate to vault
vim.keymap.set(
	"n",
	"<leader>oo",
	":cd /Users/evanbancroft/Library/Mobile Documents/iCloud~md~obsidian/Documents/v2.0.1<cr>"
)

-- convert note to template and remove leading white space
vim.keymap.set("n", "<leader>ot", ":ObsidianTemplate<cr>")

-- search for files in full vault
vim.keymap.set(
	"n",
	"<leader>of",
	':Telescope find_files search_dirs={"/Users/evanbancroft/Library/Mobile Documents/iCloud~md~obsidian/Documents/v2.0.1"}<cr>'
)
vim.keymap.set(
	"n",
	"<leader>oz",
	':Telescope live_grep search_dirs={"/Users/evanbancroft/Library/Mobile Documents/iCloud~md~obsidian/Documents/v2.0.1"}<cr>'
)
