return {
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"rust",
	},

	settings = {
		tailwindCSS = {
			includeLanguages = {
				rust = "html",
			},
			experimental = {
				classRegex = {
					[[class="([^"]*)"]],
					[[class=\{[^}]*"([^"]*)"[^}]*\}]],
					[[let\s+\w+\s*=\s*"([^"]*)"]],
				},
			},
		},
	},
}
