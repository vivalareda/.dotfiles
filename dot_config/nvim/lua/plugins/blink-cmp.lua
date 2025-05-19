return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  version = '1.*',
  opts = {
    keymap = {
      preset = 'none' ,
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<C-y>'] = { 'select_and_accept' },
      ['<CR>'] = { 'select_and_accept', 'fallback'},
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    snippets = { preset = 'luasnip' },

    -- (Default) Only show the documentation popup when manually triggered
    completion = { 
      list = {
        selection = {
          preselect = false,   -- Automatically select the first item
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
            { 'label', 'label_description', gap = 1 },
            { 'source_name' }  -- This will show the source of completions
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
      default = { 'lsp', 'path', 'snippets', 'buffer' },
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
    
    -- Add this custom mapping for Enter key
    vim.keymap.set("i", "<CR>", function()
      local cmp = require("blink.cmp")
      if cmp.snippet_active() then
        return cmp.select_and_accept()
      else
        return "<CR>"
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

