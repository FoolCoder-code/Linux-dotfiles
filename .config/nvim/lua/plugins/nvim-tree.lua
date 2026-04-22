return {
    "kyazdani42/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup {}
    end,

    keys = {
        { "<leader>t", "<cmd>NvimTreeFocus<cr>", desc = "Focus on filetree" },
    },
}
