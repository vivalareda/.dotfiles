-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

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
    { "<C-n>", ":Neotree toggle<CR>", desc = "Toggle NeoTree", silent = true },
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
        hide_dotfiles = false, -- Show dotfiles
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
