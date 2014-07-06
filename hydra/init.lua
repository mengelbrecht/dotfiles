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

mode1 = ext.mode.bind({'ctrl'}, 'PAD1',
  function()
    hydra.alert('Mode 1', 1)
    mode2:disable()
    timer.doafter(3, function() mode1:exit() end)
  end,
  function()
    hydra.alert("done", 0.5)
    mode2:enable()
  end)

mode1:bind({}, 'PAD7', ext.grid.topleft)
mode1:bind({}, 'PAD8', ext.grid.maximize_window)
mode1:bind({}, 'PAD9', ext.grid.topright)
mode1:bind({}, 'PAD4', ext.grid.lefthalf)
mode1:bind({}, 'PAD5', function() fnutils.map(window.visiblewindows(), ext.grid.snap) end)
mode1:bind({}, 'PAD6', ext.grid.righthalf)
mode1:bind({}, 'PAD1', ext.grid.bottomleft)
mode1:bind({}, 'PAD2', ext.grid.pushwindow_nextscreen)
mode1:bind({}, 'PAD3', ext.grid.bottomright)
mode1:bind({}, 'RETURN', function() mode1:exit() end)

mode2 = ext.mode.bind({'ctrl'}, 'PAD2',
  function()
    hydra.alert('Mode 2', 1)
    mode1:disable()
    timer.doafter(3, function() mode2:exit() end)
  end,
  function()
    hydra.alert("done", 0.5)
    mode1:enable()
  end)

mode2:bind({}, 'PAD7', ext.grid.movewindow_up)
mode2:bind({}, 'PAD8', ext.grid.resizewindow_shorter)
mode2:bind({}, 'PAD9', ext.grid.movewindow_down)
mode2:bind({}, 'PAD4', ext.grid.resizewindow_thinner)
mode2:bind({}, 'PAD6', ext.grid.resizewindow_wider)
mode2:bind({}, 'PAD1', ext.grid.movewindow_left)
mode2:bind({}, 'PAD2', ext.grid.resizewindow_taller)
mode2:bind({}, 'PAD3', ext.grid.movewindow_right)
mode2:bind({}, 'RETURN', function() mode2:exit() end)

updates.check()
