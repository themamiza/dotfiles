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
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
          vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
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
vim.lsp.enable("bashls")
vim.lsp.enable("clangd")
vim.lsp.enable("pylsp")

vim.lsp.config("qmlls", {
  cmd = { "qmlls6" } -- Correct binary name
})
vim.lsp.enable("qmlls")
