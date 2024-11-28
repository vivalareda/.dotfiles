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
        "<leader>cp",
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
          print("Updated Copilot workspace to:", root)
        end,
      })

      chat.setup(vim.tbl_deep_extend("force", opts, {
        prompts = {
          ChatRename = {
            selection = select.visual,
            prompt = "Rename the selected identifier to be more concise, readable, understandable and maintainable.",
            description = "Rename the identifier",
            context = "buffer",
          },
          ChatRefactor = {
            selection = select.visual,
            prompt = "/COPILOT_GENERATE Refactor the following code to improve its clarity, readability and maintainability.",
            description = "Refactor the code",
            context = "buffer",
          },
          ChatWithVisual = {
            selection = select.visual,
            description = "Ask Copilot to help with the selected code.",
            context = "buffer",
          },
          ChatInline = {
            selection = select.visual,
            description = "Ask Copilot to help with the selected code in a floating window.",
            context = "buffer",
          },
          ChatQuestion = {
            prompt = "Answer the following question in a simple and concise manner:",
            description = "Ask Copilot a simple question",
            context = "buffer",
          },
          Commit = {
            prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
            selection = select.gitdiff,
          },
          CommitStaged = {
            prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
            selection = function(source)
              return select.gitdiff(source, true)
            end,
          },
          Summarize = {
            prompt = "Summarize the following text.",
            description = "Summarize the text",
            context = "buffer",
          },
          Spelling = {
            prompt = "/COPILOT_GENERATE Correct any grammar and spelling errors in the following text.",
            description = "Correct spelling and grammar",
            context = "buffer",
          },
          Wording = {
            prompt = "/COPILOT_GENERATE Improve the grammar and wording of the following text.",
            description = "Improve grammar and wording",
            context = "buffer",
          },
          Concise = {
            prompt = "/COPILOT_GENERATE Rewrite the following text to make it more concise.",
            description = "Make the text more concise",
            context = "buffer",
          },
        },
        window = {
          height = 0.3, -- 30% of screen height
          width = 0.3, -- 60% of screen width
        },
      }))
    end,
  },
}
