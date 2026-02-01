return {
  'phaazon/hop.nvim',
  branch = 'v2', -- optional but strongly recommended
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require 'hop'.setup {
      keys = 'etovxqpdygfblzhckisuran',
      teledebug = false,
      multi_windows = true,
    }

    vim.api.nvim_set_hl(0, 'HopNextKey', { fg = '#ff007c', bold = true })
    vim.api.nvim_set_hl(0, 'HopNextKey1', { fg = '#00dfff', bold = true })
    vim.api.nvim_set_hl(0, 'HopNextKey2', { fg = '#2b8db3' })
    vim.api.nvim_set_hl(0, 'HopUnmatched', { fg = '#666666' })

    local hop = require('hop')
    local directions = require('hop.hint').HintDirection
    vim.keymap.set('', 'f', function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end, { remap = true })
    vim.keymap.set('', 'F', function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, { remap = true })
    vim.keymap.set('', 't', function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    end, { remap = true })
    vim.keymap.set('', 'T', function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    end, { remap = true })
  end
}
