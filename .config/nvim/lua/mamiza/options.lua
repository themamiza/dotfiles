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
