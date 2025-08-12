return {
  "mfussenegger/nvim-lint",
  event = { 
    "BufWritePost",
    "BufEnter",
    "BufNewFile" 
  },
  config = function()
    require("lint").linters_by_ft = {
      javascript = { "biomejs" },
      typescript = { "biomejs" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
      group = lint_augroup,
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
