return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio', -- Required by dap-ui
  },
  lazy = true,
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    -- Setup dap-ui
    dapui.setup()

    -- Automatically open/close dap-ui when debugging starts/stops
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    dap.adapters.bun = {
      type = 'server',
      host = '127.0.0.1',
      port = 6499,
    }

    dap.configurations.typescript = {
      {
        type = 'bun',
        request = 'launch',
        name = 'Launch Bun Test',
        program = '${file}',
        cwd = '${workspaceFolder}',
        runtimeExecutable = 'bun',
        runtimeArgs = { '--inspect-wait=127.0.0.1:6499', 'test', '${file}' },
        console = 'integratedTerminal',
      },
    }

    -- Keybindings with leader
    vim.keymap.set('n', '<Leader>dc', function() dap.continue() end, { desc = 'Debug: Continue' })
    vim.keymap.set('n', '<Leader>dv', function() dap.step_over() end, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<Leader>di', function() dap.step_into() end, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<Leader>do', function() dap.step_out() end, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<Leader>du', function() dapui.toggle() end, { desc = 'Debug: Toggle UI' })
  end,
}
