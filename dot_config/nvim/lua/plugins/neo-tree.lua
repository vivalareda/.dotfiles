-- Neo-tree stays available through LazyVim's <leader>e bindings.
-- <C-n> mirrors the old toggle-at-current-file behaviour.
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<C-n>",
        function()
          local manager = require("neo-tree.sources.manager")
          if manager.get_state("filesystem").winid then
            require("neo-tree.command").execute({ action = "close" })
            return
          end

          local reveal_file = vim.fn.expand("%:p")
          if reveal_file == "" then
            reveal_file = vim.fn.getcwd()
          else
            local f = io.open(reveal_file, "r")
            if f then
              f:close()
            else
              reveal_file = vim.fn.getcwd()
            end
          end

          require("neo-tree.command").execute({
            action = "focus",
            source = "filesystem",
            position = "left",
            reveal_file = reveal_file,
            reveal_force_cwd = true,
          })
        end,
        desc = "Toggle neo-tree at current file",
        silent = true,
      },
    },
    opts = {
      event_handlers = {
        {
          event = "file_open_requested",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        window = {
          mappings = {
            ["<CR>"] = "open",
          },
        },
      },
      close_if_last_window = true,
    },
  },
}
