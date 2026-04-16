-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

-- Scroll mapping
-- map("n", "z", "10j", { desc = "moves 10 lines down" })
-- map("n", "q", "10k", { desc = "moves 10 lines up" })

-- Manual completion popup (reliable: calls Blink directly)
map("i", "<C-l>", function()
  local ok, blink = pcall(require, "blink.cmp")
  if not ok then
    return
  end

  if blink.is_menu_visible() then
    blink.hide()
  else
    blink.show()
  end
end, { desc = "Blink: toggle completion menu" })
