-- Bootstrap Lazy:
local lazypath = vim.fn.stdpath("data") .. "lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable",
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins:
require("lazy").setup({
        {
                "neovim/nvim-lspconfig",
                dependencies = {
                        { "j-hui/fidget.nvim", opts = {} },
                        "folke/neodev.nvim",
                }
        },
        {
                "hrsh7th/nvim-cmp",
                dependencies = {
                        "L3MON4D3/LuaSnip",
                        "saadparwaiz1/cmp_luasnip",

                        "hrsh7th/cmp-nvim-lsp",
                        "hrsh7th/cmp-buffer",
                        "hrsh7th/cmp-path",

                        "rafamadriz/friendly-snippets",
                }
        },
        "tpope/vim-sleuth",
        {
                "nvim-lualine/lualine.nvim",
                opts = {
                        options = {
                                theme = "tokyonight",
                        }
                }
        },
        {
                "nvim-telescope/telescope.nvim", tag = "0.1.3",
                dependencies = { "nvim-lua/plenary.nvim" }
        },
        {
                "folke/tokyonight.nvim",
                lazy = false,
                priority = 1000,
                opts = {},
        },
        {
                "nvim-treesitter/nvim-treesitter",
                build = ":TSUpdate"

        },
        { "VonHeikemen/lsp-zero.nvim", branch = "v3.x" },
        { "airblade/vim-gitgutter" },
        {
                "NeogitOrg/neogit",
                dependencies = {
                        "nvim-lua/plenary.nvim",
                },
                config = true
        },
})
