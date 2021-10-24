-- tj rip (https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/repl.lua)

if false then
  RELOAD "svrana.repl"
end

local M = {}

_ReplCurrentJobID = _ReplCurrentJobID or -1
_ReplCurrentCommand = _ReplCurrentCommand or nil

M.set_job_id = function(job_id)
  job_id = job_id or vim.b.terminal_job_id

  print("setting job id..", job_id)
  _ReplCurrentJobID = job_id
end

M.set_job_command = function(command)
  _ReplCurrentCommand = command or vim.fn.input "Send to chan >"
end

M.send_to_term = function(input)
  input = input or _ReplCurrentCommand or vim.fn.input "Send to chan >"

  vim.fn.chansend(_ReplCurrentJobID, { input .. "\r\n" })
end

return M
