return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit" },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<CR>", silent = true, desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<CR>", silent = true, desc = "LazyGit Current File" },
      { "<leader>gh", "<cmd>LazyGitFilterCurrentFile<CR>", silent = true, desc = "LazyGit File History" },
      { "<leader>gH", "<cmd>LazyGitFilter<CR>", silent = true, desc = "LazyGit Repo History" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    init = function()
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      vim.g.lazygit_floating_window_use_plenary = 1
      vim.g.lazygit_use_neovim_remote = 1
    end,
  },

  {
    "tpope/vim-dispatch",
    cmd = { "Dispatch", "Make", "Start" },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}
