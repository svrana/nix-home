local settings = require("settings")

local engines = settings.window.search_engines
engines.k = "https://kagi.com/search?q=%s"
engines.g = "http://www.google.com/search?hl=en&q=%s"
engines.arch = "https://wiki.archlinux.org/index.php/Special:Search?fulltext=Search&search=%s"
engines.gh = "https://github.com/search?q=%s"

engines.default = engines.k

local downloads = require("downloads")
downloads.default_dir = os.getenv("HOME") .. "/Downloads"

local webview = require("webview")
webview.hardware_acceleration_policy = "always"

local modes = require("modes")

modes.add_binds("normal", {
	{
		"<Control-c>",
		"Copy selected text.",
		function()
			luakit.selection.clipboard = luakit.selection.primary
		end,
	},
})

modes.remap_binds("normal", {
	{ "]", "gt", true },
	{ "[", "gT", true },
})

modes.remap_binds("normal", {
	{ " nt", ":tabopen<CR>", true },
})

modes.remap_binds("normal", {
	{ "c", ":back<CR>", true },
})
