return {
  "muhammadzkralla/zpragmatic.nvim",
  version = "1.0.2",
  config = function()
    require("zpragmatic").setup {
      filetype_questions = {
        ["*"] = { -- Questions for any file type
          "commit if done with task",
          "remove any extra files",
        },
      },
      bypass_filetypes = { "markdown", "txt", "text", "plain", "json" }, -- List of file types that should bypass the prompt
    }
  end,
}
