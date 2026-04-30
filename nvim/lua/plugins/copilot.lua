-- =============================================================================
-- GitHub Copilot
--   copilot.lua   → pure-Lua driver (replaces github/copilot.vim)
--   copilot-cmp   → exposes Copilot suggestions as an nvim-cmp source
-- =============================================================================

return {

  -- ── Copilot engine ──────────────────────────────────────────────────────────
  {
    "zbirenbaum/copilot.lua",
    cmd   = "Copilot",
    event = "InsertEnter",
    opts  = {
      copilot_node_command = vim.fn.expand("~/.nvm/versions/node/v22.22.1/bin/node"),
      suggestion = { enabled = false }, -- handled via copilot-cmp instead
      panel      = { enabled = false },
      filetypes  = {
        yaml     = true,
        markdown = true,
        ["*"]    = true,
      },
    },
  },

  -- ── nvim-cmp source for Copilot ─────────────────────────────────────────────
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    event        = "InsertEnter",
    config       = function()
      require("copilot_cmp").setup()
    end,
  },

}
