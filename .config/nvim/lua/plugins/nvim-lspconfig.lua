-- lua/plugins/nvim-lspconfig.lua
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- 共用 on_attach：這裡把所有 LSP 相關按鍵 + desc 放好
    local function on_attach(client, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          silent = true,
          noremap = true,
          desc = desc,
        })
      end

      -- 基本跳轉 / 說明
      map("n", "gd", vim.lsp.buf.definition, "LSP: definition")
      map("n", "gD", vim.lsp.buf.declaration, "LSP: declaration")
      map("n", "gi", vim.lsp.buf.implementation, "LSP: implementation")
      map("n", "gr", vim.lsp.buf.references, "LSP: references")
      map("n", "K", vim.lsp.buf.hover, "LSP: hover")
      map("n", "<C-k>", vim.lsp.buf.signature_help, "LSP: signature help")

      -- 診斷
      map("n", "[d", vim.diagnostic.goto_prev, "LSP: prev diagnostic")
      map("n", "]d", vim.diagnostic.goto_next, "LSP: next diagnostic")
      map("n", "<leader>ld", vim.diagnostic.open_float, "LSP: line diagnostics")
      map("n", "<leader>lq", vim.diagnostic.setloclist, "LSP: diagnostic list")

      -- 以 <leader>l 為主的 LSP 群組（對應 which-key 的 +lsp）
      map("n", "<leader>lr", vim.lsp.buf.rename, "LSP: rename")
      map("n", "<leader>la", vim.lsp.buf.code_action, "LSP: code action")
      map("n", "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
      end, "LSP: format buffer")
      map("n", "<leader>ls", vim.lsp.buf.document_symbol, "LSP: document symbols")
      map("n", "<leader>lS", vim.lsp.buf.workspace_symbol, "LSP: workspace symbols")
    end

    -- 每個 server 的設定
    local servers = {
      clangd = {
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      },
      pyright = {},
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = { allFeatures = true },
            checkOnSave = true 
          },
        },
      },
      ts_ls = {
        -- 交給 prettier 處理 formatter，所以這裡不啟用 tsserver 的格式化
        filetypes = {
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
        },
      },
    }

    -- 使用 Neovim 0.10 的新 API 註冊並啟用 LSP
    for name, cfg in pairs(servers) do
      cfg.capabilities = cmp_capabilities
      cfg.on_attach = on_attach
      vim.lsp.config(name, cfg)
      vim.lsp.enable(name)
    end
  end,
}

