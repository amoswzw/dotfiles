-- =============================================================================
-- Editor Plugins
--   Fuzzy Finder, Treesitter, Linting, Formatting
-- =============================================================================

return {

  -- ── Fuzzy Finder ─────────────────────────────────────────────────────────────
  -- Replaces: Shougo/unite.vim + mileszs/ack.vim
  --   <leader>b → Unite buffer
  --   <leader>f → Unite file
  --   <leader><space> → Unite file_rec
  --   <leader>/ * :Ack -w <cword>
  --   gf :sp file_rec (open split with file search)
  {
    "nvim-telescope/telescope.nvim",
    branch       = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd  = "Telescope",
    keys = function()
      local builtin = require("telescope.builtin")
      return {
        { "<leader>b",     builtin.buffers,                                    desc = "Buffers" },
        { "<leader>f",     builtin.find_files,                                 desc = "Find files" },
        { "<leader><space>",builtin.find_files,                                desc = "Find files (rec)" },
        { "<leader>/",     function() builtin.grep_string({ word_match="-w" }) end, desc = "Grep word" },
        { "<leader>g",     builtin.live_grep,                                  desc = "Live grep" },
        -- Replaces: gf :sp + Unite file_rec (find file named like word under cursor)
        { "<leader>gf",    function()
          builtin.find_files({ default_text = vim.fn.expand("<cword>") })
        end, desc = "Find file (word under cursor)" },
      }
    end,
    config = function()
      -- nvim-treesitter v1.x removed ft_to_lang; shim it for telescope's previewer
      local ok, parsers = pcall(require, "nvim-treesitter.parsers")
      if ok and not parsers.ft_to_lang then
        parsers.ft_to_lang = function(ft)
          return vim.treesitter.language.get_lang(ft) or ft
        end
      end

      require("telescope").setup({
        defaults = {
          file_ignore_patterns = { "%.pyc", "%.pyo", "^.git/", "node_modules/" },
        },
      })
      require("telescope").load_extension("fzf")
    end,
  },

  -- ── Treesitter ───────────────────────────────────────────────────────────────
  -- Replaces: hdima/python-syntax, leafgarland/typescript-vim, uarun/vim-protobuf
  -- NOTE: nvim-treesitter v1.x rewrite — no lazy loading, new API
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy  = false,
    config = function()
      require("nvim-treesitter").setup()
      local wanted = {
        "python", "go", "typescript", "javascript", "tsx",
        "lua", "vim", "vimdoc", "bash", "proto",
        "json", "yaml", "toml", "html", "css", "markdown", "markdown_inline",
        "c", "cpp", "rust", "swift",
      }
      -- Use nvim-treesitter's own API to reliably detect installed parsers
      local installed = require("nvim-treesitter.config").get_installed()
      local missing = vim.tbl_filter(function(lang)
        return not vim.list_contains(installed, lang)
      end, wanted)
      if #missing > 0 then
        require("nvim-treesitter").install(missing)
      end
      -- Enable treesitter highlighting for all supported filetypes
      vim.api.nvim_create_autocmd({ "FileType", "BufReadPost" }, {
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
          if lang then
            pcall(vim.treesitter.start, ev.buf, lang)
          end
        end,
      })
    end,
  },

  -- ── Linting ──────────────────────────────────────────────────────────────────
  -- Replaces: w0rp/ale (linting side) + vim-syntastic/syntastic
  --   g:ale_python_flake8_options = "--ignore=E402,E128 --max-line-length=160"
  --   g:ale_linters = {'go': ['golangci-lint']}
  --   <leader>c → :ALEToggle
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        python = { "flake8" },
        go     = { "golangci-lint" },
      }

      -- Replaces: g:ale_python_flake8_options
      lint.linters.flake8.args = {
        "--ignore=E402,E128",
        "--max-line-length=160",
        "--format=%(path)s:%(row)d:%(col)d: %(code)s %(text)s",
        "-",
      }

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        callback = function()
          if vim.g.lint_enabled then lint.try_lint() end
        end,
      })

      -- Replaces: <leader>c :ALEToggle
      -- Initialized to true so lint runs by default
      vim.g.lint_enabled = true
      vim.keymap.set("n", "<leader>c", function()
        vim.g.lint_enabled = not vim.g.lint_enabled
        if vim.g.lint_enabled then lint.try_lint() end
        vim.notify("Lint " .. (vim.g.lint_enabled and "enabled" or "disabled"))
      end, { desc = "Toggle lint" })
    end,
  },

  -- ── Formatting ───────────────────────────────────────────────────────────────
  -- Replaces: w0rp/ale (formatting side)
  -- <leader>fm → format buffer
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys  = {
      { "<leader>fm", function()
          require("conform").format({ async = true, lsp_fallback = true })
        end, mode = { "n", "v" }, desc = "Format buffer" },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python     = { "autopep8" },
          go         = { "gofmt", "goimports" },
          typescript = { "prettier" },
          javascript = { "prettier" },
          typescriptreact = { "prettier" },
          javascriptreact = { "prettier" },
          json       = { "prettier" },
          yaml       = { "prettier" },
          html       = { "prettier" },
          css        = { "prettier" },
          markdown   = { "prettier" },
          lua        = { "stylua" },
          sh         = { "shfmt" },
          bash       = { "shfmt" },
          rust       = { "rustfmt" },
        },
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
      })
    end,
  },

}
