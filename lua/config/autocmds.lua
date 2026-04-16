-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-delete swap files on successful exit to prevent E325 errors
vim.api.nvim_create_autocmd({ "VimLeave", "BufWritePost" }, {
  pattern = "*",
  callback = function()
    local swap = vim.fn.swapname(vim.fn.bufnr())
    if swap ~= "" and vim.fn.filereadable(swap) == 1 then
      vim.fn.delete(swap)
    end
  end,
})
