return {
  {
    "github/copilot.vim",
    event = "VeryLazy",
    init = function()
      vim.g.copilot_enabled = 0
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_no_maps = true
    end,
    config = function()
      -- Disable ALL inline suggestions
      vim.g.copilot_enabled = 0

      -- Disable the default tab map
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_no_maps = true -- Add this line

      -- Set workspace folders for better context in chat
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          local root = vim.fn.finddir(".git/..", vim.fn.expand("%:p:h") .. ";")
          if root == "" then
            root = vim.fn.expand("%:p:h")
          end
          vim.g.copilot_workspace_folders = { root }
        end,
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    event = "VeryLazy",
    keys = {
      {
        "<C-p>",
        function()
          require("CopilotChat").toggle()
        end,
        mode = "n",
        desc = "Toggle Copilot chat",
      },
      {
        "<leader>cpp",
        function()
          require("CopilotChat").select_prompt()
        end,
        mode = { "n", "v" },
        desc = "Select CopilotChat prompt",
      },
      {
        "<leader>cpa",
        function()
          local input = vim.fn.input("What's the question: ")
          if input ~= "" then
            require("CopilotChat").ask(input, {
              selection = require("CopilotChat.select").buffer
            })
          end
        end,
        desc = "Copilot Quick Chat",
      },
    },
    opts = {
      model = 'claude-opus-4.5',
      temperature = 0.1,

      window = {
        layout = 'vertical', -- vertical split
        width = 0.33,        -- 33% of screen width (1/3)
        height = 1,          -- full height
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")

      chat.setup(vim.tbl_deep_extend("force", opts, {
        model = 'claude-sonnet-4.5',
        temperature = 0.1,
        prompts = {
          DiagnosticError = {
            prompt =
            "This line of code has an error, based on the file and the message, fix the error. If the fix is a quick fix please provide the missing character",
            description = "Fix diagnostic error",
            selection = select.visual,
          },
          InDepthDiagnostic = {
            prompt =
            "This line of code has an error, I need you to explain the error. I don't want you to just fix it, explain the error in depth and how the solution solves the issue",
            description = "Fix in depth diagnostic error",
            selection = select.visual,
          },
          FixBloc = {
            prompt =
            "This block of code has an error, fix the error and give me back only the fixed block without line numbers so that I can directly replace it in the file",
            description = "Fix block error",
            selection = select.visual,
          },
          FeatureRequest = {
            prompt =
            "I need you to implement a feature. You will give back the code unchanged other than what is needed to implement the feature. No line numbers, just the code so that I can directly replace it in the file",
            description = "Implement feature",
            selection = select.visual,
          },
        },
        mappings = {
          reset = {
            normal = "<C-t>",
          },
        },
      }))
    end,
  },
}
