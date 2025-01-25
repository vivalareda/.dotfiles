return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer', -- source for text in buffer
    'hrsh7th/cmp-path', -- source for file system paths
    {
      'L3MON4D3/LuaSnip',
      -- follow latest release.
      version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = 'make install_jsregexp',
    },
    'saadparwaiz1/cmp_luasnip', -- for autocompletion
    'rafamadriz/friendly-snippets', -- useful snippets
    'onsails/lspkind.nvim', -- vs-code like pictograms
    'roobert/tailwindcss-colorizer-cmp.nvim',
  },
  config = function()
    local cmp = require 'cmp'

    local luasnip = require 'luasnip'

    local lspkind = require 'lspkind'

    local colorizer = require 'tailwindcss-colorizer-cmp'

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require('luasnip.loaders.from_vscode').lazy_load()
    require('tailwindcss-colorizer-cmp').setup {
      color_square_width = 2,
    }

    cmp.setup {
      completion = {
        completeopt = 'menu,menuone,preview,noselect',
      },
      snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-k>'] = cmp.mapping.select_prev_item(), -- keep for previous suggestion with Ctrl+k
        ['<C-j>'] = cmp.mapping.select_next_item(), -- keep for next suggestion with Ctrl+j

        -- ['<Tab>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item() -- navigate to next suggestion
        --   elseif require('luasnip').expand_or_jumpable() then
        --     require('luasnip').expand_or_jump() -- jump in snippet if available
        --   else
        --     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
        --   end
        -- end, { 'i', 's' }),
        ['<Tab>'] = cmp.mapping(function(fallback)
          local col = vim.fn.col('.') -- Get the cursor's column position
          if cmp.visible() then
            cmp.select_next_item() -- Navigate to the next completion item
          elseif require('luasnip').expand_or_jumpable() then
            require('luasnip').expand_or_jump() -- Expand or jump to the next snippet placeholder
          elseif col == 1 or vim.fn.getline('.'):match('^%s*$') then
            -- If at the beginning of the line or on an empty line, insert a literal tab
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
          else
              print("Fallback function triggered")
              print(vim.inspect(fallback))
              fallback() -- Delegate to fallback for other scenarios
            end
          end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item() -- navigate to previous suggestion
          elseif require('luasnip').jumpable(-1) then
            require('luasnip').jump(-1) -- jump backwards in snippet if available
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
          end
        end, { 'i', 's' }),

        ['<C-Space>'] = cmp.mapping.complete(), -- keep for manually showing suggestions
        ['<C-e>'] = cmp.mapping.abort(), -- keep for closing completion window

        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true, -- confirm the selection if available
        }, -- accept selection with Enter
      },

      -- sources for autocompletion
      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- snippets
        { name = 'buffer' }, -- text within current buffer
        { name = 'path' }, -- file system paths
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      -- configure lspkind for vs-code like pictograms in completion menu
      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        expandable_indicator = true,
        format = function(entry, vim_item)
          vim_item = lspkind.cmp_format {
            mode = 'symbol_text',
            maxwidth = 10,
            ellipsis_char = '…',
          }(entry, vim_item)

          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            luasnip = '[Snippet]',
            buffer = '[Buffer]',
            path = '[Path]',
          })[entry.source.name]

          return vim_item
        end,
      },
    }
  end,
}
