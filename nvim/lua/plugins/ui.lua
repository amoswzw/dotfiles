-- =============================================================================
-- UI Plugins
--   Colorscheme, Statusline, File Explorer, Symbol Outline,
--   Indent Guides, Rainbow Delimiters, Smooth Scroll
-- =============================================================================

return {

  -- ── Colorscheme ─────────────────────────────────────────────────────────────
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config   = function()
      require("gruvbox").setup({ contrast = "hard" })
      vim.o.background = "dark"
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  -- ── Statusline + tabline ─────────────────────────────────────────────────────
  -- Replaces: vim-airline + vim-airline-themes (luna theme, buffer numbers)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event  = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme     = "gruvbox",
          globalstatus = true,             -- matches laststatus=3
        },
        sections = {
          lualine_c = { { "filename", path = 1 } }, -- show relative path
        },
        tabline = {
          -- Replaces: airline#extensions#tabline + buffer_nr_show
          lualine_a = { { "buffers", show_bufnr = true } },
        },
        extensions = { "nvim-tree", "aerial", "fugitive", "quickfix" },
      })
    end,
  },

  -- ── File Explorer ────────────────────────────────────────────────────────────
  -- Replaces: scrooloose/nerdtree
  --   NERDTreeWinPos=right, NERDTreeWinSize=32, NERDTreeIgnore
  --   Keymap: tr → NERDTreeToggle
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd  = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = { { "tr", ":NvimTreeToggle<CR>", silent = true, desc = "Toggle file tree" } },
    config = function()
      -- NERDTree-compatible keybindings
      local function on_attach(bufnr)
        local api  = require("nvim-tree.api")
        local opts = function(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Start from nvim-tree defaults
        api.config.mappings.default_on_attach(bufnr)

        local function map(key, fn, desc)
          if fn then vim.keymap.set("n", key, fn, opts(desc)) end
        end

        map("t",  api.node.open.tab,                            "Open: New Tab")
        map("T",  api.node.open.tab_no_picker,                  "Open: New Tab (silent)")
        map("i",  api.node.open.horizontal,                     "Open: Horizontal Split")
        map("s",  api.node.open.vertical,                       "Open: Vertical Split")
        map("go", api.node.open.preview,                        "Preview")
        map("x",  api.node.navigate.parent_close,               "Close Node")
        map("X",  api.tree.collapse_all,                        "Collapse All")
        map("p",  api.node.navigate.parent,                     "Parent Directory")
        map("C",  api.tree.change_root_to_node,                 "CD")
        map("u",  api.tree.change_root_to_parent,               "Up")
        map("I",  api.tree.toggle_hidden_filter,                "Toggle Hidden")
        map("?",  api.tree.toggle_help,                         "Help")
      end

      require("nvim-tree").setup({
        on_attach = on_attach,
        view      = { side = "right", width = 32 },
        filters   = {
          custom = { "\\.pyc$", "__pycache__", "\\.DS_Store$" },
        },
        tab = {
          sync = { open = false, close = false },
        },
      })
    end,
  },

  -- ── Symbol Outline ───────────────────────────────────────────────────────────
  -- Replaces: majutsushi/tagbar
  --   tagbar_width=26, tagbar_left=1, TypeScript kind definitions
  --   Keymap: tb → TagbarToggle
  -- aerial.nvim integrates with both LSP and Treesitter for richer symbols
  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd  = "AerialToggle",
    keys = { { "tb", ":AerialToggle<CR>", silent = true, desc = "Toggle outline" } },
    config = function()
      require("aerial").setup({
        layout = { default_direction = "left", width = 26 },
        attach_mode = "global",
        -- Show all symbol kinds including properties and variables
        filter_kind = {
          "Class", "Constructor", "Enum", "EnumMember",
          "Function", "Interface", "Method", "Module",
          "Namespace", "Package", "Property", "Struct",
          "TypeParameter", "Variable", "Field", "Constant",
        },
      })
    end,
  },

  -- ── Indent Guides ────────────────────────────────────────────────────────────
  -- Replaces: Yggdroot/indentLine
  --   Keymap: <leader>i → IndentLinesToggle
  {
    "lukas-reineke/indent-blankline.nvim",
    main  = "ibl",
    event = "BufReadPost",
    keys  = { { "<leader>i", ":IBLToggle<CR>", silent = true, desc = "Toggle indent guides" } },
    config = function()
      require("ibl").setup({ scope = { enabled = false } })
    end,
  },

  -- ── Rainbow Delimiters ───────────────────────────────────────────────────────
  -- Replaces: luochen1990/rainbow (g:rainbow_active = 1)
  -- Works with Treesitter for accurate bracket matching
  {
    "HiPhish/rainbow-delimiters.nvim",
    event  = "BufReadPost",
    config = function()
      require("rainbow-delimiters.setup").setup({})
    end,
  },

  -- ── Smooth Scroll ────────────────────────────────────────────────────────────
  -- Replaces: yonchu/accelerated-smooth-scroll
  {
    "karb94/neoscroll.nvim",
    event  = "VeryLazy",
    config = function()
      require("neoscroll").setup({ easing = "quadratic" })
    end,
  },

}
