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

local W = ext.grid.GRIDWIDTH
local H = ext.grid.GRIDHEIGHT

arrangement.add("Home", {
 ["iTunes"]     = {screen = 1, grid = {x = 0,   y = 0,   w = W/1.5, h = H}},
 ["Mail"]       = {screen = 1, grid = {x = 0,   y = 0,   w = W/1.5, h = H}},
 ["Safari"]     = {screen = 1, grid = {x = 0,   y = 0,   w = W/1.5, h = H}},
 ["SourceTree"] = {screen = 1, grid = {x = 0,   y = 0,   w = W/1.5, h = H}},
 ["Spotify"]    = {screen = 1, grid = {x = 0,   y = 0,   w = W/1.5, h = H}},
 ["Terminal"]   = {screen = 1, grid = {x = W/2, y = H/2, w = W/2,   h = H/2}},
 ["TextMate"]   = {screen = 1, grid = {x = W/2, y = 0,   w = W/2,   h = H}},
 ["Tower"]      = {screen = 1, grid = {x = 0,   y = 0,   w = W/1.5, h = H}},
 ["Xcode"]      = {screen = 1, grid = {x = 0,   y = 0,   w = W/1.5, h = H}},
})

arrangement.add("Work", {
  ["Dash"]              = {screen = 2, grid = {x = 0,   y = 0,   w = W/2, h = H}},
  ["iTunes"]            = {action = "close"},
  ["Parallels Desktop"] = {screen = 2, action = "fullscreen"},
  ["Safari"]            = {screen = 2, grid = {x = 0,   y = 0,   w = W,   h = H}},
  ["SourceTree"]        = {screen = 1, grid = {x = 0,   y = 0,   w = W,   h = H}},
  ["Terminal"]          = {screen = 1, grid = {x = W/2, y = H/2, w = W/2, h = H/2}},
  ["TextMate"]          = {screen = 2, grid = {x = W/2, y = 0,   w = W/2, h = H}},
  ["Tower"]             = {screen = 1, grid = {x = 0,   y = 0,   w = W,   h = H}},
  ["Xcode"]             = {screen = 1, grid = {x = 0,   y = 0,   w = W,   h = H}},
})

local modifiers = {'cmd', 'alt'}

split = hotkey.modal.new(modifiers, '1')
function split:entered() hydra.alert('Split Mode', 1) end
function split:exited() hydra.alert("done", 0.5) end

split:bind({}, 'UP', ext.grid.maximize_window)
split:bind({}, 'LEFT', ext.grid.lefthalf)
split:bind({}, 'SPACE', ext.grid.snap_all)
split:bind({}, 'RIGHT', ext.grid.righthalf)
split:bind({}, 'DOWN', ext.grid.pushwindow_nextscreen)
split:bind({}, 'RETURN', function() split:exit() end)


position = hotkey.modal.new(modifiers, '2')
function position:entered() hydra.alert('Position Mode', 1) end
function position:exited() hydra.alert("done", 0.5) end

position:bind({}, 'LEFT', ext.grid.topleft)
position:bind({}, 'UP', ext.grid.topright)
position:bind({}, 'DOWN', ext.grid.bottomleft)
position:bind({}, 'RIGHT', ext.grid.bottomright)
position:bind({}, 'RETURN', function() position:exit() end)


resize = hotkey.modal.new(modifiers, '3')
function resize:entered() hydra.alert('Resize Mode', 1) end
function resize:exited() hydra.alert("done", 0.5) end

resize:bind({}, 'UP', ext.grid.resizewindow_shorter)
resize:bind({}, 'LEFT', ext.grid.resizewindow_thinner)
resize:bind({}, 'RIGHT', ext.grid.resizewindow_wider)
resize:bind({}, 'DOWN', ext.grid.resizewindow_taller)
resize:bind({}, 'RETURN', function() resize:exit() end)


move = hotkey.modal.new(modifiers, '4')
function move:entered() hydra.alert('Move Mode', 1) end
function move:exited() hydra.alert("done", 0.5) end

move:bind({}, 'UP', ext.grid.movewindow_up)
move:bind({}, 'DOWN', ext.grid.movewindow_down)
move:bind({}, 'LEFT', ext.grid.movewindow_left)
move:bind({}, 'RIGHT', ext.grid.movewindow_right)
move:bind({}, 'RETURN', function() move:exit() end)

hydra.updates.check()
