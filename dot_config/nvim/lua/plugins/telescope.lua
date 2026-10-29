-- Telescope is the picker (see vim.g.lazyvim_picker in config/lazy.lua).
-- These mappings replace/override the LazyVim defaults with the personal ones.
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", "*flask-app/*" },
        mappings = {
          i = {
            ["<C-h>"] = "which_key",
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
            ["<esc>"] = "close",
          },
        },
      },
      pickers = {
        find_files = { theme = "dropdown" },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
      telescope.load_extension("undo")
      telescope.load_extension("ui-select")
    end,
    keys = {
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Search help" },
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Search files" },
      { "<leader>fw", function() require("telescope.builtin").live_grep() end, desc = "Search by grep" },
      { "<leader>fiw", function() require("telescope.builtin").grep_string() end, desc = "Search current word" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Search diagnostics" },
      { "<leader>fr", function() require("telescope.builtin").lsp_references() end, desc = "Search references" },
      { "<leader>f.", function() require("telescope.builtin").oldfiles() end, desc = "Search recent files" },
      {
        "<leader><leader>",
        function() require("telescope.builtin").buffers() end,
        desc = "Find existing buffers",
      },
      {
        "<leader>ep",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
        end,
        desc = "Search plugin files",
      },
      {
        "<leader>s/",
        function()
          require("telescope.builtin").live_grep({
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
          })
        end,
        desc = "Search in open files",
      },
      {
        "<leader>fn",
        function()
          require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Search Neovim config",
      },
      { "<leader>fu", "<cmd>Telescope undo<cr>", desc = "Undo history" },
      -- Freed for code actions (see actions-preview in editor.lua).
      { "<leader>sa", false },
    },
  },
}
