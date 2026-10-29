-- Editing plugins and overrides of LazyVim's editing defaults.

return {
  -- nvim-autopairs replaces mini.pairs so pairing can be treesitter aware.
  { "nvim-mini/mini.pairs", enabled = false },
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string" },
        javascript = { "template_string" },
        java = false,
      },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = false,
        enable_close_on_slash = true,
      },
    },
  },

  -- f is function-shaped here, including lexical declarations.
  {
    "nvim-mini/mini.ai",
    opts = function(_, opts)
      opts.custom_textobjects = opts.custom_textobjects or {}
      opts.custom_textobjects.f = require("mini.ai").gen_spec.treesitter({
        a = { "@function.outer", "@lexical_declaration.outer" },
        i = { "@function.inner", "@lexical_declaration.inner" },
      })
      return opts
    end,
  },

  {
    "nvim-mini/mini.icons",
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
  },

  {
    "kylechui/nvim-surround",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    opts = {},
  },

  { "m-demare/hlargs.nvim", opts = {} },

  -- Highlight the current chunk (function/block) with a colored line.
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local function setup()
        require("hlchunk").setup({
          chunk = {
            enable = true,
            style = {
              { fg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Comment")), "fg", "gui") },
            },
          },
        })
      end
      setup()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = setup })
    end,
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = function()
      return {
        markdown = { headings = require("markview.presets").headings.glow },
        experimental = { check_rtp_message = false },
      }
    end,
  },

  { "nemanjamalesija/smart-paste.nvim", event = "VeryLazy", config = true },

  {
    "aznhe21/actions-preview.nvim",
    keys = {
      { "<leader>sa", function() require("actions-preview").code_actions() end, mode = { "n", "v" }, desc = "Code actions" },
    },
  },

  -- w/e/b jump over camelCase and snake_case words.
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
      { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
      { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
      { "ge", "<cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" } },
    },
  },

  -- f/F/t/T move to the labelled character on the current line.
  {
    "smoka7/hop.nvim",
    version = "*",
    config = function()
      local hop = require("hop")
      local directions = require("hop.hint").HintDirection

      hop.setup({
        keys = "etovxqpdygfblzhckisuran",
        teledebug = false,
        multi_windows = true,
      })

      local function hint(direction, hint_offset)
        return function()
          hop.hint_char1({
            direction = direction,
            current_line_only = true,
            hint_offset = hint_offset,
          })
        end
      end

      vim.keymap.set("", "f", hint(directions.AFTER_CURSOR), { remap = true, desc = "Hop char after" })
      vim.keymap.set("", "F", hint(directions.BEFORE_CURSOR), { remap = true, desc = "Hop char before" })
      vim.keymap.set("", "t", hint(directions.AFTER_CURSOR, -1), { remap = true, desc = "Hop until after" })
      vim.keymap.set("", "T", hint(directions.BEFORE_CURSOR, 1), { remap = true, desc = "Hop until before" })
    end,
  },

  -- Flash keeps LazyVim's bindings but does not take over f/t.
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = { enabled = false },
      },
    },
  },

  -- LazyVim enables a bufferline (tabs) at the top. This config uses
  -- telescope/fzf for buffer switching instead, so drop the tabline.
  { "akinsho/bufferline.nvim", enabled = false },

  -- Ctrl-hjkl move between tmux panes and Neovim windows.
  -- The mappings live in config/keymaps.lua so they win over LazyVim's window maps.
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
  },
}
