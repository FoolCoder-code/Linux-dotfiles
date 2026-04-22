-- lua/plugins/code-tools.lua
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        cpp = { "cpplint" },
        c = { "cpplint" },
        python = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        rust = { "clippy" }, -- 需要系統有 clippy，可視情況改掉
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set("n", "<leader>cl", function()
        lint.try_lint()
      end, { desc = "Code: run linter" })
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          cpp = { "clang_format" },
          c = { "clang_format" },
          rust = { "rustfmt" },
          python = { "ruff_organize_imports", "ruff_format" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
        },
        format_on_save = function(bufnr)
          -- 可視需要關掉某些大型專案
          return { timeout_ms = 2000, lsp_fallback = true }
        end,
      })

      vim.keymap.set("n", "<leader>cf", function()
        conform.format({ async = true, lsp_fallback = true })
      end, { desc = "Code: format file" })

      vim.keymap.set("v", "<leader>cf", function()
        conform.format({ async = true, lsp_fallback = true })
      end, { desc = "Code: format selection" })
    end,
  },
}

