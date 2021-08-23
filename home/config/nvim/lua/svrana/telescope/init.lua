local M = {}

function M.dots()
  require("telescope.builtin").find_files {
    shorten_path = false,
    cwd = "$DOTFILES",
    prompt = "~ dotfiles ~",
    hidden = false,

    layout_strategy = "horizontal",
    layout_config = {
      preview_width = 0.55,
    },
  }
end

return M
