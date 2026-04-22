return {
  "williamboman/mason.nvim",
  cmd = { "Mason", "MasonInstall", "MasonUpdate" },
  event = "VeryLazy",
  opts = {
    max_concurrent_installers = 8,
  },
}

