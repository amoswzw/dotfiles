-- =============================================================================
-- Options
-- =============================================================================

-- Disable netrw before any plugin loads (required by nvim-tree)
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

-- ── Encoding ──────────────────────────────────────────────────────────────────
-- Note: Neovim always uses UTF-8 internally; fileencoding controls file I/O
opt.fileencoding  = "utf-8"
opt.fileencodings = { "utf-8", "latin1" }
opt.fileformats   = { "unix", "dos", "mac" }

-- ── Appearance ────────────────────────────────────────────────────────────────
opt.number        = true
opt.cursorline    = true
opt.termguicolors = true          -- true-color support (replaces t_Co=256)
opt.laststatus    = 3             -- single global statusline (Neovim 0.7+)
opt.signcolumn    = "yes"         -- always show sign column, avoids layout shifts
opt.showmode      = false         -- lualine already shows the mode

-- ── Search ────────────────────────────────────────────────────────────────────
opt.hlsearch   = true
opt.incsearch  = true
opt.ignorecase = true
opt.smartcase  = true             -- case-sensitive when query contains uppercase

-- ── Tabs / Indentation (default: 4 spaces) ────────────────────────────────────
opt.autoindent  = true
opt.smartindent = true
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.softtabstop = 4
opt.expandtab   = true

-- ── Completion ────────────────────────────────────────────────────────────────
-- "noselect" is required for nvim-cmp to work correctly
opt.completeopt = { "menu", "menuone", "noselect" }

-- ── Wildmenu ──────────────────────────────────────────────────────────────────
opt.wildmenu = true
opt.wildmode = { "list:longest", "list:full" }
opt.wildignore:append({ "*.pyc", "*.pyo", "*/.git/*", "*/node_modules/*" })

-- ── Editor behaviour ──────────────────────────────────────────────────────────
opt.backspace  = { "indent", "eol", "start" }
opt.updatetime = 250              -- faster CursorHold events (better LSP UX)
opt.timeoutlen = 500              -- shorter leader timeout

-- ── Swap files ────────────────────────────────────────────────────────────────
local swapdir = vim.fn.expand("$HOME/.local/share/nvim/swapfiles")
vim.fn.mkdir(swapdir, "p")
opt.directory = swapdir .. "//"

-- ── Folding ───────────────────────────────────────────────────────────────────
-- foldlevelstart controls the initial fold depth when opening a buffer
opt.foldmethod     = "indent"
opt.foldlevelstart = 99           -- open all folds by default

-- ── Clipboard ────────────────────────────────────────────────────────────────
opt.clipboard = "unnamedplus"         -- sync with system clipboard

-- ── Providers ────────────────────────────────────────────────────────────────
-- Disable unused remote providers to suppress checkhealth warnings
vim.g.loaded_perl_provider   = 0
vim.g.loaded_ruby_provider   = 0
vim.g.loaded_python3_provider = 0
