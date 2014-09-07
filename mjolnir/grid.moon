require 'moonscript'
import floor, min, max from math
window = require 'mjolnir.window'
screen = require 'mjolnir.screen'
fnutils = require 'mjolnir.fnutils'

GRIDHEIGHT = 6
GRIDWIDTH = 6

round = (num) -> floor(num + 0.5)

get = (win) ->
  winframe = win\frame!
  screenframe = win\screen!\frame!
  ratiowidth = screenframe.w / GRIDWIDTH
  ratioheight = screenframe.h / GRIDHEIGHT
  {
    x: round((winframe.x - screenframe.x) / ratiowidth),
    y: round((winframe.y - screenframe.y) / ratioheight),
    w: max(1, round(winframe.w / ratiowidth)),
    h: max(1, round(winframe.h / ratioheight)),
  }


set = (win, gr, scr) ->
  scr = scr or win\screen!
  screenframe = scr\frame!
  ratiowidth = screenframe.w / GRIDWIDTH
  ratioheight = screenframe.h / GRIDHEIGHT
  newframe = {
    x: (gr.x * ratiowidth) + screenframe.x,
    y: (gr.y * ratioheight) + screenframe.y,
    w: gr.w * ratiowidth,
    h: gr.h * ratioheight,
  }

  win\setframe(newframe)

  -- handle fixed-size windows which may exceed the grid
  newframe = win\frame!
  if newframe.x + newframe.w > screenframe.x + screenframe.w then
    newframe.x = (screenframe.x + screenframe.w) - newframe.w
  if newframe.y + newframe.h > screenframe.y + screenframe.h then
    newframe.y = (screenframe.y + screenframe.h) - newframe.h
  if newframe != win\frame! then
    win\setframe(newframe)


adjust_window = (win, fn) ->
  win = win or window.focusedwindow!
  grid = get(win)
  for k,v in pairs(fn(grid)) do grid[k] = v
  set(win, grid, win\screen!)

snap = (win=window.focusedwindow!) -> if win\isstandard! then set(win, get(win), win\screen!)
snap_all = -> for win in *window.visiblewindows! do snap(win)
maximize = (win=window.focusedwindow!) -> win\maximize!

push_nextscreen = (win=window.focusedwindow!) -> set(win, get(win), win\screen!\next!)
push_prevscreen = (win=window.focusedwindow!) -> set(win, get(win), win\screen!\previous!)

push_toscreen = (win, scr) ->
  win = win or window.focusedwindow!
  s = screen.allscreens![scr]
  id = win\id!

  fullscreen_change = win\isfullscreen! and s != win\screen!
  if fullscreen_change then
    win\setfullscreen(false)
    os.execute('sleep 3')
    win = window.windowforid(id)

  set(win, get(win), s)
  if fullscreen_change then win\setfullscreen(true)


push_left_half = (win=window.focusedwindow!) -> win\movetounit({x: 0.0, y: 0.0, w: 0.5, h: 1.0})
push_right_half = (win=window.focusedwindow!) -> win\movetounit({x: 0.5, y: 0.0, w: 0.5, h: 1.0})

resize_wider = (win=nil) -> adjust_window(win, (f) -> {w: min(f.w + 1.0, GRIDWIDTH - f.x)})
resize_thinner = (win=nil) -> adjust_window(win, (f) -> {w: max(f.w - 1.0, 1.0)})
resize_shorter = (win=nil) -> adjust_window(win, (f) -> {y: 0.0, h: max(f.h - 1.0, 1.0)})
resize_taller = (win=nil) -> adjust_window(win, (f) -> {y: 0.0, h: min(f.h + 1.0, GRIDHEIGHT - f.y)})

move_up = (win=nil) -> adjust_window(win, (f) -> {y: max(0.0, f.y - 1.0)})
move_down = (win=nil) -> adjust_window(win, (f) -> {y: min(GRIDHEIGHT - f.h, f.y + 1.0)})
move_left = (win=nil) -> adjust_window(win, (f) -> {x: max(0.0, f.x - 1.0)})
move_right = (win=nil) -> adjust_window(win, (f) -> {x: min(GRIDWIDTH - f.w, f.x + 1.0)})

position_topleft = (win=nil) -> adjust_window(win, (f) -> {x: 0.0, y: 0.0})
position_bottomleft = (win=nil) -> adjust_window(win, (f) -> {x: 0.0, y: GRIDHEIGHT - f.h})
position_topright = (win=nil) -> adjust_window(win, (f) -> {x: GRIDWIDTH - f.w, y: 0.0})
position_bottomright = (win=nil) -> adjust_window(win, (f) -> {x: GRIDWIDTH - f.w, y: GRIDHEIGHT - f.h})

{
  :GRIDWIDTH, :GRIDHEIGHT,
  :snap, :snap_all, :maximize,
  :push_nextscreen, :push_prevscreen, :push_toscreen, :push_left_half, :push_right_half,
  :resize_wider, :resize_thinner, :resize_shorter, :resize_taller,
  :move_up, :move_down, :move_left, :move_right,
  :position_topleft, :position_bottomleft, :position_topright, :position_bottomright
}
