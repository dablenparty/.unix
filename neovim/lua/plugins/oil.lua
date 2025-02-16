return {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  keys = {
    {
      '-',
      function()
        vim.cmd 'Oil'
      end,
      mode = 'n',
      desc = 'Open parent directory in Oil',
    },
  },

  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
    }
  },
}
