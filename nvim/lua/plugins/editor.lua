return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      -- Broaden syntax coverage for common source and config files.
      local wanted = {
        "bash",
        "c",
        "comment",
        "cpp",
        "css",
        "csv",
        "diff",
        "dockerfile",
        "git_config",
        "gitcommit",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "hcl",
        "html",
        "ini",
        "javascript",
        "jsdoc",
        "json5",
        "json",
        "jsx",
        "java",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "proto",
        "query",
        "regex",
        "ruby",
        "rust",
        "scss",
        "sql",
        "ssh_config",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "zsh",
      }

      ts.setup({})

      local installed = ts.get_installed()
      local missing = vim.tbl_filter(function(lang)
        return not vim.list_contains(installed, lang)
      end, wanted)
      if #missing > 0 then
        ts.install(missing)
      end

      local function start_treesitter(args)
        if vim.bo[args.buf].buftype ~= "" then
          return
        end

        local ft = vim.bo[args.buf].filetype
        if ft == "" then
          return
        end

        if vim.treesitter.highlighter.active[args.buf] then
          return
        end

        local lang = vim.treesitter.language.get_lang(ft) or ft
        local ok = pcall(vim.treesitter.start, args.buf, lang)
        if ok then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = start_treesitter,
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      local function reset_lint_diagnostics()
        local seen = {}
        for _, linters in pairs(lint.linters_by_ft) do
          for _, name in ipairs(linters) do
            if not seen[name] then
              seen[name] = true
              local ok, namespace = pcall(lint.get_namespace, name)
              if ok and namespace then
                vim.diagnostic.reset(namespace)
              end
            end
          end
        end
      end

      lint.linters_by_ft = {
        bash = { "shellcheck" },
        dockerfile = { "hadolint" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        markdown = { "markdownlint" },
        python = { "flake8" },
        go = { "golangcilint" },
        sh = { "shellcheck" },
        terraform = { "tflint" },
        ["terraform-vars"] = { "tflint" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        yaml = { "yamllint" },
      }

      if lint.linters.flake8 then
        lint.linters.flake8.args = {
          "--ignore=E402,E128",
          "--max-line-length=160",
          "--format=%(path)s:%(row)d:%(col)d: %(code)s %(text)s",
          "-",
        }
      end

      vim.g.lint_enabled = true

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint_on_events", { clear = true }),
        callback = function()
          if vim.g.lint_enabled then
            lint.try_lint()
          end
        end,
      })

      vim.keymap.set("n", "<leader>c", function()
        vim.g.lint_enabled = not vim.g.lint_enabled
        if vim.g.lint_enabled then
          lint.try_lint()
        else
          reset_lint_diagnostics()
        end
        vim.notify("Lint " .. (vim.g.lint_enabled and "enabled" or "disabled"))
      end, { silent = true, desc = "Toggle Lint" })
    end,
  },

  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo", "Format" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "n",
        silent = true,
        desc = "Format Buffer",
      },
    },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          bash = { "shfmt" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          css = { "prettier" },
          go = { "goimports", "gofmt" },
          hcl = { "terraform_fmt" },
          html = { "prettier" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          java = { "google-java-format" },
          less = { "prettier" },
          lua = { "stylua" },
          markdown = { "prettier" },
          python = { "autopep8" },
          scss = { "prettier" },
          sh = { "shfmt" },
          sql = { "sql_formatter" },
          terraform = { "terraform_fmt" },
          ["terraform-vars"] = { "terraform_fmt" },
          toml = { "taplo" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          yaml = { "prettier" },
        },
      })

      vim.api.nvim_create_user_command("Format", function()
        conform.format({ async = true, lsp_fallback = true })
      end, {})
    end,
  },
}
