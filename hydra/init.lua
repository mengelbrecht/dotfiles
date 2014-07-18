require('grid')
require('utils')

hydra.alert("Hydra loaded", 0.5)

pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()
autolaunch.set(true)

menu.show(function()
    return {
      {title = "About Hydra", fn = hydra.showabout},
      {title = "-"},
      {title = "Arrange Work", fn = arrange_work},
      {title = "-"},
      {title = "Quit", fn = os.exit},
    }
end)

local work = {
  {app = "TextMate", screen = 2, grid = {3, 0, 3, 6}},
  {app = "Terminal", screen = 1, grid = {3, 3, 3, 3}},
  {app = "Xcode", screen = 1, grid = {0, 0, 6, 6}},
  {app = "SourceTree", screen = 1, grid = {0, 0, 6, 6}},
  {app = "Dash", screen = 2, grid = {0, 0, 3, 6}},
  {app = "Safari", screen = 2, grid = {0, 0, 6, 6}},
  {app = "iTunes", action = "close"},
  {app = "Parallels Desktop", screen = 2, action = "fullscreen"}
}

function arrange(a)
  local win = utils.find_window(a.app)
  if win == nil then return end

  if a.grid then ext.grid.setsimple(win, a.grid) end
  if a.screen then ext.grid.pushwindow_toscreen(win, a.screen) end
  if a.action then
    if a.action == "close" then win:close()
    elseif a.action == "fullscreen" then win:setfullscreen(true)
    end
  end
end

function arrange_work()
  hydra.alert("Arranging", 1)
  fnutils.map(work, arrange)
  ext.grid.snap_all()
end

split = modalkey.new({'cmd', 'ctrl'}, '1')
function split:entered() hydra.alert('Split Mode', 1) end
function split:exited() hydra.alert("done", 0.5) end

split:bind({}, 'UP', ext.grid.maximize_window)
split:bind({}, 'LEFT', ext.grid.lefthalf)
split:bind({}, 'SPACE', ext.grid.snap_all)
split:bind({}, 'RIGHT', ext.grid.righthalf)
split:bind({}, 'DOWN', ext.grid.pushwindow_nextscreen)
split:bind({}, 'RETURN', function() split:exit() end)


position = modalkey.new({'cmd', 'ctrl'}, '2')
function position:entered() hydra.alert('Position Mode', 1) end
function position:exited() hydra.alert("done", 0.5) end

position:bind({}, 'LEFT', ext.grid.topleft)
position:bind({}, 'UP', ext.grid.topright)
position:bind({}, 'DOWN', ext.grid.bottomleft)
position:bind({}, 'RIGHT', ext.grid.bottomright)
position:bind({}, 'RETURN', function() position:exit() end)


resize = modalkey.new({'cmd', 'ctrl'}, '3')
function resize:entered() hydra.alert('Resize Mode', 1) end
function resize:exited() hydra.alert("done", 0.5) end

resize:bind({}, 'UP', ext.grid.resizewindow_shorter)
resize:bind({}, 'LEFT', ext.grid.resizewindow_thinner)
resize:bind({}, 'RIGHT', ext.grid.resizewindow_wider)
resize:bind({}, 'DOWN', ext.grid.resizewindow_taller)
resize:bind({}, 'RETURN', function() resize:exit() end)


move = modalkey.new({'cmd', 'ctrl'}, '4')
function move:entered() hydra.alert('Move Mode', 1) end
function move:exited() hydra.alert("done", 0.5) end

move:bind({}, 'UP', ext.grid.movewindow_up)
move:bind({}, 'DOWN', ext.grid.movewindow_down)
move:bind({}, 'LEFT', ext.grid.movewindow_left)
move:bind({}, 'RIGHT', ext.grid.movewindow_right)
move:bind({}, 'RETURN', function() move:exit() end)

updates.check()
