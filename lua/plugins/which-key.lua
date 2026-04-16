return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.delay = 300
      opts.notify = false
      opts.filter = function(_)
        return true
      end

      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        { "<leader>t", group = "+test" },
      })
    end,
  },
}
