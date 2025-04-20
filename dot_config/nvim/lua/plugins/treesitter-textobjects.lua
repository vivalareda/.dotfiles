return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "javascript", "typescript", "lua", "python", "rust", "go" },
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = { query = "@function.outer", desc = "Select function" },

            ["aa"] = { query = "@assignment.outer", desc = "Select assignment with the declaration" },
            ["ia"] = { query = "@assignment.inner", desc = "Select assignment without the declaration" },

            ["le"] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
            ["re"] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
          },
        },
      },
    }
  end,
}
