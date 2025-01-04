return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Set up custom highlights for markdown elements
    local highlights = {
      -- Headers with colors matching the screenshot
      RenderMarkdownH1 = { fg = "#61afef", bold = true }, -- Blue
      RenderMarkdownH2 = { fg = "#98c379", bold = true }, -- Green
      RenderMarkdownH3 = { fg = "#e5c07b", bold = true }, -- Yellow
      RenderMarkdownH4 = { fg = "#c678dd", bold = true }, -- Purple
      RenderMarkdownH5 = { fg = "#56b6c2", bold = true }, -- Cyan
      RenderMarkdownH6 = { fg = "#be5046", bold = true }, -- Red

      -- Header backgrounds (subtle, transparent-like)
      RenderMarkdownH1Bg = { bg = "#1e2127" },
      RenderMarkdownH2Bg = { bg = "#1e2127" },
      RenderMarkdownH3Bg = { bg = "#1e2127" },
      RenderMarkdownH4Bg = { bg = "#1e2127" },
      RenderMarkdownH5Bg = { bg = "#1e2127" },
      RenderMarkdownH6Bg = { bg = "#1e2127" },

      -- Code blocks and inline code
      RenderMarkdownCode = { bg = "#282c34" },
      RenderMarkdownCodeInline = { bg = "#2c313c" },

      -- Other elements
      RenderMarkdownBullet = { fg = "#61afef" },
      RenderMarkdownQuote = { fg = "#98c379" },
      RenderMarkdownDash = { fg = "#5c6370" },
      RenderMarkdownLink = { fg = "#61afef", underline = true },
      RenderMarkdownWikiLink = { fg = "#c678dd", underline = true },

      -- Checkboxes
      RenderMarkdownUnchecked = { fg = "#5c6370" },
      RenderMarkdownChecked = { fg = "#98c379" },
      RenderMarkdownTodo = { fg = "#e5c07b" },

      -- Tables
      RenderMarkdownTableHead = { fg = "#c678dd", bold = true },
      RenderMarkdownTableRow = { fg = "#abb2bf" },
      RenderMarkdownTableFill = { fg = "#4b5263" },

      -- Callouts
      RenderMarkdownSuccess = { fg = "#98c379" },
      RenderMarkdownInfo = { fg = "#61afef" },
      RenderMarkdownHint = { fg = "#e5c07b" },
      RenderMarkdownWarn = { fg = "#d19a66" },
      RenderMarkdownError = { fg = "#be5046" },
    }

    -- Apply the highlights
    for group, settings in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, settings)
    end

    -- Plugin configuration
    require("render-markdown").setup {
      text_highlight = true, -- Ensure text is highlighted
      enabled = true,
      file_types = { "markdown" },
      heading = {
        enabled = true,
        sign = true,
        position = "right",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        width = "block",
        border = false,
        left_margin = 0,
        left_pad = 0,
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",
        position = "left",
        language_name = true,
        border = "thin",
        width = "block",
        disable_background = true,
        left_margin = 2,
        left_pad = 1,
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
        left_pad = 1,
        right_pad = 1,
      },
      checkbox = {
        enabled = true,
        position = "inline",
        unchecked = { icon = "󰄱 " },
        checked = { icon = "󰄵 " },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        },
      },
      quote = {
        enabled = true,
        icon = "▋",
        repeat_linebreak = false,
      },
      pipe_table = {
        enabled = true,
        style = "full",
        cell = "padded",
        padding = 1,
      },
      link = {
        enabled = true,
        image = "󰥶 ",
        email = "󰀓 ",
        hyperlink = "󰌹 ",
        wiki = { icon = "󱗖 " },
      },
      indent = {
        enabled = false,
      },
    }

    require("nvim-treesitter.configs").setup {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        custom_captures = {
          ["text.header.h1.markdown"] = "RenderMarkdownH1Text",
          ["text.header.h2.markdown"] = "RenderMarkdownH2Text",
          ["text.header.h3.markdown"] = "RenderMarkdownH3Text",
          ["text.header.h4.markdown"] = "RenderMarkdownH4Text",
          ["text.header.h5.markdown"] = "RenderMarkdownH5Text",
          ["text.header.h6.markdown"] = "RenderMarkdownH6Text",
        },
      },
    }

    -- Ensure treesitter highlighting is enabled
    require("nvim-treesitter.configs").setup {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  end,
}
