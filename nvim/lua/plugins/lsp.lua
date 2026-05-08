return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "autopep8",
        "bash-language-server",
        "clang-format",
        "clangd",
        "eslint_d",
        "flake8",
        "goimports",
        "golangci-lint",
        "google-java-format",
        "gopls",
        "hadolint",
        "jdtls",
        "lua-language-server",
        "markdownlint",
        "prettier",
        "pyright",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "solargraph",
        "sql-formatter",
        "stylua",
        "taplo",
        "terraform",
        "terraform-ls",
        "tflint",
        "typescript-language-server",
        "yaml-language-server",
        "yamllint",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "bashls",
        "clangd",
        "gopls",
        "jdtls",
        "lua_ls",
        "pyright",
        "solargraph",
        "rust_analyzer",
        "taplo",
        "terraformls",
        "ts_ls",
        "yamlls",
      },
    },
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    opts = {
      hint_enable = false,
      handler_opts = {
        border = "rounded",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "ray-x/lsp_signature.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local brew_ruby = vim.fn.exepath("ruby")
      local diagnostic_float_opts = {
        border = "rounded",
        focusable = false,
        scope = "line",
        source = "if_many",
        close_events = { "CursorMoved", "InsertEnter", "FocusLost" },
      }

      vim.diagnostic.config({
        severity_sort = true,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        float = diagnostic_float_opts,
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        group = vim.api.nvim_create_augroup("user_diagnostic_float", { clear = true }),
        callback = function()
          if vim.bo.buftype ~= "" then
            return
          end

          vim.diagnostic.open_float(nil, diagnostic_float_opts)
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_keymaps", { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          map("n", "<F5>", vim.lsp.buf.definition, "Go To Definition")
          map("n", "gd", vim.lsp.buf.definition, "Go To Definition")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gr", function()
            vim.lsp.buf.references(nil, {
              includeDeclaration = false,
            })
          end, "References")
          map("n", "gD", vim.lsp.buf.declaration, "Go To Declaration")
          map("n", "gl", function()
            vim.diagnostic.open_float(nil, diagnostic_float_opts)
          end, "Line Diagnostics")
          map("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
          map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
          map("n", "<leader>gi", vim.lsp.buf.implementation, "Go To Implementation")
          map("n", "<leader>gt", vim.lsp.buf.type_definition, "Go To Type Definition")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")

          require("lsp_signature").on_attach({}, bufnr)
        end,
      })

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })

      vim.lsp.config("bashls", {})
      vim.lsp.config("clangd", {})
      vim.lsp.config("jdtls", {})
      vim.lsp.config("pyright", {})
      vim.lsp.config("gopls", {})
      vim.lsp.config("solargraph", {
        cmd = { brew_ruby, "-S", "solargraph", "stdio" },
      })
      vim.lsp.config("rust_analyzer", {})
      vim.lsp.config("taplo", {})
      vim.lsp.config("terraformls", {})
      vim.lsp.config("ts_ls", {})
      vim.lsp.config("yamlls", {})

      vim.lsp.enable({
        "bashls",
        "clangd",
        "gopls",
        "jdtls",
        "lua_ls",
        "pyright",
        "solargraph",
        "rust_analyzer",
        "taplo",
        "terraformls",
        "ts_ls",
        "yamlls",
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "milanglacier/minuet-ai.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.core.view:visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<A-y>"] = require("minuet").make_cmp_map(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "minuet", group_index = 1, priority = 100 },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        performance = {
          fetching_timeout = 2000,
        },
        window = {
          documentation = cmp.config.window.bordered(),
        },
      })
    end,
  },
}
