ext.grid = {}

ext.grid.MARGINX = 0
ext.grid.MARGINY = 0
ext.grid.GRIDHEIGHT = 6
ext.grid.GRIDWIDTH = 6

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function ext.grid.get(win)
  local winframe = win:frame()
  local screenrect = win:screen():frame_without_dock_or_menu()
  local thirdscreenwidth = screenrect.w / ext.grid.GRIDWIDTH
  local halfscreenheight = screenrect.h / ext.grid.GRIDHEIGHT
  return {
    x = round((winframe.x - screenrect.x) / thirdscreenwidth),
    y = round((winframe.y - screenrect.y) / halfscreenheight),
    w = math.max(1, round(winframe.w / thirdscreenwidth)),
    h = math.max(1, round(winframe.h / halfscreenheight)),
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

function ext.grid.adjust_focused_window(fn)
  local win = window.focusedwindow()
  local f = ext.grid.get(win)
  fn(f)
  ext.grid.set(win, f, win:screen())
end

function ext.grid.snap(win)
  if win:isstandard() then
    ext.grid.set(win, ext.grid.get(win), win:screen())
  end
end

function ext.grid.maximize_window()
  ext.grid.adjust_focused_window(function(f) f.x = 0; f.y = 0; f.w = ext.grid.GRIDWIDTH; f.h = ext.grid.GRIDHEIGHT; end)
end

function ext.grid.pushwindow_nextscreen()
  local win = window.focusedwindow()
  ext.grid.set(win, ext.grid.get(win), win:screen():next())
end

function ext.grid.pushwindow_prevscreen()
  local win = window.focusedwindow()
  ext.grid.set(win, ext.grid.get(win), win:screen():previous())
end

function ext.grid.resizewindow_wider()
  ext.grid.adjust_focused_window(function(f) f.w = math.min(f.w + 1, ext.grid.GRIDWIDTH - f.x) end)
end

function ext.grid.resizewindow_thinner()
  ext.grid.adjust_focused_window(function(f) f.w = math.max(f.w - 1, 1) end)
end

function ext.grid.resizewindow_shorter()
  ext.grid.adjust_focused_window(function(f) f.y = 0; f.h = math.max(f.h - 1, 1) end)
end

function ext.grid.resizewindow_taller()
  ext.grid.adjust_focused_window(function(f) f.y = 0; f.h = math.min(f.h + 1, ext.grid.GRIDHEIGHT - f.y) end)
end

function ext.grid.movewindow_up()
  ext.grid.adjust_focused_window(function(f) f.y = math.max(0, f.y - 1) end)
end

function ext.grid.movewindow_down()
  ext.grid.adjust_focused_window(function(f) f.y = math.min(ext.grid.GRIDHEIGHT - f.h, f.y + 1) end)
end

function ext.grid.movewindow_left()
  ext.grid.adjust_focused_window(function(f) f.x = math.max(0, f.x - 1) end)
end

function ext.grid.movewindow_right()
  ext.grid.adjust_focused_window(function(f) f.x = math.min(ext.grid.GRIDWIDTH - f.w, f.x + 1) end)
end

function ext.grid.lefthalf()
  ext.grid.adjust_focused_window(function(f) f.x = 0; f.y = 0; f.w = ext.grid.GRIDWIDTH / 2; f.h = ext.grid.GRIDHEIGHT; end)
end

function ext.grid.righthalf()
  ext.grid.adjust_focused_window(function(f) f.x = ext.grid.GRIDWIDTH / 2; f.y = 0; f.w = ext.grid.GRIDWIDTH / 2; f.h = ext.grid.GRIDHEIGHT; end)
end

function ext.grid.topleft()
  ext.grid.adjust_focused_window(function(f) f.x = 0; f.y = 0; end)
end

function ext.grid.bottomleft()
  ext.grid.adjust_focused_window(function(f) f.x = 0; f.y = ext.grid.GRIDHEIGHT - f.h; end)
end

function ext.grid.topright()
  ext.grid.adjust_focused_window(function(f) f.x = ext.grid.GRIDWIDTH - f.w; f.y = 0; end)
end

function ext.grid.bottomright()
  ext.grid.adjust_focused_window(function(f) f.x = ext.grid.GRIDWIDTH - f.w; f.y = ext.grid.GRIDHEIGHT - f.h; end)
end