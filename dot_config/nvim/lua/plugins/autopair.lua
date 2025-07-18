return {
  'windwp/nvim-autopairs',
  event = { 'InsertEnter' },
  config = function()
    -- Start by requiring the nvim-autopairs plugin
    local autopairs = require 'nvim-autopairs'

    -- Configure nvim-autopairs
    autopairs.setup {
      check_ts = true,                      -- Enable Tree-sitter integration for smarter pairing
      ts_config = {                         -- Tree-sitter configuration for specific languages
        lua = { 'string' },                 -- Disable pairs in Lua strings
        javascript = { 'template_string' }, -- Disable pairs in JavaScript template literals
        java = false,                       -- Disable Tree-sitter checks for Java
      },
    }
  end,
}
