local tree ={}

tree.toggle = function ()
    local view = require'nvim-tree.view'
    if view.win_open() then
        tree.close()
    else
        tree.open()
    end
end

tree.open = function ()
   require'bufferline.state'.set_offset(31, 'FileTree')
   require'nvim-tree'.toggle()
end

tree.close = function ()
   require'bufferline.state'.set_offset(0)
   require'nvim-tree'.toggle()
end

return tree
