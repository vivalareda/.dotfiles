return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag", -- Autotag dependency
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup {
        modules = {}, -- Placeholder to avoid warning
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
        auto_install = true, -- Automatically install missing parsers

        indent = { enable = true },
        highlight = {
          enable = true, -- Enable syntax highlighting
          use_languagetree = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "ss", -- Start incremental selection
            node_incremental = "es", -- Increment to the next node
            scope_incremental = "ef", -- Increment to the next scope (e.g., function or class)
            node_decremental = "ds", -- Decrement selection
          },
        },
        textobjects = {
          swap = {
            enable = false,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          -- select = {
          --   enable = true,
          --   lookahead = true,
          --   keymaps = {
          --     ["ae"] = { query = "@assignment.outer", desc = "Select assignment with the declaration" },
          --     ["ie"] = { query = "@assignment.inner", desc = "Select assignment without the declaration" },
          --     ["le"] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
          --     ["re"] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
          --
          --     ["ap"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
          --     ["ip"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
          --
          --     ["ai"] = { query = "@conditional.outer", desc = "Select outer part of a conditional" },
          --     ["ii"] = { query = "@conditional.inner", desc = "Select inner part of a conditional" },
          --
          --     ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
          --     ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
          --
          --     ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
          --     ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
          --
          --     ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
          --     ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },
          --
          --     ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
          --     ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
          --   },
          -- },
        },
      }

      -- Separate setup for nvim-ts-autotag
      require("nvim-ts-autotag").setup {
        filetypes = {
          "html",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "svelte",
          "vue",
          "tsx",
          "jsx",
          "rescript",
          "css",
          "lua",
          "xml",
          "php",
          "markdown",
        },
      }
    end,
  },
}
