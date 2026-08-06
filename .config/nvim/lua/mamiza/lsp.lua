----- LSP Server Setups -----
-- lua_ls setup
vim.lsp.config("lua_ls", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),

  on_init = function(client)
    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          "/usr/share/hypr/stubs",
        },
      },
    })
  end,

  -- Empty out the default settings
  settings = { Lua = {}, }
})
vim.lsp.enable("lua_ls")

-- simple lsp setups
vim.lsp.config("bashls", {
  cmd = {
    "env",
    "BASH_IDE_LOG_LEVEL=debug",
    "bash-language-server",
    "start",
  },

  filetypes = { "sh", "bash" },

  root_markers = { ".git", ".bashls-root" },

  settings = {
    bashIde = {
      includeAllWorkspaceSymbols = true,
      backgroundAnalysisMaxFiles = 2000,
      logLevel = "debug",

      -- Add the actual names/extensions used by your shell libraries.
      globPattern = "**/{*.sh,*.bash,*.inc,*.command,functions,variables,aliases}",
    },
  },
})
vim.lsp.enable("bashls")

vim.lsp.config("clangd", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
vim.lsp.enable("clangd")

vim.lsp.config("pylsp", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
vim.lsp.enable("pylsp")

vim.lsp.config("qmlls", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  cmd = { "qmlls6" } -- Correct binary name
})
vim.lsp.enable("qmlls")
