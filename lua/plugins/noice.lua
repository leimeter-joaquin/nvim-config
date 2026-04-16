return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      signature = { enabled = false },
    },
    routes = {
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      },
    },
  },
}
