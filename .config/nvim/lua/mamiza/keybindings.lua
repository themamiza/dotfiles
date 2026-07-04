local silent = { silent = true }
local comment_opts = { remap = true, silent = true, desc = "Toggle comment" }

-- NetRW
vim.keymap.set("n", "<leader>o-", vim.cmd.Ex)

-- Better word deletion
vim.keymap.set({ "i", "c" }, "<C-h>", "<C-w>", {})

-- Moving lines around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Emacs
vim.keymap.set("n", "<M-x>", ":")

-- Buffer control
vim.keymap.set("n", "<leader>bp", ":bprev<CR>", silent)
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", silent)
vim.keymap.set("n", "<leader>bk", ":q!<CR>", silent)

vim.keymap.set("n", "<leader>.", ":Telescope find_files<CR>", silent)
vim.keymap.set("n", "<leader>f", ":Telescope git_files<CR>", silent)
vim.keymap.set("n", "<leader>:", ":Telescope commands<CR>", silent)
vim.keymap.set("n", "<leader>bb", ":Telescope buffers<CR>", silent)

-- Compile
vim.keymap.set("n", "<leader>cc", ":!<up>")

-- Neogit
vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", silent)

-- Comment
vim.keymap.set("n", "<leader>;", "gcc", comment_opts)
vim.keymap.set("x", "<leader>;", "gc", comment_opts)
vim.keymap.set("i", "<leader>;", "<Esc>gccgi", comment_opts)
