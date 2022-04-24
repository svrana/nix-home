local M = {}
local cmd = vim.cmd

function M.create_augroup(autocmds, name)
    cmd('augroup ' .. name)
    cmd('autocmd!')
    for _, autocmd in ipairs(autocmds) do
        cmd('autocmd ' .. table.concat(autocmd, ' '))
    end
    cmd('augroup END')
end

function M.autocmd(editoractions, filetypes, action)
    cmd('autocmd ' .. editoractions .. ' ' .. filetypes .. ' ' ..  action)
end

M.imap = function(tbl)
  vim.keymap.set("i", tbl[1], tbl[2], tbl[3])
end

M.nmap = function(tbl)
  vim.keymap.set("n", tbl[1], tbl[2], tbl[3])
end

-- map lhs to rhs in all modes
M.amap = function(lhs, rhs)
    local map = vim.api.nvim_set_keymap
    local options = { noremap = true, silent = true }

    -- vim.keymap.set({'', '!', 't', 'l'}, lhs, rhs, options)

    map('', lhs, rhs, options)
    map('!', lhs, rhs, options)
    map('t', lhs, rhs, options)
    map('l', lhs, rhs, options)
end

return M
