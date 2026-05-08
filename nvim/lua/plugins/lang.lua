return {
  {
    "uarun/vim-protobuf",
    ft = "proto",
  },

  {
    "rizzatti/dash.vim",
    cond = function()
      return vim.fn.has("mac") == 1
    end,
    cmd = { "Dash", "DashKeywords" },
  },
}
