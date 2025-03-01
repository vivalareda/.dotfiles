return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mxsdev/nvim-dap-vscode-js",
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    dapui.setup {
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 1 },
          },
          size = 10,
          position = "bottom",
        },
      },
    }

    -- Auto-open/close DAP UI
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

    -- Keybindings
    vim.keymap.set("n", "<leader>dt", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<leader>dc", dap.continue, {})

    require("dap-vscode-js").setup {
      debugger_path = vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter",
      adapters = { "pwa-node" },
    }

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

    for _, language in ipairs(js_filetypes) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Node.js File",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          console = "integratedTerminal",
          runtimeArgs = { "--inspect-brk" },
          sourceMaps = true,
          skipFiles = { "<node_internals>/**" },
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Node.js Process",
          processId = require("dap.utils").pick_process,
          cwd = vim.fn.getcwd(),
        },
      }
    end
  end,
}
