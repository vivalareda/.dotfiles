-- Completion. Kept on blink.cmp's main branch because this config relies on
-- its newest keymap/source behaviour.
return {
  {
    "saghen/blink.cmp",
    branch = "main",
    build = "cargo build --release",
    dependencies = {
      "saghen/blink.lib",
      "fang2hou/blink-copilot",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts_extend = { "sources.default" },
    opts = {
      keymap = {
        -- "none" on purpose: Tab belongs to util/tabout, and enter accepts.
        preset = "none",
        ["<C-k>"] = { "show", "select_prev" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-y>"] = { "fallback" },
      },

      cmdline = {
        keymap = {
          preset = "cmdline",
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
        },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      snippets = { preset = "luasnip" },

      completion = {
        keyword = { range = "prefix" },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        accept = {
          auto_brackets = { enabled = true },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
          },
        },
        documentation = {
          auto_show = false,
        },
        ghost_text = { enabled = true },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot" },
        providers = {
          lsp = {
            async = true,
            timeout_ms = 2000,
            fallback = {},
          },
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },

      fuzzy = { implementation = "prefer_rust" },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
    end,
  },
}
