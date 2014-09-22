require 'moonscript'

import min, max from math
import round from require 'utils'
window = require 'mjolnir.window'
screen = require 'mjolnir.screen'

class grid
  new: (width=6, height=6) =>
    @width = width
    @height = height
    
  get: (win) =>
    winframe = win\frame!
    screenframe = win\screen!\frame!
    ratiowidth = screenframe.w / @width
    ratioheight = screenframe.h / @height
    {
      x: round((winframe.x - screenframe.x) / ratiowidth),
      y: round((winframe.y - screenframe.y) / ratioheight),
      w: max(1, round(winframe.w / ratiowidth)),
      h: max(1, round(winframe.h / ratioheight)),
    }

  set: (win, gr, scr) =>
    scr = scr or win\screen!
    screenframe = scr\frame!
    ratiowidth = screenframe.w / @width
    ratioheight = screenframe.h / @height
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

  adjust_window: (win, fn) =>
    win = win or window.focusedwindow!
    grid = @get(win)
    for k,v in pairs(fn(grid)) do grid[k] = v
    @set(win, grid, win\screen!)

  snap: (win=window.focusedwindow!) => if win\isstandard! then @set(win, @get(win), win\screen!)
  snap_all: => for win in *window.visiblewindows! do @snap(win)

  resize_wider: (win=nil) => @adjust_window(win, (f) -> {w: min(f.w + 1.0, @width - f.x)})
  resize_thinner: (win=nil) => @adjust_window(win, (f) -> {w: max(f.w - 1.0, 1.0)})
  resize_shorter: (win=nil) => @adjust_window(win, (f) -> {y: f.y, h: max(f.h - 1.0, 1.0)})
  resize_taller: (win=nil) => @adjust_window(win, (f) -> {y: f.y, h: min(f.h + 1.0, @height - f.y)})

  move_up: (win=nil) => @adjust_window(win, (f) -> {y: max(0.0, f.y - 1.0)})
  move_down: (win=nil) => @adjust_window(win, (f) -> {y: min(@height - f.h, f.y + 1.0)})
  move_left: (win=nil) => @adjust_window(win, (f) -> {x: max(0.0, f.x - 1.0)})
  move_right: (win=nil) => @adjust_window(win, (f) -> {x: min(@width - f.w, f.x + 1.0)})

  position_topleft: (win=nil) => @adjust_window(win, (f) -> {x: 0.0, y: 0.0})
  position_bottomleft: (win=nil) => @adjust_window(win, (f) -> {x: 0.0, y: @height - f.h})
  position_topright: (win=nil) => @adjust_window(win, (f) -> {x: @width - f.w, y: 0.0})
  position_bottomright: (win=nil) => @adjust_window(win, (f) -> {x: @width - f.w, y: @height - f.h})

grid
