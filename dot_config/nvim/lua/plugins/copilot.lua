return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      { "nvim-telescope/telescope.nvim" },
    },
    event = "VeryLazy",
    keys = {
      {
        "<leader>cpp",
        function()
          local actions = require "CopilotChat.actions"
          require("CopilotChat.integrations.telescope").pick(
            actions.prompt_actions { selection = require("CopilotChat.select").visual }
          )
        end,
        mode = { "n", "v" },
        desc = "Prompt actions",
      },
      {
        "<C-p>",
        function()
          require("CopilotChat").toggle()
        end,
        mode = "n",
        desc = "Open Copilot chat",
      },
      {
        "<leader>cpa",
        function()
          local input = vim.fn.input "What's the question"
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "Copilot Quick Chat",
      },
    },

    config = function(_, opts)
      local chat = require "CopilotChat"
      local select = require "CopilotChat.select"

      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          -- Detect the project root using .git or fallback to the current directory
          local root = vim.fn.finddir(".git/..", vim.fn.expand "%:p:h" .. ";")
          if root == "" then
            root = vim.fn.expand "%:p:h" -- Fallback to the directory of the current file
          end
          vim.g.copilot_workspace_folders = { root }
        end,
      })

      chat.setup(vim.tbl_deep_extend("force", opts, {
        prompts = {},
      }))
    end,
  },
}
