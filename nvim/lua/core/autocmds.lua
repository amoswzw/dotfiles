local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

local project_markers = {
  ".git",
  ".hg",
  "go.mod",
  "Cargo.toml",
  "package.json",
  "tsconfig.json",
  "jsconfig.json",
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "requirements.txt",
  "Makefile",
  ".luarc.json",
  ".luarc.jsonc",
  "stylua.toml",
}

local function project_root(path)
  local root = vim.fs.root(path, project_markers)
  if root then
    return root
  end
  return vim.fs.dirname(path)
end

vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("restore_cursor"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 1 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup("project_root"),
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    local file = vim.api.nvim_buf_get_name(args.buf)
    if file == "" or file:match("^%a[%w+.-]*://") then
      return
    end

    local root = project_root(file)
    if root and vim.fn.isdirectory(root) == 1 and vim.fn.getcwd() ~= root then
      vim.cmd.lcd(vim.fn.fnameescape(root))
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("indent_overrides"),
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("indent_overrides"),
  pattern = { "less", "json", "yaml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
