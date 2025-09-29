return {
  'saghen/blink.cmp',
  version = '1.*',
  option = true,
  dependencies = {
    "fang2hou/blink-copilot",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },
  -- optional: provides snippets for the snippet source
  opts = {
    keymap = {
      preset = 'none',
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<C-y>'] = { 'fallback' }
      -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    snippets = { preset = 'luasnip' },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      keyword = {
        range = "full",
      },
      list = {
        selection = {
          preselect = false, -- Automatically select the first item
          auto_insert = true,
        }
      },
      accept = {
        -- experimental auto-brackets support
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
          columns = {
            { 'kind_icon' },
            { 'label',      'label_description', gap = 1 },
            { 'source_name' } -- This will show the source of completions
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
      ghost_text = {
        enabled = true,
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = {
      implementation = "prefer_rust",
      prebuilt_binaries = { download = true },
    }
  },
  opts_extend = { "sources.default" },
  config = function(_, opts)
    require("blink.cmp").setup(opts)

    vim.keymap.set("i", "<Tab>", function()
      local cmp = require("blink.cmp")
      if cmp.is_visible() then
        return cmp.select_next()
      elseif cmp.snippet_active() then
        return cmp.snippet_forward()
      else
        return "<Tab>"
      end
    end, { expr = true, noremap = true, replace_keycodes = true })

    -- Add Shift-Tab for backward navigation
    vim.keymap.set("i", "<S-Tab>", function()
      local cmp = require("blink.cmp")
      if cmp.is_visible() then
        return cmp.select_prev()
      elseif cmp.snippet_active() then
        return cmp.snippet_backward()
      else
        return "<S-Tab>"
      end
    end, { expr = true, noremap = true, replace_keycodes = true })

    -- Your existing mapping
    vim.keymap.set("i", "<C-j>", function()
      local cmp = require("blink.cmp")
      if cmp.snippet_active() then
        return ""
      else
        return "<C-j>"
      end
    end, { expr = true, noremap = true })
  end,
}
