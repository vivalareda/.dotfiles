-- AI helpers. Inline suggestions stay off for Copilot; NeoCodeium handles those.
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
      vim.g.copilot_enabled = 0
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_no_maps = true

      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("UserCopilotWorkspace", {}),
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
              selection = require("CopilotChat.select").buffer,
            })
          end
        end,
        desc = "Copilot quick chat",
      },
    },
    config = function()
      local chat = require("CopilotChat")
      local select = require("CopilotChat.select")

      chat.setup({
        model = "claude-sonnet-4.5",
        temperature = 0.1,
        window = {
          layout = "vertical",
          width = 0.33,
          height = 1,
        },
        prompts = {
          DiagnosticError = {
            prompt = "This line of code has an error, based on the file and the message, fix the error. If the fix is a quick fix please provide the missing character",
            description = "Fix diagnostic error",
            selection = select.visual,
          },
          InDepthDiagnostic = {
            prompt = "This line of code has an error, I need you to explain the error. I don't want you to just fix it, explain the error in depth and how the solution solves the issue",
            description = "Fix in depth diagnostic error",
            selection = select.visual,
          },
          FixBloc = {
            prompt = "This block of code has an error, fix the error and give me back only the fixed block without line numbers so that I can directly replace it in the file",
            description = "Fix block error",
            selection = select.visual,
          },
          FeatureRequest = {
            prompt = "I need you to implement a feature. You will give back the code unchanged other than what is needed to implement the feature. No line numbers, just the code so that I can directly replace it in the file",
            description = "Implement feature",
            selection = select.visual,
          },
        },
        mappings = {
          reset = { normal = "<C-t>" },
        },
      })
    end,
  },

  {
    "monkoose/neocodeium",
    event = "VeryLazy",
    keys = {
      { "<C-l>", function() require("neocodeium").accept() end, mode = "i", desc = "Accept AI suggestion" },
      { "<leader>ts", "<cmd>NeoCodeium toggle<cr>", desc = "Toggle NeoCodeium" },
    },
    opts = { show_label = false },
  },
}
