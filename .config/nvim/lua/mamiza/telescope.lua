local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup({
	defaults = {
		-- `hidden = true` is not supported in text grep commands.
		vimgrep_arguments = vimgrep_arguments,
        mappings = {
                i = {
                        ["<C-u>"] = false,
                        ["<C-d>"] = false,
                }
        }
	},
	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
})
