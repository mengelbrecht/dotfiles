require('utils')

ext.grid = {}

ext.grid.MARGINX = 0
ext.grid.MARGINY = 0
ext.grid.GRIDHEIGHT = 6
ext.grid.GRIDWIDTH = 6

function ext.grid.get(win)
  local winframe = win:frame()
  local screenrect = win:screen():frame_without_dock_or_menu()
  local thirdscreenwidth = screenrect.w / ext.grid.GRIDWIDTH
  local halfscreenheight = screenrect.h / ext.grid.GRIDHEIGHT
  return {
    x = utils.round((winframe.x - screenrect.x) / thirdscreenwidth),
    y = utils.round((winframe.y - screenrect.y) / halfscreenheight),
    w = math.max(1, utils.round(winframe.w / thirdscreenwidth)),
    h = math.max(1, utils.round(winframe.h / halfscreenheight)),
  }
end

function ext.grid.set(win, grid, screen)
  local screenrect = screen:frame_without_dock_or_menu()
  local thirdscreenwidth = screenrect.w / ext.grid.GRIDWIDTH
  local halfscreenheight = screenrect.h / ext.grid.GRIDHEIGHT
  local newframe = {
    x = (grid.x * thirdscreenwidth) + screenrect.x,
    y = (grid.y * halfscreenheight) + screenrect.y,
    w = grid.w * thirdscreenwidth,
    h = grid.h * halfscreenheight,
  }

  newframe.x = newframe.x + ext.grid.MARGINX
  newframe.y = newframe.y + ext.grid.MARGINY
  newframe.w = newframe.w - (ext.grid.MARGINX * 2)
  newframe.h = newframe.h - (ext.grid.MARGINY * 2)

  win:setframe(newframe)

  -- handle fixed-size windows which may no exceed the grid
  newframe = win:frame()
  if newframe.x + newframe.w > screenrect.x + screenrect.w then
    newframe.x = (screenrect.x + screenrect.w) - newframe.w
  end
  if newframe.y + newframe.h > screenrect.y + screenrect.h then
    newframe.y = (screenrect.y + screenrect.h) - newframe.h
  end
  if newframe ~= win:frame() then
    win:setframe(newframe)
  end
end

function ext.grid.adjust_window(win, fn)
  local w = win or window.focusedwindow()
  local f = ext.grid.get(w)
  fn(f)
  ext.grid.set(w, f, w:screen())
end

function ext.grid.setsimple(win, tbl)
  local len = #tbl
	ext.grid.adjust_window(win, function(f) 
    if len > 0 then f.x = tbl[1]; end
    if len > 1 then f.y = tbl[2]; end
    if len > 2 then f.w = tbl[3]; end
    if len > 3 then f.h = tbl[4]; end
  end)
end

function ext.grid.snap(win)
  if win:isstandard() then ext.grid.set(win, ext.grid.get(win), win:screen()) end
end

function ext.grid.snap_all()
  fnutils.map(window.visiblewindows(), ext.grid.snap)
end

function ext.grid.maximize_window(win)
  ext.grid.setsimple(win, {0, 0, ext.grid.GRIDWIDTH, ext.grid.GRIDHEIGHT})
end

function ext.grid.pushwindow_nextscreen()
  local win = window.focusedwindow()
  ext.grid.set(win, ext.grid.get(win), win:screen():next())
end

function ext.grid.pushwindow_prevscreen()
  local win = window.focusedwindow()
  ext.grid.set(win, ext.grid.get(win), win:screen():previous())
end

function ext.grid.pushwindow_toscreen(win, scr)
	local w = win or window.focusedwindow()
  
  local fullscreen_change = w:isfullscreen() and screen.allscreens()[scr] ~= w:screen()
  if fullscreen_change then
    w:setfullscreen(false)
    hydra.exec("sleep 3")
    w = utils.find_window(w:application():title())
  end
  ext.grid.set(w, ext.grid.get(w), screen.allscreens()[scr])
  if fullscreen_change then w:setfullscreen(true) end
end

function ext.grid.resizewindow_wider(win)
  ext.grid.adjust_window(win, function(f) f.w = math.min(f.w + 1, ext.grid.GRIDWIDTH - f.x) end)
end

function ext.grid.resizewindow_thinner(win)
  ext.grid.adjust_window(win, function(f) f.w = math.max(f.w - 1, 1) end)
end

function ext.grid.resizewindow_shorter(win)
  ext.grid.adjust_window(win, function(f) f.y = 0; f.h = math.max(f.h - 1, 1) end)
end

function ext.grid.resizewindow_taller(win)
  ext.grid.adjust_window(win, function(f) f.y = 0; f.h = math.min(f.h + 1, ext.grid.GRIDHEIGHT - f.y) end)
end

function ext.grid.movewindow_up(win)
  ext.grid.adjust_window(win, function(f) f.y = math.max(0, f.y - 1) end)
end

function ext.grid.movewindow_down(win)
  ext.grid.adjust_window(win, function(f) f.y = math.min(ext.grid.GRIDHEIGHT - f.h, f.y + 1) end)
end

function ext.grid.movewindow_left(win)
  ext.grid.adjust_window(win, function(f) f.x = math.max(0, f.x - 1) end)
end

function ext.grid.movewindow_right(win)
  ext.grid.adjust_window(win, function(f) f.x = math.min(ext.grid.GRIDWIDTH - f.w, f.x + 1) end)
end

function ext.grid.lefthalf(win)
  ext.grid.setsimple(win, {0, 0, ext.grid.GRIDWIDTH / 2, ext.grid.GRIDHEIGHT})
end

function ext.grid.righthalf(win)
  ext.grid.setsimple(win, {ext.grid.GRIDWIDTH / 2, 0, ext.grid.GRIDWIDTH / 2, ext.grid.GRIDHEIGHT})
end

function ext.grid.topleft(win)
  ext.grid.setsimple(win, {0, 0})
end

function ext.grid.bottomleft(win)
  ext.grid.adjust_window(win, function(f) f.x = 0; f.y = ext.grid.GRIDHEIGHT - f.h; end)
end

function ext.grid.topright(win)
  ext.grid.adjust_window(win, function(f) f.x = ext.grid.GRIDWIDTH - f.w; f.y = 0; end)
end

function ext.grid.bottomright(win)
  ext.grid.adjust_window(win, function(f) f.x = ext.grid.GRIDWIDTH - f.w; f.y = ext.grid.GRIDHEIGHT - f.h; end)
end
