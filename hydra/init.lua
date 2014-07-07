require('grid')
require('mode')

hydra.alert("Hydra config loaded", 0.5)

pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()
autolaunch.set(true)

menu.show(function()
    return {
      {title = "About Hydra", fn = hydra.showabout},
      {title = "-"},
      {title = "Quit", fn = os.exit},
    }
end)

split = ext.mode.bind({'ctrl'}, 'PAD1',
  function()
    hydra.alert('Split Mode', 1)
    resize:disable()
    move:disable()
  end,
  function()
    hydra.alert("done", 0.5)
    resize:enable()
    move:enable()
  end)

split:bind({}, 'PAD7', ext.grid.topleft)
split:bind({}, 'PAD8', ext.grid.maximize_window)
split:bind({}, 'PAD9', ext.grid.topright)
split:bind({}, 'PAD4', ext.grid.lefthalf)
split:bind({}, 'PAD5', function() fnutils.map(window.visiblewindows(), ext.grid.snap) end)
split:bind({}, 'PAD6', ext.grid.righthalf)
split:bind({}, 'PAD1', ext.grid.bottomleft)
split:bind({}, 'PAD2', ext.grid.pushwindow_nextscreen)
split:bind({}, 'PAD3', ext.grid.bottomright)
split:bind({}, 'RETURN', function() split:exit() end)

resize = ext.mode.bind({'ctrl'}, 'PAD2',
  function()
    hydra.alert('Resize Mode', 1)
    split:disable()
    move:disable()
  end,
  function()
    hydra.alert("done", 0.5)
    split:enable()
    move:enable()
  end)

resize:bind({}, 'PAD8', ext.grid.resizewindow_shorter)
resize:bind({}, 'PAD4', ext.grid.resizewindow_thinner)
resize:bind({}, 'PAD6', ext.grid.resizewindow_wider)
resize:bind({}, 'PAD2', ext.grid.resizewindow_taller)
resize:bind({}, 'RETURN', function() resize:exit() end)

move = ext.mode.bind({'ctrl'}, 'PAD3',
  function()
    hydra.alert('Move Mode', 1)
    split:disable()
    resize:disable()
  end,
  function()
    hydra.alert("done", 0.5)
    split:enable()
    resize:enable()
  end)

move:bind({}, 'PAD8', ext.grid.movewindow_up)
move:bind({}, 'PAD2', ext.grid.movewindow_down)
move:bind({}, 'PAD4', ext.grid.movewindow_left)
move:bind({}, 'PAD6', ext.grid.movewindow_right)
move:bind({}, 'RETURN', function() move:exit() end)

updates.check()
