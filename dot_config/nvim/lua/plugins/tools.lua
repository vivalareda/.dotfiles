-- Filing, themes, dashboards and small standalone tools.

return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {},
    keys = {
      { "<leader>oo", "<cmd>Oil<cr>", desc = "Open Oil" },
    },
  },

  {
    "vivalareda/maple.nvim",
    opts = {
      relative_number = true,
      keymaps = {
        toggle = "<leader>m",
        close = "q",
        switch_mode = "m",
      },
    },
  },

  {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = false,
      auto_restore_last_session = false,
    },
  },

  {
    "emrearmagan/atlas.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "esmuellert/codediff.nvim",
      "sindrets/diffview.nvim",
    },
    opts = {
      providers = { github = {} },
    },
  },

  { "chomosuke/typst-preview.nvim", lazy = false, version = "1.*", opts = {} },

  { "nvzone/typr", dependencies = "nvzone/volt", opts = {}, cmd = { "Typr", "TyprStats" } },

  {
    "typed-rocks/ts-worksheet-neovim",
    config = function()
      require("tsw").setup({ severity = vim.diagnostic.severity.WARN })

      local enabled = false
      local function toggle()
        enabled = not enabled
        if enabled then
          vim.cmd("Tsw")
          vim.api.nvim_create_autocmd("BufWritePost", {
            group = vim.api.nvim_create_augroup("TswAutoRun", { clear = true }),
            pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
            callback = function()
              vim.cmd("Tsw")
            end,
          })
        else
          vim.api.nvim_create_augroup("TswAutoRun", { clear = true })
          vim.diagnostic.reset()
        end
      end

      vim.keymap.set("n", "<leader>tw", toggle, { desc = "Toggle TS worksheet" })
    end,
  },

  {
    "nemanjamalesija/ts-expand-hover.nvim",
    ft = { "typescript", "typescriptreact" },
    opts = { keymaps = { hover = "<leader>th" } },
  },

  { "dmmulroy/ts-error-translator.nvim", opts = {} },

  -- Bun debugging for the current JS/TS file.
  {
    "mfussenegger/nvim-dap",
    init = function()
      LazyVim.on_load("nvim-dap", function()
        local dap = require("dap")
        dap.adapters.bun = { type = "server", host = "127.0.0.1", port = 6499 }
        dap.configurations.javascript = {
          {
            type = "bun",
            request = "launch",
            name = "Launch current file with Bun",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "bun",
            runtimeArgs = { "run" },
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
        }
        dap.configurations.typescript = dap.configurations.javascript
      end)
    end,
    keys = {
      { "<leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dn", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dv", function() require("dap").step_over() end, desc = "Step over" },
    },
  },
}
