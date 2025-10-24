-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Copy relative file path to clipboard (relative to cwd/project root)
vim.keymap.set("n", "<leader>fy", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify('Copied: ' .. path, vim.log.levels.INFO)
end, { desc = "Yank file path" })
