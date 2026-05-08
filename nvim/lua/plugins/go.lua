return {
  {
    "tpope/vim-dispatch",
    ft = "go",
    cmd = { "Dispatch", "Make", "Start" },
    config = function()
      local function go_run()
        local file = vim.api.nvim_buf_get_name(0)
        if file == "" then
          return
        end

        local dir = vim.fs.dirname(file)
        vim.cmd("Start -dir=" .. vim.fn.fnameescape(dir) .. " go run .")
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("go_keymaps", { clear = true }),
        pattern = "go",
        callback = function(args)
          vim.keymap.set("n", "<leader>r", go_run, { buffer = args.buf, silent = true, desc = "Go Run" })
        end,
      })
    end,
  },
}
