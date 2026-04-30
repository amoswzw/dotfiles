-- =============================================================================
-- Language-specific Plugins
--   vim-go (Go development)
--   dash.vim (macOS documentation browser)
-- =============================================================================

return {

  -- ── Go ───────────────────────────────────────────────────────────────────────
  -- Replaces: fatih/vim-go (kept — still the definitive Go plugin for Vim/Nvim)
  --   g:go_list_type = "quickfix"
  --   g:go_highlight_* = 1
  --   g:go_def_mode = "gopls"   (uses gopls instead of godef for consistency with LSP)
  --   <leader>b → :GoBuild    (FileType go only)
  --   <leader>r → :GoRun      (FileType go only)
  --   <C-n>/<C-p> → cnext/cprevious (quickfix, defined globally in keymaps.lua)
  {
    "fatih/vim-go",
    ft   = "go",
    init = function()
      -- Use gopls (already installed via mason) to avoid duplicate tools
      vim.g.go_def_mode              = "gopls"
      vim.g.go_info_mode             = "gopls"
      -- Disable vim-go's own LSP/diagnostics — handled by nvim-lspconfig
      vim.g.go_code_completion_enabled = 0
      vim.g.go_diagnostics_enabled     = 0
      vim.g.go_fmt_autosave            = 0  -- handled by conform.nvim
      -- Quickfix
      vim.g.go_list_type = "quickfix"
      -- Highlighting (Treesitter handles most, vim-go adds Go-specific ones)
      vim.g.go_highlight_types     = 1
      vim.g.go_highlight_fields    = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_methods   = 1
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "go",
        callback = function()
          vim.keymap.set("n", "<leader>b", "<Plug>(go-build)", { buffer = true, desc = "Go build" })
          vim.keymap.set("n", "<leader>r", "<Plug>(go-run)",   { buffer = true, desc = "Go run" })
        end,
      })
    end,
  },

  -- ── Dash (macOS documentation) ───────────────────────────────────────────────
  -- Replaces: rizzatti/dash.vim (kept — macOS only)
  {
    "rizzatti/dash.vim",
    cond = function() return vim.fn.has("mac") == 1 end,
    cmd  = { "Dash", "DashKeywords" },
  },

}
