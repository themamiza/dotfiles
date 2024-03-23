require"nvim-treesitter.configs".setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "bash", "comment", "css", "csv", "gitcommit", "gitignore", "go", "html", "javascript", "rust", "typescript", "python" },
        highlight = {
                enable = true,
        }
}
