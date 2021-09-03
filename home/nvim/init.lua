local opt = vim.opt

opt.ttimeout = false
opt.ttimeoutlen = 100
opt.ignorecase = true
opt.wrap = false
opt.backspace = "indent,eol,start"
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false
opt.incsearch = true
opt.hlsearch = false
opt.inccommand = "split"
--g.backupcopy = true
opt.tags = "tags=tags,${GRUF_PROJECT}/tags"
opt.showmatch = true
opt.backupext  = ".bak"
opt.backupdir = "~/.config/nvim/bak"
opt.errorbells = false
opt.showmode = false
opt.visualbell = true
opt.ruler = true
opt.laststatus = 2
--g.go = "ia"
opt.equalalways = false
opt.updatetime = 100
opt.lazyredraw = true
opt.background = "dark"
opt.pyx = 3
opt.termguicolors = true
opt.clipboard = "unnamed,unnamedplus"

--local g = vim.g
--local cmd = vim.cmd

local lsp = require 'vim.lsp'
local util = require 'vim.lsp.util'
local vim = vim

-- Ref (in Japanese): https://daisuzu.hatenablog.com/entry/2019/12/06/005543
function tagfunc_nvim_lsp(pattern, flags, _)
	local result = {}
	local isSearchingFromNormalMode = flags == "c"

	local method
	local params
	if isSearchingFromNormalMode then
		-- Jump to the definition of the symbol under the cursor
		-- when called by CTRL-]
		method = 'textDocument/definition'
		params = util.make_position_params()
	else
		-- NOTE: Currently I'm not sure how this clause is tested
		--       because `:tag` command doesn't seem to use `tagfunc`.

		-- Search with `pattern` when called by ex command (e.g. `:tag`)
		method = 'workspace/symbol'

		-- Delete "\<" from `pattern` when prepended.
		-- Perhaps the server doesn't support regex in vim!
		params = {}
		if string.find(flags, 'i') then
			params.query = string.sub(pattern, '^\\<', '')
		else
			params.query = pattern
		end
	end
	local client_id_to_results, err = lsp.buf_request_sync(0, method, params, 800)
	if err then
		print('Error when calling tagfunc: ' .. err)
		return result
	end

	for _, results in pairs(client_id_to_results) do
		for _, lsp_result in ipairs(results.result) do
			local name
			local location
			if isSearchingFromNormalMode then
				name = pattern
				location = lsp_result
			else
				name = lsp_result.name
				location = lsp_result.location
			end
			local location_for_tagfunc = {
				name = name,
				filename = vim.uri_to_fname(location.uri),
				cmd = tostring(location.range.start.line + 1)
			}
			table.insert(result, location_for_tagfunc)
		end
	end
	return result
end
