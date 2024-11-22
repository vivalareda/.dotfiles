return {
  "phaazon/hop.nvim",
  branch = "v2", -- Use the v2 branch for the latest stable version
  config = function()
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    hop.setup({
      keys = "etovxqpdygfblzhckisuran",
    })

    -- Forward jump to a single character
    vim.keymap.set("n", "f", function()
      hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end, { remap = true, desc = "Hop: Forward to character" })

    -- Backward jump to a single character
    vim.keymap.set("n", "F", function()
      hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, { remap = true, desc = "Hop: Backward to character" })
  end,
}

