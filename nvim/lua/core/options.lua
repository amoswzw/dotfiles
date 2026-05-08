vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local brew_ruby_bin = "/opt/homebrew/opt/ruby/bin"
if vim.fn.executable(brew_ruby_bin .. "/ruby") == 1 then
  local current_path = vim.env.PATH or ""
  local escaped = vim.pesc(brew_ruby_bin)

  if current_path ~= brew_ruby_bin and not current_path:match("^" .. escaped .. ":") then
    vim.env.PATH = brew_ruby_bin .. (current_path ~= "" and ":" .. current_path or "")
  end
end

local opt = vim.opt

opt.fileencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencodings = { "utf-8", "latin1" }
opt.fileformats = { "unix", "dos", "mac" }

opt.number = true
opt.cursorline = true
opt.termguicolors = false
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver35,r-cr-o:hor30,t:block"
opt.laststatus = 2
opt.signcolumn = "yes"
opt.showmode = false
opt.showtabline = 2
opt.syntax = "on"

opt.wildmenu = true
opt.wildmode = { "list:longest", "list:full" }
opt.wildignore:append({ "*.pyc", "*.pyo", "*/.git/*", "*/node_modules/*" })

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.confirm = true

opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.completeopt = { "menuone", "noselect" }
opt.backspace = { "indent", "eol", "start" }
opt.foldmethod = "indent"
opt.foldlevelstart = 99
opt.foldlevel = 99

opt.updatetime = 200
opt.timeoutlen = 400

local swapdir = vim.fn.stdpath("state") .. "/swapfiles"
local undodir = vim.fn.stdpath("state") .. "/undofiles"
if vim.fn.isdirectory(swapdir) == 0 then
  vim.fn.mkdir(swapdir, "p")
end
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
opt.directory = swapdir .. "//"
opt.undodir = undodir .. "//"
opt.undofile = true

if vim.fn.has("mac") == 1
  or vim.fn.executable("pbcopy") == 1
  or vim.fn.executable("wl-copy") == 1
  or vim.fn.executable("xclip") == 1
  or vim.fn.executable("xsel") == 1
  or vim.fn.executable("win32yank.exe") == 1
then
  opt.clipboard:append("unnamedplus")
end

if vim.fn.executable("rg") == 1 then
  opt.grepprg = table.concat({
    "rg",
    "--vimgrep",
    "--smart-case",
    "--hidden",
    "--glob=!**/.git/*",
    "--glob=!**/node_modules/*",
    "--glob=!*.pyc",
    "--glob=!*.pyo",
  }, " ")
  opt.grepformat = "%f:%l:%c:%m"
end
