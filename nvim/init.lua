-- =============================================================================
-- Neovim Configuration Entry Point
-- Structure:
--   init.lua              ← you are here
--   lua/config/options.lua
--   lua/config/keymaps.lua
--   lua/config/autocmds.lua
--   lua/plugins/ui.lua    ← colorscheme, statusline, explorer, outline
--   lua/plugins/editor.lua← telescope, treesitter, lint, format
--   lua/plugins/lsp.lua   ← mason, lspconfig, nvim-cmp
--   lua/plugins/git.lua   ← fugitive, gitsigns, dispatch
--   lua/plugins/lang.lua  ← vim-go, dash
-- =============================================================================

-- Leader must be set before lazy loads plugins
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── Bootstrap lazy.nvim ───────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── Load core settings before plugins ────────────────────────────────────────
require("config.options")

-- ── Load plugins (all files under lua/plugins/) ───────────────────────────────
require("lazy").setup("plugins", {
  ui = { border = "rounded" },
  change_detection = { notify = false },
  rocks = { enabled = false },
})

-- ── Load keymaps and autocmds after plugins ───────────────────────────────────
require("config.keymaps")
require("config.autocmds")
