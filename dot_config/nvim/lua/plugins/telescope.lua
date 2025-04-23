return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8", -- Use a stable release
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "debugloop/telescope-undo.nvim",
  },
  config = function()
    require("telescope").setup {
      extensions = {
        undo = {
          "debugloop/telescope-undo.nvim",
        },
      },
      defaults = {
        file_ignore_patterns = { "node_modules", "*flask-app/*" },
        mappings = {
          i = {
            ["<C-h>"] = "which_key",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          }, -- Example mapping for insert mode
        },
      },
      pickers = {
        find_files = { theme = "dropdown" },
      },
    }

    require("telescope").load_extension "fzf"
    require("telescope").load_extension "undo"

    -- Telescope key mappings
    local builtin = require "telescope.builtin"
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[ ] Find existing buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[S]earch [H]elp" })
    vim.keymap.set("n", "<leader>fcw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[S]earch [R]esume" })
    vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "[S]earch Recent Files ('repeat')" })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

    -- Fuzzy search in current buffer
    vim.keymap.set("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = "[/] Fuzzily search in current buffer" })

    -- Live Grep in Open Files
    vim.keymap.set("n", "<leader>s/", function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = "Live Grep in Open Files",
      }
    end, { desc = "[S]earch [/] in Open Files" })

    -- Search Neovim configuration files
    vim.keymap.set("n", "<leader>fn", function()
      builtin.find_files { cwd = vim.fn.stdpath "config" }
    end, { desc = "[S]earch [N]eovim files" })

    vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<cr>")
  end,
}
