local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>.", builtin.find_files, {})
require("telescope").setup {
        defaults = {
                mappings = {
                        i = {
                                ["<C-u>"] = false,
                                ["<C-d>"] = false,
                        }
                }
        }
}
