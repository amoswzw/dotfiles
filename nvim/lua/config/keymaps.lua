-- =============================================================================
-- Global Keymaps
-- LSP-specific keymaps live in lua/plugins/lsp.lua (on_attach)
-- =============================================================================

local map = vim.keymap.set

-- ── Window navigation ─────────────────────────────────────────────────────────
-- Replaces: map <c-h/j/k/l> <c-w>h/j/k/l
map("n", "<C-h>", "<C-w>h", { silent = true, desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { silent = true, desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { silent = true, desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { silent = true, desc = "Window right" })

-- ── Quickfix navigation ───────────────────────────────────────────────────────
-- Replaces: map <C-n> :cnext / map <C-m> :cprevious
-- NOTE: <C-m> == <Enter> in terminals — remapping it breaks Enter key.
--       Using <C-n>/<C-p> instead (mnemonic: next/previous).
map("n", "<C-n>", ":cnext<CR>",     { silent = true, desc = "Quickfix next" })
map("n", "<C-p>", ":cprevious<CR>", { silent = true, desc = "Quickfix prev" })
map("n", "<leader>a", ":cclose<CR>", { silent = true, desc = "Close quickfix" })

-- ── Search ────────────────────────────────────────────────────────────────────
map("n", "<leader>h",    ":nohlsearch<CR>", { silent = true, desc = "Clear highlights" })
map("n", "<leader><CR>", ":nohlsearch<CR>", { silent = true, desc = "Clear highlights" })
map("n", "<leader><leader>", "*", { silent = true, desc = "Search word under cursor" })

-- ── Buffer navigation ─────────────────────────────────────────────────────────
map("n", "<leader>]", ":bnext<CR>",     { silent = true, desc = "Next buffer" })
map("n", "<leader>[", ":bprevious<CR>", { silent = true, desc = "Prev buffer" })
map("n", "<leader>d", ":bdelete<CR>",   { silent = true, desc = "Delete buffer" })
