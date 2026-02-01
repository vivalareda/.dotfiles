return {
  "rcarriga/nvim-dap-ui",
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", "williamboman/mason.nvim", "jay-babu/mason-nvim-dap.nvim" },
  config = function()
    require("mason").setup()
    require("mason-nvim-dap").setup({
      ensure_installed = { "node" },
      automatic_installation = true,
    })
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup()
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    dap.configurations.javascript = {
      {
        type = "bun",
        request = "launch",
        program = "${file}",
        runtimeExecutable = "bun",
        runtimeArgs = { "run" },
        skipFiles = { "<node_internals>/**", "node_modules/**" },
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      }
    }
    dap.configurations.typescript = dap.configurations.javascript
    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, { desc = "add breakpoint" })
    vim.keymap.set("n", "<leader>dc", dap.continue, {})
    vim.keymap.set("n", "<leader>dn", dap.step_over, {})
    vim.keymap.set("n", "<leader>di", dap.step_into, {})
    vim.keymap.set("n", "<leader>do", dap.step_out, {})
  end
}
