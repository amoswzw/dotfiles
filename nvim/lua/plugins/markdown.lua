local function split_width()
  return math.max(88, math.floor(vim.o.columns * 0.5))
end

local function github_markdown_css()
  return vim.fs.normalize(vim.fn.stdpath("config") .. "/styles/github-markdown.css")
end

local function set_markdown_highlights()
  vim.api.nvim_set_hl(0, "MarkviewGithubH1", { fg = "#f0dfaf", bg = "#3a3a39", bold = true })
  vim.api.nvim_set_hl(0, "MarkviewGithubH2", { fg = "#efefaf", bg = "#2f2f2f", bold = true, underline = true })
  vim.api.nvim_set_hl(0, "MarkviewGithubH3", { fg = "#dfbf8f", bold = true })
  vim.api.nvim_set_hl(0, "MarkviewGithubH4", { fg = "#d7cfa5", bold = true })
  vim.api.nvim_set_hl(0, "MarkviewGithubH5", { fg = "#bfbfbf", bold = true })
  vim.api.nvim_set_hl(0, "MarkviewGithubH6", { fg = "#8f8f8f", italic = true })
  vim.api.nvim_set_hl(0, "MarkviewGithubBorder1", { fg = "#5f7f5f" })
  vim.api.nvim_set_hl(0, "MarkviewGithubBorder2", { fg = "#4f6f4f" })
end

local function style_preview_window(win)
  if not win or not vim.api.nvim_win_is_valid(win) then
    return
  end

  local wo = vim.wo[win]

  wo.number = false
  wo.relativenumber = false
  wo.signcolumn = "no"
  wo.foldcolumn = "0"
  wo.statuscolumn = ""
  wo.cursorline = false
  wo.wrap = false
  wo.linebreak = false
  wo.breakindent = false
  wo.list = false
  wo.spell = false
  wo.colorcolumn = ""
  wo.winfixwidth = true
  wo.conceallevel = 3
  wo.concealcursor = "n"
  wo.fillchars = "eob: "

  pcall(vim.api.nvim_win_set_width, win, split_width())

  local ok = pcall(vim.api.nvim_get_hl, 0, { name = "NormalFloat", link = false })
  if ok then
    wo.winhighlight = table.concat({
      "Normal:NormalFloat",
      "EndOfBuffer:NormalFloat",
      "SignColumn:NormalFloat",
    }, ",")
  end
end

return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    priority = 900,
    main = "markview",
    keys = {
      { "<leader>mp", "<cmd>Markview splitToggle<CR>", silent = true, desc = "Toggle Native Markdown Preview" },
    },
    opts = function()
      local presets = require("markview.presets")

      return {
        preview = {
          debounce = 60,
          icon_provider = "devicons",
          splitview_winopts = {
            split = "right",
            width = split_width(),
          },
          callbacks = {
            on_splitview_open = function(_, _, win)
              style_preview_window(win)
            end,
          },
        },
        markdown = {
          headings = {
            enable = true,
            shift_width = 0,

            heading_1 = { style = "simple", hl = "MarkviewGithubH1" },
            heading_2 = { style = "simple", hl = "MarkviewGithubH2" },
            heading_3 = { style = "simple", hl = "MarkviewGithubH3" },
            heading_4 = { style = "simple", hl = "MarkviewGithubH4" },
            heading_5 = { style = "simple", hl = "MarkviewGithubH5" },
            heading_6 = { style = "simple", hl = "MarkviewGithubH6" },

            setext_1 = {
              style = "decorated",
              hl = "MarkviewGithubH1",
              border = "─",
              border_hl = "MarkviewGithubBorder1",
            },
            setext_2 = {
              style = "decorated",
              hl = "MarkviewGithubH2",
              border = "─",
              border_hl = "MarkviewGithubBorder2",
            },
          },
          block_quotes = presets.block_quotes.obsidian,
          horizontal_rules = presets.horizontal_rules.thin,
          tables = presets.tables.single,
          code_blocks = {
            enable = true,
            style = "block",
            sign = true,
            label_direction = "right",
            min_width = 64,
            pad_amount = 2,
          },
        },
        markdown_inline = {
          checkboxes = presets.checkboxes.nerd,
          inline_codes = {
            enable = true,
            virtual = true,
            padding_left = " ",
            padding_right = " ",
          },
        },
      }
    end,
    config = function(_, opts)
      set_markdown_highlights()
      require("markview").setup(opts)

      local group = vim.api.nvim_create_augroup("markdown_split_preview", { clear = true })
      local actions = require("markview.actions")

      local function close_splitview()
        local ok, state = pcall(require, "markview.state")
        if not ok or not state.get_splitview_source() then
          return
        end

        pcall(actions.splitClose)
      end

      local function open_splitview(bufnr)
        if vim.bo[bufnr].buftype ~= "" or vim.bo[bufnr].filetype ~= "markdown" then
          return
        end

        if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].filetype ~= "markdown" then
          return
        end

        if vim.api.nvim_get_current_buf() ~= bufnr then
          return
        end

        pcall(actions.splitOpen, bufnr)
      end

      local function queue_open_splitview(bufnr)
        vim.schedule(function()
          open_splitview(bufnr)
        end)
      end

      local function resize_splitview()
        local ok, state = pcall(require, "markview.state")
        if not ok then
          return
        end

        local win = state.get_splitview_window({}, false)
        if win and vim.api.nvim_win_is_valid(win) then
          style_preview_window(win)
        end
      end

      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        callback = function(args)
          if vim.bo[args.buf].filetype == "markdown" then
            queue_open_splitview(args.buf)
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        callback = function(args)
          if vim.bo[args.buf].filetype == "markdown" then
            queue_open_splitview(args.buf)
            return
          end

          vim.schedule(close_splitview)
        end,
      })

      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = function()
          queue_open_splitview(vim.api.nvim_get_current_buf())
        end,
      })

      vim.api.nvim_create_autocmd("VimResized", {
        group = group,
        callback = resize_splitview,
      })

      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(0) then
          queue_open_splitview(vim.api.nvim_get_current_buf())
        end
      end)
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>mP", "<cmd>MarkdownPreviewToggle<CR>", silent = true, desc = "Toggle GitHub Browser Preview" },
      { "<leader>mO", "<cmd>MarkdownPreview<CR>", silent = true, desc = "Open GitHub Browser Preview" },
      { "<leader>mS", "<cmd>MarkdownPreviewStop<CR>", silent = true, desc = "Stop GitHub Browser Preview" },
    },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_markdown_css = github_markdown_css()
      vim.g.mkdp_page_title = "${name} · GitHub Preview"
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "relative",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 1,
        toc = {},
      }
      vim.g.mkdp_combine_preview = 1
      vim.g.mkdp_combine_preview_auto_refresh = 1
    end,
  },
}
