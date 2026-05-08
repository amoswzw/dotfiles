return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1,
      request_timeout = 2.5,
      throttle = 1500,
      debounce = 600,
      cmp = {
        enable_auto_complete = true,
      },
      provider_options = {
        openai_fim_compatible = {
          api_key = "DEEPSEEK_API_KEY",
          end_point = "https://api.deepseek.com/beta/completions",
          model = "deepseek-v4-flash",
          name = "deepseek",
          optional = {
            max_tokens = 256,
            top_p = 0.9,
          },
        },
      },
    },
    config = function(_, opts)
      require("minuet").setup(opts)
    end,
  },
}
