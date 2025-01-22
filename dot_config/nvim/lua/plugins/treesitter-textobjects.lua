return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = true,
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "javascript", "typescript" },
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["aa"] = { query = "@assignment.outer", desc = "Select assignment with the declaration" },
            ["ia"] = { query = "@assignment.inner", desc = "Select assignment without the declaration" },
            ["la"] = { query = "@assignment.lhs", desc = "Select left hand side of an assignment" },
            ["ra"] = { query = "@assignment.rhs", desc = "Select right hand side of an assignment" },
          },
        },
      },
    }
  end,
}
