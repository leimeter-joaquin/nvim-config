return {
  "rmagatti/auto-session",
  lazy = false,
  keys = {
    { "<leader>qd", "<cmd>AutoSession delete<cr>", desc = "Delete Session (cwd)" },
    { "<leader>ql", "<cmd>AutoSession restore<cr>", desc = "Restore Session (cwd)" },
    { "<leader>qs", "<cmd>AutoSession save<cr>", desc = "Save Session (cwd)" },
    { "<leader>qS", "<cmd>AutoSession search<cr>", desc = "Select Session" },
  },

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    -- log_level = 'debug',
  },
}
