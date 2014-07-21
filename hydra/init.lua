require('grid')
require('arrangement')

hydra.alert("Hydra loaded", 0.5)

pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()
hydra.autolaunch.set(true)

hydra.menu.show(function()
  items = {
    {title = "About Hydra", fn = hydra.showabout},
    {title = "-"},
    {title = "Open REPL", fn = repl.open},
    {title = "-"},
  }

  fnutils.concat(items, arrangement.menu_items())
  fnutils.concat(items, {
    {title = "-"},
    {title = "Quit", fn = os.exit}
  })
  return items
end)

arrangement.add("Home", {
 ["iTunes"]     = {screen = 1, grid = {x = 0, y = 0, w = 4, h = 6}},
 ["Safari"]     = {screen = 1, grid = {x = 0, y = 0, w = 4, h = 6}},
 ["SourceTree"] = {screen = 1, grid = {x = 0, y = 0, w = 4, h = 6}},
 ["Terminal"]   = {screen = 1, grid = {x = 3, y = 3, w = 3, h = 3}},
 ["TextMate"]   = {screen = 1, grid = {x = 3, y = 0, w = 3, h = 6}},
 ["Xcode"]      = {screen = 1, grid = {x = 0, y = 0, w = 4, h = 6}},
})

arrangement.add("Work", {
  ["Dash"]              = {screen = 2, grid = {x = 0, y = 0, w = 3, h = 6}},
  ["iTunes"]            = {action = "close"},
  ["Parallels Desktop"] = {screen = 2, action = "fullscreen"},
  ["Safari"]            = {screen = 2, grid = {x = 0, y = 0, w = 6, h = 6}},
  ["SourceTree"]        = {screen = 1, grid = {x = 0, y = 0, w = 6, h = 6}},
  ["Terminal"]          = {screen = 1, grid = {x = 3, y = 3, w = 3, h = 3}},
  ["TextMate"]          = {screen = 2, grid = {x = 3, y = 0, w = 3, h = 6}},
  ["Xcode"]             = {screen = 1, grid = {x = 0, y = 0, w = 6, h = 6}},
})


split = hotkey.modal.new({'cmd', 'ctrl'}, '1')
function split:entered() hydra.alert('Split Mode', 1) end
function split:exited() hydra.alert("done", 0.5) end

split:bind({}, 'UP', ext.grid.maximize_window)
split:bind({}, 'LEFT', ext.grid.lefthalf)
split:bind({}, 'SPACE', ext.grid.snap_all)
split:bind({}, 'RIGHT', ext.grid.righthalf)
split:bind({}, 'DOWN', ext.grid.pushwindow_nextscreen)
split:bind({}, 'RETURN', function() split:exit() end)


position = hotkey.modal.new({'cmd', 'ctrl'}, '2')
function position:entered() hydra.alert('Position Mode', 1) end
function position:exited() hydra.alert("done", 0.5) end

position:bind({}, 'LEFT', ext.grid.topleft)
position:bind({}, 'UP', ext.grid.topright)
position:bind({}, 'DOWN', ext.grid.bottomleft)
position:bind({}, 'RIGHT', ext.grid.bottomright)
position:bind({}, 'RETURN', function() position:exit() end)


resize = hotkey.modal.new({'cmd', 'ctrl'}, '3')
function resize:entered() hydra.alert('Resize Mode', 1) end
function resize:exited() hydra.alert("done", 0.5) end

resize:bind({}, 'UP', ext.grid.resizewindow_shorter)
resize:bind({}, 'LEFT', ext.grid.resizewindow_thinner)
resize:bind({}, 'RIGHT', ext.grid.resizewindow_wider)
resize:bind({}, 'DOWN', ext.grid.resizewindow_taller)
resize:bind({}, 'RETURN', function() resize:exit() end)


move = hotkey.modal.new({'cmd', 'ctrl'}, '4')
function move:entered() hydra.alert('Move Mode', 1) end
function move:exited() hydra.alert("done", 0.5) end

move:bind({}, 'UP', ext.grid.movewindow_up)
move:bind({}, 'DOWN', ext.grid.movewindow_down)
move:bind({}, 'LEFT', ext.grid.movewindow_left)
move:bind({}, 'RIGHT', ext.grid.movewindow_right)
move:bind({}, 'RETURN', function() move:exit() end)

hydra.updates.check()
