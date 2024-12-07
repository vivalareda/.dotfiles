-- Check if OBSIDIAN_PATH environment variable is set
if vim.env.OBSIDIAN_PATH then
  return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "default",
          path = vim.env.OBSIDIAN_PATH, -- Use the environment variable
        },
      },
    },
  }
else -- Optionally, provide feedback if the plugin is not activated
  return {
    "nvim-lua/plenary.nvim",
    event = "VimEnter",
    config = function()
      vim.notify("OBSIDIAN_PATH environment variable is not set", "warn", {
        title = "Obsidian.nvim",
      })
    end,
  }
end
