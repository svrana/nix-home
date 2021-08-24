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

M.clear_prompt = function(prompt_bufnr)
  local action_state = require'telescope.actions.state'
  action_state.get_current_picker(prompt_bufnr):reset_prompt()
end

return M
