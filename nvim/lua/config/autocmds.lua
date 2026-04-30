-- =============================================================================
-- Autocommands
-- All groups are named to prevent duplicate registration on re-source.
-- =============================================================================

local augroup = function(name) return vim.api.nvim_create_augroup(name, { clear = true }) end

-- ── Restore cursor position on file open ─────────────────────────────────────
-- Replaces: au BufReadPost * if line("'\"") > 1 ...
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- ── Trailing whitespace highlight ─────────────────────────────────────────────
-- Replaces: highlight ExtraWhitespace / autocmd BufWinEnter match ExtraWhitespace
-- Uses window-local match ID to avoid duplicate matches on repeated events.
vim.api.nvim_set_hl(0, "ExtraWhitespace", { bg = "red" })
vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
  group = augroup("extra_whitespace"),
  callback = function()
    if vim.w.extra_ws_match then
      pcall(vim.fn.matchdelete, vim.w.extra_ws_match)
    end
    vim.w.extra_ws_match = vim.fn.matchadd(
      "ExtraWhitespace",
      [[\s\+$\| \+\ze\t\+\|\t\+\zs \+]]
    )
  end,
})

-- ── Per-filetype indentation ──────────────────────────────────────────────────
-- Replaces: autocmd FileType javascript/less/json/yaml setlocal sw=...
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("filetype_indent"),
  pattern = { "javascript", "typescript" },
  callback = function()
    vim.opt_local.tabstop     = 4
    vim.opt_local.shiftwidth  = 4
    vim.opt_local.softtabstop = 4
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  group   = augroup("filetype_indent"),
  pattern = { "less", "json", "yaml" },
  callback = function()
    vim.opt_local.tabstop     = 2
    vim.opt_local.shiftwidth  = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- ── Auto lcd to file's directory ─────────────────────────────────────────────
-- Replaces: autocmd BufEnter * lcd %:p:h
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("auto_lcd"),
  callback = function()
    local dir = vim.fn.expand("%:p:h")
    if vim.fn.isdirectory(dir) == 1 then
      vim.cmd("lcd " .. vim.fn.fnameescape(dir))
    end
  end,
})

-- ── Search highlight colours ─────────────────────────────────────────────────
-- Re-apply after colorscheme loads (colorschemes overwrite highlights)
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup("search_hl"),
  callback = function()
    vim.api.nvim_set_hl(0, "IncSearch",      { bg = "darkgrey" })
    vim.api.nvim_set_hl(0, "Search",         { bg = "darkgrey" })
    vim.api.nvim_set_hl(0, "CursorLine",     { bold = true })
    vim.api.nvim_set_hl(0, "ExtraWhitespace",{ bg = "red" })
  end,
})
