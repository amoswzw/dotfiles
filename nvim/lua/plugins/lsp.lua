-- =============================================================================
-- LSP + Completion
--   Replaces: davidhalter/jedi-vim, valloric/youcompleteme, ervandew/supertab,
--             vim-syntastic/syntastic (diagnostics)
-- =============================================================================

return {

  -- ── Mason: LSP / linter / formatter installer ─────────────────────────────
  {
    "williamboman/mason.nvim",
    cmd    = "Mason",
    config = function() require("mason").setup() end,
  },

  -- ── mason-tool-installer: auto-install formatters & linters ────────────────
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "VeryLazy",
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- formatters
          "autopep8",                -- python
          "goimports",               -- go (gofmt is built-in)
          "prettier",                -- js/ts/html/css/json/yaml/md
          "stylua",                  -- lua
          "shfmt",                   -- shell
          -- linters
          "golangci-lint",           -- go
        },
      })
    end,
  },

  -- ── LSP Config ──────────────────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Auto-install configured servers via mason
      require("mason-lspconfig").setup({
        ensure_installed      = { "pyright", "gopls", "ts_ls" },
        automatic_installation = true,
      })

      -- Keymaps applied only in buffers with an attached LSP
      local on_attach = function(_, bufnr)
        local opts = function(desc) return { buffer = bufnr, silent = true, desc = desc } end

        -- Navigation
        -- Replaces: <F5> YcmCompleter GoToDefinitionElseDeclaration
        vim.keymap.set("n", "<F5>",        vim.lsp.buf.definition,          opts("Go to definition"))
        vim.keymap.set("n", "gd",          vim.lsp.buf.definition,          opts("Go to definition"))
        vim.keymap.set("n", "gr",          vim.lsp.buf.references,          opts("References"))
        vim.keymap.set("n", "gD",          vim.lsp.buf.declaration,         opts("Go to declaration"))
        vim.keymap.set("n", "gi",          vim.lsp.buf.implementation,      opts("Go to implementation"))

        -- Documentation
        vim.keymap.set("n", "K",           vim.lsp.buf.hover,               opts("Hover docs"))
        -- Replaces: jedi show_call_signatures
        vim.keymap.set("i", "<C-s>",       vim.lsp.buf.signature_help,      opts("Signature help"))
        vim.keymap.set("n", "<leader>s",   vim.lsp.buf.signature_help,      opts("Signature help"))

        -- Refactor
        vim.keymap.set("n", "<leader>rn",  vim.lsp.buf.rename,              opts("Rename symbol"))
        vim.keymap.set("n", "<leader>ca",  vim.lsp.buf.code_action,         opts("Code action"))

        -- Diagnostics
        -- Replaces: <C-k>/<C-j> ALE ale_previous_wrap / ale_next_wrap
        -- NOTE: <C-j>/<C-k> are kept for window navigation globally.
        --       Using ]d/[d (idiomatic Neovim) avoids the conflict.
        vim.keymap.set("n", "]d",          vim.diagnostic.goto_next,        opts("Next diagnostic"))
        vim.keymap.set("n", "[d",          vim.diagnostic.goto_prev,        opts("Prev diagnostic"))
        vim.keymap.set("n", "<leader>e",   vim.diagnostic.open_float,       opts("Show diagnostic"))
      end

      -- Extend nvim-cmp capabilities to LSP servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        pyright = {},
        gopls   = {},
        ts_ls   = {},
      }

      vim.lsp.config("*", { on_attach = on_attach, capabilities = capabilities })

      for server, config in pairs(servers) do
        vim.lsp.config(server, config)
      end
      vim.lsp.enable(vim.tbl_keys(servers))
    end,
  },

  -- ── Completion ───────────────────────────────────────────────────────────────
  -- Replaces: valloric/youcompleteme + ervandew/supertab
  --   Tab     → select next / expand snippet
  --   S-Tab   → select prev
  --   Enter   → confirm selection (replaces pumvisible() CR mapping)
  --   C-Space → trigger completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "zbirenbaum/copilot-cmp",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          -- Replaces: pumvisible() CR mapping
          -- Only confirm when an item is explicitly selected; otherwise fallback
          -- to normal <CR> so auto-indent works when the menu is closed/empty.
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end),
          -- Replaces: supertab Tab behaviour
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible()                          then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable()       then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible()                          then cmp.select_prev_item()
            elseif luasnip.jumpable(-1)               then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "copilot",  group_index = 1 },
          { name = "nvim_lsp", group_index = 1 },
          { name = "luasnip",  group_index = 1 },
          { name = "buffer",   group_index = 2 },
          { name = "path",     group_index = 2 },
        }),
        -- Replaces: g:ycm_autoclose_preview_window_after_completion
        window = {
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },

}
