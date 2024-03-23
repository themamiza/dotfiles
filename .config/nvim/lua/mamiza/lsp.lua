local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({bufnr = bufnr})
end)

lsp_zero.setup_servers({ "lua_ls", "clangd", "pylsp", "bashls" })
