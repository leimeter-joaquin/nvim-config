return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        eslint = function(_, opts)
          local on_attach = opts.on_attach
          opts.on_attach = function(client, bufnr)
            if on_attach then
              on_attach(client, bufnr)
            end
            client.server_capabilities.hoverProvider = false
          end
        end,
      },
    },
  },
}
