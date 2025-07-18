return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = false,
        keymap = {
          accept = "jk",
        }
      },
      panel = {
        enabled = false
      },
      filetypes = {
        markdown = true,
        help = true,
      },
    }
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
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
      window = {
        layout = "float",
        width = 0.4,
        height = 0.4,
        border = "rounded",
      },
    },

    config = function(_, opts)
      local chat = require "CopilotChat"
      local select = require "CopilotChat.select"
      vim.g.copilot_no_tab_map = true

      local function ToggleCopilot()
        local is_disabled = require("copilot.client").is_disabled()

        if is_disabled then
          vim.cmd "Copilot enable"
          print "Copilot enabled"
        else
          vim.cmd "Copilot disable"
          print "Copilot disabled"
        end
      end

      vim.keymap.set("n", "<leader>cpt", ToggleCopilot, { desc = "Toggle Copilot", noremap = true, silent = true })

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
        prompts = {
          DiagnosticError = {
            selection = select.visual,
            prompt =
            "This line of code has an error, based on the file and the message, fix the error. If the fix is a quick fix please provid the missing character",
            description = "Fix diagnostic error",
            context = "file",
          },
          InDepthDiagnostic = {
            selection = select.visual,
            prompt =
            "This line of code has an error, I need you to explain the error. I don't want you to just fix it, explain the error in depth and how the solution solves the issue",
            description = "Fix in depth diagnostic error",
            context = "file",
          },
          FixBloc = {
            selection = select.visual,
            prompt =
            "This block of code has an error, fix the error and give me back only the fixed block without line Expression so that I can directly replace it in the file",
            description = "Fix block error",
            context = "file",
          },
          FeatureRequest = {
            selection = select.visual,
            prompt =
            "I need you to implement a feature. You will give back the code unchanged other than what is needed to implement the feature. No line Expression, just the code so that I can directly replace it in the file",
            description = "Implement feature",
            context = "file",
          },
        },
        mappings = {
          reset = {
            normal = "<C-t>",
          },
        },
        -- window = {
        --   layout = "float",
        --   width = 1,
        --   height = 0.4,
        -- },
      }))
    end,
  },
}
