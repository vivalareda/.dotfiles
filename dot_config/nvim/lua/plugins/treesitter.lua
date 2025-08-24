return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "OXY2DEV/markview.nvim",
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        modules = {},        -- Placeholder to avoid warning
        ignore_install = {}, -- Empty table if you don't want to ignore any parsers
        ensure_installed = {
          "json",
          "javascript",
          "typescript",
          "tsx",
          "yaml",
          "html",
          "css",
          "prisma",
          "markdown",
          "markdown_inline",
          "svelte",
          "graphql",
          "bash",
          "lua",
          "vim",
          "dockerfile",
          "gitignore",
          "query",
          "vimdoc",
          "c",
        },
        sync_install = false, -- Install languages asynchronously
        auto_install = true,  -- Automatically install missing parsers

        indent = { enable = true },
        highlight = {
          enable = true, -- Enable syntax highlighting
          use_languagetree = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "st",    -- Start incremental selection
            node_incremental = "es",  -- Increment to the next node
            scope_incremental = "ef", -- Increment to the next scope (e.g., function or class)
            node_decremental = "ds",  -- Decrement selection
          },
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner"
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.inner"
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner"
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.inner"
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      }
    end,
  },
}
