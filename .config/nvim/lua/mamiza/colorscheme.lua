local function transparent_hl()
        local groups = {
                -- base windows
                "Normal",
                "NormalNC",
                "NormalFloat",
                "FloatBorder",
                "FloatTitle",
                "NonText",
                "SignColumn",
                "EndOfBuffer",

                -- completion / popup menu
                "Pmenu",
                "PmenuSel",
                "PmenuSbar",
                "PmenuThumb",

                -- telescope
                "TelescopeNormal",
                "TelescopeBorder",
                "TelescopePromptNormal",
                "TelescopePromptBorder",
                "TelescopeResultsNormal",
                "TelescopeResultsBorder",
                "TelescopePreviewNormal",
                "TelescopePreviewBorder",

                -- lazy.nvim / plugin windows
                "LazyNormal",

                -- lsp info / diagnostic floats
                "LspInfoBorder",
                "DiagnosticFloatingError",
                "DiagnosticFloatingWarn",
                "DiagnosticFloatingInfo",
                "DiagnosticFloatingHint",
        }

        for _, group in ipairs(groups) do
                vim.api.nvim_set_hl(0, group, { bg = "none" })
        end

        vim.api.nvim_set_hl(0, "ColorColumn", { bg = "lightgray" })
end

require("tokyonight").setup({
        transparent = true,
        styles = {
                sidebars = "transparent",
                floats = "transparent",
        },
        on_highlights = function(hl, _)
                hl.Normal = { bg = "none" }
                hl.NormalNC = { bg = "none" }
                hl.NormalFloat = { bg = "none" }
                hl.FloatBorder = { bg = "none" }
                hl.FloatTitle = { bg = "none" }
                hl.Pmenu = { bg = "none" }
                hl.TelescopeNormal = { bg = "none" }
                hl.TelescopeBorder = { bg = "none" }
                hl.LazyNormal = { bg = "none" }
        end,
})

vim.cmd [[ colorscheme tokyonight ]]

transparent_hl()

vim.api.nvim_create_autocmd({
        "ColorScheme",
        "WinEnter",
        "BufWinEnter",
        "WinNew",
}, {
        callback = transparent_hl,
})
