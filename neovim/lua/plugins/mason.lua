-- See `:help lspconfig-all` for a list of all the pre-configured LSPs
local servers = {
  basedpyright = {},
  bashls = { filetypes = { 'sh', 'zsh' } },
  dockerls = {},
  docker_compose_language_service = {},
  lua_ls = {
    -- other keys
    -- cmd = {...},
    -- filetypes = { ...},
    -- capabilities = {},
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  },
  marksman = {},
}

return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      { "williamboman/mason.nvim", opts = {} },
      {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        opts = function(_, opts)
          opts = opts or {}
          local formatters = { 'prettier', 'shfmt', 'stylua' }
          local linters = { 'hadolint', 'markdownlint-cli2', 'shellcheck' }

          local ensure_installed = vim.tbl_keys(servers)
          vim.list_extend(ensure_installed, formatters)
          vim.list_extend(ensure_installed, linters)
          opts.ensure_installed = ensure_installed

          return opts
        end,
      },
      -- Useful status update notifications for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
    },

    opts = {
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = 'if_many',
          prefix = '●',
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
      },
      automatic_installation = true,
      ensure_installed = {},
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          require('lspconfig')[server_name].setup(server)
        end,
        ['rust-analyzer'] = function() end,
      }
    },
}
