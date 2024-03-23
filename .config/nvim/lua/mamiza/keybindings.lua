-- NetRW
vim.keymap.set("n", "<leader>o-", vim.cmd.Ex)

-- Better word deletion:
vim.keymap.set({ "i", "c" }, "<C-h>", "<C-w>", {})

-- Moving lines around:
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Emacs:
vim.keymap.set("n", "<M-x>", ":")

-- Buffer control:
vim.keymap.set("n", "<leader>bp", ":bprev<CR>", { silent = true })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>bk", ":q!<CR>", { silent = true })
vim.keymap.set("n", "<leader>:", ":Telescope commands<CR>", { silent = true })
vim.keymap.set("n", "<leader>bb", ":Telescope buffers<CR>", { silent = true })

-- Compile:
vim.keymap.set("n", "<leader>cc", ":!")

-- Neogit
vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { silent = true })
