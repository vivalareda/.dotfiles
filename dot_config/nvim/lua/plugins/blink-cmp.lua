return {
	"saghen/blink.cmp",
	branch = "main",
	build = "cargo build --release",
	dependencies = {
		"saghen/blink.lib",
		"fang2hou/blink-copilot",
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
	},
	-- optional: provides snippets for the snippet source
	opts = {
		keymap = {
			preset = "none",
			["<C-k>"] = { "show", "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-y>"] = { "fallback" },
			-- ['<Tab>'] = { 'snippet_forward', 'fallback' },
		},

		cmdline = {
			keymap = {
				preset = "cmdline",
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
			},
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		snippets = { preset = "luasnip" },

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			keyword = {
				range = "prefix",
			},
			list = {
				selection = {
					preselect = false, -- Automatically select the first item
					auto_insert = true,
				},
			},
			accept = {
				-- experimental auto-brackets support
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				draw = {
					treesitter = { "lsp" },
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "source_name" }, -- This will show the source of completions
					},
				},
			},
			documentation = {
				auto_show = false,
				-- auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = true,
			},
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "copilot" },
			providers = {
				lsp = {
					async = true,
					timeout_ms = 2000,
					fallback = {},
				},
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					score_offset = 100,
					async = true,
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = {
			implementation = "prefer_rust",
		},
	},
	opts_extend = { "sources.default" },
	config = function(_, opts)
		require("blink.cmp").setup(opts)
	end,
}
