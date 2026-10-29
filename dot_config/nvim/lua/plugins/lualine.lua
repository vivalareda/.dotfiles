-- Status line: keep LazyVim's structure, use the personal theme and path style.
return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = "codedark"

      opts.sections.lualine_c = {
        LazyVim.lualine.root_dir(),
        {
          "diagnostics",
          symbols = {
            error = LazyVim.config.icons.diagnostics.Error,
            warn = LazyVim.config.icons.diagnostics.Warn,
            info = LazyVim.config.icons.diagnostics.Info,
            hint = LazyVim.config.icons.diagnostics.Hint,
          },
        },
        { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        {
          "filename",
          file_status = true,
          newfile_status = false,
          path = 4,
          symbols = {
            modified = "[+]",
            readonly = "[-]",
          },
        },
      }

      table.insert(opts.sections.lualine_x, 1, {
        function()
          return require("noice").api.statusline.mode.get()
        end,
        cond = function()
          return require("noice").api.statusline.mode.has()
        end,
        color = { fg = "#ff9e64" },
      })

      return opts
    end,
  },
}
