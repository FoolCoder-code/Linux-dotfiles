return {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
        local cmp = require("cmp")
        opts.mapping = vim.tbl_extend("force", opts.mapping, {
            ["<CR>"] = function() end,
            ["<Tab>"] = cmp.mapping.confirm({ select = true }),
            ["<S-Tab>"] = nil,
        })
    end,
}
