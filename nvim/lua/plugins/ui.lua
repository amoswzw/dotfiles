return {
  {
    "jnurmine/zenburn",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.zenburn_force_dark_Background = 1
      vim.g.zenburn_old_Visual = 1
      vim.cmd.colorscheme("zenburn")
      vim.cmd("highlight CursorLine cterm=NONE ctermbg=24 gui=NONE guibg=#1f3442")
      vim.cmd("highlight CursorLineNr cterm=bold ctermfg=223 gui=bold guifg=#f0dfaf")
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps",
      },
    },
    opts = {
      preset = "classic",
      delay = 300,
      win = {
        border = "rounded",
      },
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Go/Git" },
        { "<leader>m", group = "Markdown" },
      },
    },
  },

  {
    "vim-airline/vim-airline",
    lazy = false,
    dependencies = {
      "vim-airline/vim-airline-themes",
      "nvim-tree/nvim-web-devicons",
    },
    init = function()
      vim.g.airline_theme = "zenburn"
      vim.g.airline_powerline_fonts = 1
      vim.g.airline_path_format = "short"
      vim.g.airline_exclude_filetypes = { "NvimTree" }
      vim.g.airline_exclude_filenames = { "NvimTree_*" }
      vim.g["airline#extensions#tabline#enabled"] = 1
      vim.g["airline#extensions#tabline#buffer_nr_show"] = 1
      vim.g["airline#extensions#tabline#ignore_bufadd_pat"] = "NvimTree_"
      vim.g["airline#extensions#tabline#keymap_ignored_filetypes"] = { "nerdtree", "NvimTree" }
      vim.g["airline#extensions#whitespace#enabled"] = 0
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "tr", "<cmd>NvimTreeToggle<CR>", silent = true, desc = "Toggle File Tree" },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local function on_attach(bufnr)
        local api = require("nvim-tree.api")

        api.map.on_attach.default(bufnr)

        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        local function wait_opts(desc)
          local options = opts(desc)
          options.nowait = false
          return options
        end

        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
        vim.keymap.set("n", "go", api.node.open.preview, opts("Open Preview"))
        vim.keymap.set("n", "tr", api.tree.toggle, opts("Toggle Tree"))
        vim.keymap.set("n", "t", api.node.open.tab, wait_opts("Open In Tab"))
        vim.keymap.set("n", "T", api.node.open.tab_drop, opts("Open In Tab"))
        vim.keymap.set("n", "i", api.node.open.horizontal, opts("Open Horizontal Split"))
        vim.keymap.set("n", "gi", api.node.open.horizontal_no_picker, opts("Open Horizontal Split"))
        vim.keymap.set("n", "s", api.node.open.vertical, opts("Open Vertical Split"))
        vim.keymap.set("n", "gs", api.node.open.vertical_no_picker, opts("Open Vertical Split"))
        vim.keymap.set("n", "x", api.node.navigate.parent_close, opts("Close Parent"))
        vim.keymap.set("n", "X", function()
          api.node.collapse(api.tree.get_node_under_cursor())
        end, opts("Collapse Node"))
        vim.keymap.set("n", "p", api.node.navigate.parent, opts("Go To Parent"))
        vim.keymap.set("n", "P", function()
          vim.cmd("normal! gg")
        end, opts("Go To Root"))
        vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts("First Sibling"))
        vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts("Last Sibling"))
        vim.keymap.set("n", "<C-j>", api.node.navigate.sibling.next, opts("Next Sibling"))
        vim.keymap.set("n", "<C-k>", api.node.navigate.sibling.prev, opts("Previous Sibling"))
        vim.keymap.set("n", "r", api.tree.reload, opts("Refresh"))
        vim.keymap.set("n", "R", api.tree.reload, opts("Refresh Root"))
        vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("Change Root To Node"))
        vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Change Root To Parent"))
        vim.keymap.set("n", "yy", api.fs.copy.node, opts("Copy Node"))
        vim.keymap.set("n", "xx", api.fs.cut, opts("Cut Node"))
        vim.keymap.set("n", "pp", api.fs.paste, opts("Paste Node"))
        vim.keymap.set("n", "rn", api.fs.rename, opts("Rename Node"))
      end

      return {
        on_attach = on_attach,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = {
            enable = true,
          },
        },
        view = {
          side = "right",
          width = 32,
        },
        filters = {
          custom = {
            "\\.pyc$",
            "\\.pyo$",
            "^\\.gitignore$",
            "^\\.DS_Store$",
            "^__pycache__$",
          },
        },
        renderer = {
          group_empty = true,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
      }
    end,
  },

  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
    keys = {
      { "tb", "<cmd>AerialToggle! left<CR>", silent = true, desc = "Toggle Symbols Outline" },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      layout = {
        default_direction = "left",
        width = 26,
      },
      attach_mode = "global",
      filter_kind = {
        "Class",
        "Constant",
        "Constructor",
        "Enum",
        "EnumMember",
        "Field",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Namespace",
        "Package",
        "Property",
        "Struct",
        "Variable",
      },
    },
    config = function(_, opts)
      require("aerial").setup(opts)

      local autocmds = require("aerial.autocommands")
      local util = require("aerial.util")

      local function get_upvalue(fn, target)
        for i = 1, 8 do
          local name, value = debug.getupvalue(fn, i)
          if name == target then
            return value
          end
          if not name then
            break
          end
        end
      end

      local throttle_opts = get_upvalue(autocmds.on_enter_buffer, "opts")
      local original_on_enter = get_upvalue(autocmds.on_enter_buffer, "func")
      if type(throttle_opts) ~= "table" or type(original_on_enter) ~= "function" then
        return
      end

      -- Keep Aerial's global sidebar behavior while turning failed quit attempts
      -- back into normal Vim errors instead of Lua exceptions.
      autocmds.on_enter_buffer = util.throttle(function(...)
        local original_quit = vim.cmd.quit
        vim.cmd.quit = function(...)
          local ok, err = pcall(original_quit, ...)
          if not ok then
            local msg = tostring(err):gsub("^Vim:", "")
            vim.api.nvim_echo({ { msg, "ErrorMsg" } }, true, {})
          end
        end

        local ok, err = pcall(original_on_enter, ...)
        vim.cmd.quit = original_quit
        if not ok then
          error(err)
        end
      end, vim.deepcopy(throttle_opts))
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      {
        "<leader>i",
        function()
          vim.g.indent_guides_enabled = not vim.g.indent_guides_enabled
          if vim.g.indent_guides_enabled then
            pcall(vim.cmd, "IBLEnable")
          else
            pcall(vim.cmd, "IBLDisable")
          end
        end,
        silent = true,
        desc = "Toggle Indent Guides",
      },
    },
    config = function()
      vim.g.indent_guides_enabled = true
      require("ibl").setup({
        scope = {
          enabled = false,
        },
      })
    end,
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = "rainbow-delimiters.strategy.global",
          vim = "rainbow-delimiters.strategy.local",
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
      }
    end,
  },

  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = {
        "<C-u>",
        "<C-d>",
        "<C-b>",
        "<C-y>",
        "<C-e>",
        "zt",
        "zz",
        "zb",
      },
    },
  },
}
