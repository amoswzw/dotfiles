-- =============================================================================
-- Git Plugins
--   vim-fugitive (kept as-is — still the gold standard)
--   gitsigns.nvim (modern gutter signs + hunk navigation)
--   vim-dispatch (async build / test runner)
-- =============================================================================

return {

  -- ── Fugitive ─────────────────────────────────────────────────────────────────
  -- Replaces: tpope/vim-fugitive (kept — no better alternative exists)
  { "tpope/vim-fugitive", cmd = { "Git", "G", "Gdiffsplit", "Gblame" } },

  -- ── Git signs in gutter ──────────────────────────────────────────────────────
  -- Added: shows changed/added/removed lines; hunk staging, blame line
  {
    "lewis6991/gitsigns.nvim",
    event  = { "BufReadPost", "BufNewFile" },
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "+" },
          change       = { text = "~" },
          delete       = { text = "_" },
          topdelete    = { text = "‾" },
          changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
          local gs   = package.loaded.gitsigns
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "]h", gs.next_hunk,   vim.tbl_extend("force", opts, { desc = "Next hunk" }))
          vim.keymap.set("n", "[h", gs.prev_hunk,   vim.tbl_extend("force", opts, { desc = "Prev hunk" }))
          vim.keymap.set("n", "<leader>hs", gs.stage_hunk,   vim.tbl_extend("force", opts, { desc = "Stage hunk" }))
          vim.keymap.set("n", "<leader>hr", gs.reset_hunk,   vim.tbl_extend("force", opts, { desc = "Reset hunk" }))
          vim.keymap.set("n", "<leader>hb", gs.blame_line,   vim.tbl_extend("force", opts, { desc = "Blame line" }))
        end,
      })
    end,
  },

  -- ── Async dispatch ───────────────────────────────────────────────────────────
  -- Replaces: tpope/vim-dispatch (kept — used by ack.vim & general async tasks)
  { "tpope/vim-dispatch", cmd = { "Dispatch", "Make", "Start" } },

}
