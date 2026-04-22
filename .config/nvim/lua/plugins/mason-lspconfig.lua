return {
  "williamboman/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
  },
  opts = {
    ensure_installed = {
      "clangd",        -- C/C++
      "pyright",       -- Python
      "rust_analyzer", -- Rust
      "ts_ls",
    },
    automatic_installation = false,
  },
}

