local treesitter = require("nvim-treesitter")

treesitter.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
})

local parsers = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "css",
        "csv",
        "gitcommit",
        "gitignore",
        "go",
        "html",
        "javascript",
        "rust",
        "typescript",
        "python",
        "markdown",
        "markdown_inline",
        "query",
}

treesitter.install(parsers)

vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("start_treesitter", { clear = true }),
        callback = function(args)
                pcall(vim.treesitter.start, args.buf)
        end,
})
