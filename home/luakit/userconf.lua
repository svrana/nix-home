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
