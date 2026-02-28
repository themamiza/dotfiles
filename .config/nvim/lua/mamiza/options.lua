-- Alias:
set = vim.opt

-- Leader key:
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Enable mouse in all modes:
set.mouse = "a"

-- Don't highlight all search matches:
set.hlsearch = false

-- Tab size:
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
-- Don't insert actual tabs:
set.expandtab = true

-- Minimum of line to always above or below the cursor:
set.scrolloff = 8

-- Use relative line numbering:
set.relativenumber = true
-- Show the current line number instead of zero:
set.number = true

-- Use system clipboard
set.clipboard = "unnamedplus"

-- Minimal backups
set.backup = false
set.swapfile = false
set.undofile = true

-- Case insensetive charachter matching:
set.ignorecase = true
set.smartcase = true

-- Fast update times:
set.updatetime = 50

-- Display signs in the number column (useful for some plugins)
set.signcolumn = "number"

-- Time to wait for a mapped sequence to complete:
set.timeoutlen = 300

-- How to complete:
set.completeopt = "menuone,noselect"

-- Don't show intro message:
set.shortmess = "atI"

vim.cmd [[
        augroup RestoreCursor
        autocmd!
        autocmd BufRead * autocmd FileType <buffer> ++once
        \ let s:line = line("'\"")
        \ | if s:line >= 1 && s:line <= line("$") && &filetype !~# 'commit'
        \      && index(['xxd', 'gitrebase'], &filetype) == -1
        \ |   execute "normal! g`\""
        \ | endif
        augroup END
]]

-- Function to check if a floating dialog exists and if not then check for diagnostics under the cursor
function OpenDiagnosticIfNoFloat()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.api.nvim_win_get_config(winid).zindex then
                        return
                end
        end
        -- THIS IS FOR BUILTIN LSP
        vim.diagnostic.open_float(0, {
                scope = "cursor",
                focusable = false,
                close_events = {
                        "CursorMoved",
                        "CursorMovedI",
                        "BufHidden",
                        "InsertCharPre",
                        "WinLeave",
                },
        })
end

-- Show diagnostics under the cursor when holding position
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
        pattern = "*",
        command = "lua OpenDiagnosticIfNoFloat()",
        group = "lsp_diagnostics_hold",
})

vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
                local target_dir = "/home/mamiza/rp/dotfiles"
                local filepath = vim.fn.expand("%:p")

                if vim.startswith(filepath, target_dir) then
                        vim.fn.jobstart({ "mais", "install-dotfiles" }, { detach = true })
                end
        end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "hyprland.conf",
        callback = function()
                vim.fn.jobstart({ "hyprctl", "reload" }, { detach = true })
        end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*/waybar/*",
        callback = function()
                vim.fn.jobstart({ "pkill", "-SIGUSR2", "waybar" }, { detach = true })
        end,
})
