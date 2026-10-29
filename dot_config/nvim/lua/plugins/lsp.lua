-- LSP: Mason keeps the servers installed, LazyVim wires them up with
-- vim.lsp.config/enable, and this file only adds the project-specific bits.
return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      -- mason-lspconfig expects nvim-lspconfig server names here (e.g.
      -- rust_analyzer), not Mason package names (rust-analyzer).
      ensure_installed = {
        "biome",
        "lua_ls",
        "eslint",
        "vtsls",
        "html",
        "cssls",
        "jsonls",
        "tailwindcss",
        "svelte",
        "graphql",
        "prismals",
        "basedpyright",
        "terraformls",
        "oxlint",
        "tinymist",
        "rust_analyzer",
      },
    },
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "prettier", "eslint_d" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    init = function()
      pcall(function()
        vim.lsp.document_color.enable(false)
      end)

      -- Per-buffer mappings that need the client itself, not just "an LSP attached".
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          pcall(function()
            require("util.vtsls_tsdk").ensure(client, args.buf)
          end)

          if client.name == "vtsls" then
            vim.keymap.set("n", "<leader>cv", function()
              client:exec_cmd({
                command = "typescript.selectTypeScriptVersion",
                title = "Select TypeScript Version",
              })
            end, { buffer = args.buf, desc = "Select TypeScript version" })
          end

          vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", {
            buffer = args.buf,
            desc = "Restart LSP",
          })
        end,
      })
    end,
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "gD", vim.lsp.buf.implementation, desc = "Goto Implementation" },
            { "<leader>rn", vim.lsp.buf.rename, desc = "Smart rename" },
            { "<leader>k", vim.diagnostic.open_float, desc = "Line Diagnostics" },
            -- Turbo console log owns <leader>cl (see util/turbo_log.lua).
            { "<leader>cl", false },
            -- Clear-all-lines owns <leader>ca (see config/keymaps.lua).
            { "<leader>ca", false },
            -- Blink owns <C-k> in insert mode (completion menu).
            { "<c-k>", false, mode = "i" },
          },
        },
      },
    },
  },

  {
    "yioneko/nvim-vtsls",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  },

  -- Turns raw TypeScript diagnostic codes into readable explanations.
  {
    "davidosomething/format-ts-errors.nvim",
    config = function()
      local ok, fte = pcall(require, "format-ts-errors")
      if not ok then
        return
      end
      fte.setup({ add_markdown = true, start_indent_level = 0 })

      local default = vim.lsp.handlers["textDocument/publishDiagnostics"]
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
        local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id)
        local is_ts = client and (client.name == "vtsls" or client.name == "tsserver" or client.name == "ts_ls")

        if is_ts and result and result.diagnostics then
          local i = 1
          while i <= #result.diagnostics do
            local diagnostic = result.diagnostics[i]
            if diagnostic.code == 80001 then
              table.remove(result.diagnostics, i)
            else
              local code = diagnostic.code
              local formatter = fte[code] or fte[tonumber(code) or -1] or fte[tostring(code)]
              if formatter and diagnostic.message then
                diagnostic.message = formatter(diagnostic.message)
              end
              i = i + 1
            end
          end
        end

        return default(err, result, ctx, config)
      end
    end,
  },
}
