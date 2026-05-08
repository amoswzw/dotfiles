local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Window Left" })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Window Down" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Window Up" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Window Right" })

-- Alacritty sends dedicated escape sequences for Cmd-[ / Cmd-] on macOS.
map("n", "\27[2001~", "<cmd>bprevious<CR>", { silent = true, desc = "Buffer Previous" })
map("n", "\27[2002~", "<cmd>bnext<CR>", { silent = true, desc = "Buffer Next" })
map("n", "[b", "<cmd>bprevious<CR>", { silent = true, desc = "Buffer Previous" })
map("n", "]b", "<cmd>bnext<CR>", { silent = true, desc = "Buffer Next" })

map("n", "<C-n>", "<cmd>cnext<CR>", { silent = true, desc = "Quickfix Next" })
map("n", "<C-p>", "<cmd>cprevious<CR>", { silent = true, desc = "Quickfix Previous" })
map("n", "<leader>a", "<cmd>cclose<CR>", { silent = true, desc = "Close Quickfix" })
map("n", "<leader><CR>", "<cmd>nohlsearch<CR>", { silent = true, desc = "Clear Search Highlight" })

map("n", "<leader><space>", function()
  local word = vim.fn.expand("<cword>")
  if word == nil or word == "" then
    return
  end

  vim.fn.setreg("/", "\\V\\<" .. vim.fn.escape(word, "\\") .. "\\>")
  vim.opt.hlsearch = true
end, { silent = true, desc = "Search Current Word" })

map("n", "<leader>/", function()
  local word = vim.fn.expand("<cword>")
  if word == nil or word == "" then
    return
  end

  vim.fn.setreg("/", "\\V" .. vim.fn.escape(word, "\\"))
  vim.opt.hlsearch = true
  vim.cmd("silent grep! -w " .. vim.fn.shellescape(word))

  local qf = vim.fn.getqflist({ size = 0 })
  if qf.size > 0 then
    vim.cmd("copen")
  else
    vim.notify("No matches for " .. word, vim.log.levels.INFO)
  end
end, { silent = true, desc = "Grep Current Word" })
