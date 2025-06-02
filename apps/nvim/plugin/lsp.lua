local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local on_attach = function(_, bufnr)

	local bufmap = function(keys, func, desc)
		vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
	end

	bufmap('<leader>lr', vim.lsp.buf.rename, '[L]sp [R]ename' )
	bufmap('<leader>la', vim.lsp.buf.code_action, '[L]sp [A]ction') 

	bufmap('gd', vim.lsp.buf.definition, '[G]o to [D]efinition')
	bufmap('gD', vim.lsp.buf.declaration, '[G]o to [D]eclaration')
	bufmap('gI', vim.lsp.buf.implementation, '[G]o to [I]mplementation')

	bufmap('<leader>sr', require('telescope.builtin').lsp_references, '[S]earch [R]eferences')
	bufmap('<leader>ss', require('telescope.builtin').lsp_document_symbols, '[S]earch [S]ymbols')
	bufmap('<leader>sS', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[S]earch workspace [S]ymbols')
	bufmap('<leader>sD', require('telescope.builtin').diagnostics, '[S]earch workspace [D]iagnostics')
	bufmap('<leader>sd', function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end, '[S]earch [D]iagnostics')
	bufmap('<leader>se', function() require('telescope.builtin').diagnostics({ bufnr = 0, severity = vim.diagnostic.severity.ERROR }) end, '[S]earch [E]rrors')

	bufmap('K', vim.lsp.buf.hover, 'Code Hint')

	-- Show diagnostics in a floating window
	bufmap('<leader>d', vim.diagnostic.open_float, '[D]iagnostic')

	-- Go to next/previous diagnostic
	bufmap('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
	bufmap(']d', vim.diagnostic.goto_next, 'Next Diagnostic')

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('lspconfig').lua_ls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' }, -- Recognize 'vim' as a global
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false, -- Avoid annoying prompts
			},
		},
	},
}

require('lspconfig').nil_ls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

require('lspconfig').bashls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

require('lspconfig').rust_analyzer.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}
