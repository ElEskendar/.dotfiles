local languages = {"cs", "cpp", "css", "html", "razor", "json"}

for _, value in pairs(languages) do
	vim.api.nvim_create_autocmd('FileType', {
		pattern = { value },
		callback = function(ev) vim.treesitter.start(ev.buf, value) end,
	})
end
