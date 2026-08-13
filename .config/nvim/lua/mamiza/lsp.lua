----- LSP Server Setups -----
-- LSP Defaults.
-- These settings are merged into every named LSP configuration.
vim.lsp.config("*", {
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Servers
vim.lsp.config("lua_ls", {
  on_init = function(client)
    client.config.settings.Lua = vim.tbl_deep_extend(
      "force",
      client.config.settings.Lua,
      {
        runtime = {
          version = "LuaJIT",
          path = { "lua/?.lua", "lua/?/init.lua" },
        },
        workspace = {
          checkThirdParty = false,
          library = { "/usr/share/hypr/stubs" },
        },
      }
    )
  end,
  settings = { Lua = {} },
})

vim.lsp.config("bashls", {
  root_markers = { ".git", ".bashls-root" },
  settings = {
    bashIde = {
      includeAllWorkspaceSymbols = true,
      backgroundAnalysisMaxFiles = 2000,
      globPattern = "**/{*.sh,*.bash,*.inc,*.command,functions,variables,aliases}",
    },
  },
})

vim.lsp.config("qmlls", {
  cmd = { "qmlls6" },
})

vim.lsp.enable({
  "lua_ls",
  "bashls",
  "clangd",
  "pylsp",
  "qmlls",
})

----- LSP Extra Options -----
-- References with live preview
local function references_live_preview()
  local source_win = vim.api.nvim_get_current_win()
  local source_buf = vim.api.nvim_get_current_buf()
  local source_cursor = vim.api.nvim_win_get_cursor(source_win)

  vim.lsp.buf.references(nil, {
    on_list = function(list)
      vim.fn.setqflist({}, " ", list)
      vim.cmd("botright copen")

      local qf_buf = vim.api.nvim_get_current_buf()

      local function preview()
        if not vim.api.nvim_win_is_valid(source_win) then
          return
        end

        local item = vim.fn.getqflist()[vim.fn.line(".")]

        if not item or item.valid == 0 or item.bufnr == 0 then
          return
        end

        vim.fn.bufload(item.bufnr)

        if vim.bo[item.bufnr].filetype == "" then
          vim.api.nvim_buf_call(item.bufnr, function()
                                  vim.cmd("filetype detect")
          end)
        end

        vim.api.nvim_win_set_buf(source_win, item.bufnr)

        pcall(vim.api.nvim_win_set_cursor, source_win, {
          math.max(item.lnum, 1),
          math.max(item.col - 1, 0),
        })

        vim.api.nvim_win_call(source_win, function()
          vim.cmd("normal! zz")
        end)
      end

      local function close()
        vim.cmd.cclose()

        if vim.api.nvim_win_is_valid(source_win) then
          vim.api.nvim_set_current_win(source_win)
        end
      end

      local function cancel()
        if vim.api.nvim_win_is_valid(source_win)
          and vim.api.nvim_buf_is_valid(source_buf)
        then
          vim.api.nvim_win_set_buf(source_win, source_buf)
          pcall(
            vim.api.nvim_win_set_cursor,
            source_win,
            source_cursor
          )
        end

        close()
      end

      vim.api.nvim_create_autocmd("CursorMoved", {
        group = vim.api.nvim_create_augroup(
          "LspReferencesLivePreview",
          { clear = true }
        ),
        buffer = qf_buf,
        callback = preview,
      })

      -- Go to the preview
      vim.keymap.set("n", "<CR>", function()
        preview()
        close()
      end, {
        buffer = qf_buf,
        silent = true,
        desc = "Accept reference",
      })

      -- Quit the live preview mode
      vim.keymap.set("n", "q", cancel, {
        buffer = qf_buf,
        silent = true,
        desc = "Cancel references",
      })

      preview()
    end,
  })
end

----- LSP Keybindings -----
local lsp_group = vim.api.nvim_create_augroup(
  "user_lsp_keymaps",
  { clear = true }
)

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,

  callback = function(event)
    local bufnr = event.buf

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = bufnr,
        silent = true,
        desc = "LSP: " .. desc,
      })
    end

    -- Navigation
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gR", references_live_preview, "References")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")

    -- Information
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
    map("n", "<leader>ls", vim.lsp.buf.document_symbol, "Document symbols")
    map("n", "<leader>lS", vim.lsp.buf.workspace_symbol, "Workspace symbols")

    -- Refactoring
    map("n", "<leader>lr", vim.lsp.buf.rename, "Rename symbol")
    map({ "n", "x" }, "<leader>la", vim.lsp.buf.code_action, "Code action")

    map({ "n", "x" }, "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format")

    -- Diagnostics
    map("n", "<leader>ld", function()
      vim.diagnostic.open_float({
        scope = "cursor",
        focus = false,
      })
    end, "Show diagnostic")

    map("n", "[d", function()
      vim.diagnostic.jump({
        count = -1,
        float = true,
      })
    end, "Previous diagnostic")

    map("n", "]d", function()
      vim.diagnostic.jump({
        count = 1,
        float = true,
      })
    end, "Next diagnostic")

    map("n", "<leader>lq", function()
      vim.diagnostic.setloclist({ open = true })
    end, "Buffer diagnostics")

    map("n", "<leader>lQ", function()
      vim.diagnostic.setqflist({ open = true })
    end, "Workspace diagnostics")

    -- Workspace
    map(
      "n",
      "<leader>lwa",
      vim.lsp.buf.add_workspace_folder,
      "Add workspace folder"
    )

    map(
      "n",
      "<leader>lwr",
      vim.lsp.buf.remove_workspace_folder,
      "Remove workspace folder"
    )

    map("n", "<leader>lwl", function()
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, "List workspace folders")

    -- Inlay hints
    map("n", "<leader>lh", function()
      local filter = { bufnr = bufnr }

      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled(filter),
        filter
      )
    end, "Toggle inlay hints")
  end,
})
