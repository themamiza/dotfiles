-- Highlight yanked lines:
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
        callback = function()
                vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = "*",
})

vim.opt.colorcolumn = "128,129"
vim.cmd [[ highlight ColorColumn guibg=lightgray ]] 
