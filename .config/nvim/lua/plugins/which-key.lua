-- lua/plugins/which-key.lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,

  config = function()
    local wk = require("which-key")

    wk.add({
      { "<leader>f", group = "+file" },
      { "<leader>g", group = "+git" },
      { "<leader>l", group = "+lsp" },
      { "<leader>d", group = "+debug" },
      { "<leader>t", group = "+tree" },
      { "<leader>c", group = "+code" },
      { "<leader>s", group = "+search" },
      { "<leader>q", group = "+session" },
    })
  end,
}

