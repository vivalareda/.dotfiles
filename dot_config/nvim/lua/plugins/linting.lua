return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require "lint"

    lint.linters_by_ft = {
      python = { "mypy" },
    }

    -- Override pylint linter configuration
    -- lint.linters.pylint = {
    --   cmd = "pylint",
    --   args = {
    --     "--disable=C0111,C0103,C0301,E0401,C0303",
    --     "--output-format=text",
    --   },
    --   stdin = false,
    --   stream = "stdout",
    --   ignore_exitcode = true,
    -- }

    lint.linters.flake8 = {
      cmd = "flake8",
      args = { "--max-line-length=120" }, -- Increase line length limit
      stdin = false, -- Flake8 does not require stdin
    }

    -- Create autocommands for linting
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
