return {
  'sainnhe/everforest',
  priority = 1000,
  lazy = true,
  init = function()
    -- add config here, without the "everforest_" prefix
    local opts = {
      enable_italic = true,
      background = 'hard',
      -- not sure if this works on Windows, so disable it there
      transparent_background = not vim.uv.os_uname().version:match 'Windows',
      float_style = 'dim',
      diagnostic_text_highlight = 1,
      diagnostic_virtual_text = 'highlight',
    }

    -- apply globals
    for k, v in pairs(opts) do
      local gkey = string.format('everforest_%s', k)
      vim.g[gkey] = v
    end
  end,
}
