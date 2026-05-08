return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
    },
    keys = function()
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      local function find_word_in_split()
        builtin.find_files({
          hidden = true,
          default_text = vim.fn.expand("<cword>"),
          attach_mappings = function(_, _)
            actions.select_default:replace(actions.select_horizontal)
            return true
          end,
        })
      end

      local function local_files()
        local cwd = vim.fn.expand("%:p:h")
        if cwd == "" then
          cwd = vim.loop.cwd()
        end

        builtin.find_files({
          cwd = cwd,
          hidden = true,
        })
      end

      local function project_search()
        local word = vim.fn.expand("<cword>")
        local opts = {
          default_text = word ~= nil and word or "",
        }

        if vim.api.nvim_get_mode().mode:sub(1, 1) == "i" then
          vim.cmd.stopinsert()
          vim.schedule(function()
            builtin.live_grep(opts)
          end)
          return
        end

        builtin.live_grep(opts)
      end

      return {
        { "<C-f>", project_search, mode = { "n", "i" }, silent = true, desc = "Live Grep Project" },
        { "<leader>b", builtin.buffers, silent = true, desc = "Find Buffers" },
        { "<leader>f", function() builtin.find_files({ hidden = true }) end, silent = true, desc = "Find Files" },
        { "<leader>F", local_files, silent = true, desc = "Find Files In Buffer Dir" },
        { "gf", find_word_in_split, silent = true, desc = "Find File Under Cursor" },
      }
    end,
    opts = {
      defaults = {
        file_ignore_patterns = {
          "^.git/",
          "node_modules/",
          "%.pyc$",
          "%.pyo$",
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
}
