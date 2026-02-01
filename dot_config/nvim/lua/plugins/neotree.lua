return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    {
      "<C-n>",
      function()
        local manager = require("neo-tree.sources.manager")
        if manager.get_state("filesystem").winid then
          require('neo-tree.command').execute({ action = "close" })
        else
          local reveal_file = vim.fn.expand('%:p')
          if (reveal_file == '') then
            reveal_file = vim.fn.getcwd()
          else
            local f = io.open(reveal_file, "r")
            if (f) then
              f.close(f)
            else
              reveal_file = vim.fn.getcwd()
            end
          end
          require('neo-tree.command').execute({
            action = "focus",
            source = "filesystem",
            position = "left",
            reveal_file = reveal_file,
            reveal_force_cwd = true,
          })
        end
      end,
      desc = "Toggle neo-tree at current file or working directory",
      silent = true
    },
  },
  opts = {
    event_handlers = {
      {
        event = "file_open_requested",
        handler = function()
          -- Auto close Neo-tree when a file is opened
          require("neo-tree.command").execute { action = "close" }
        end,
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,   -- Show dotfiles
        hide_gitignored = false, -- Show files ignored by git
      },
      window = {
        mappings = {
          ["<CR>"] = "open", -- Press Enter to open files or folders
        },
      },
    },
    close_if_last_window = true,
  },
}
