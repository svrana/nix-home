local M = {}

function M.dots()
  require("telescope.builtin").find_files {
    shorten_path = false,
    cwd = "$DOTFILES",
    prompt_title = "~ dotfiles ~",
    hidden = false,
  }
end

M.project_files = function()
  local opts = {}
  local ok = pcall(require'telescope.builtin'.git_files, opts)
  if not ok then require'telescope.builtin'.find_files(opts) end
end

return M
