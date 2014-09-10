require 'moonscript'

import floor from math
import match from string
screen = require 'mjolnir.screen'
window = require 'mjolnir.window'

round = (num) -> floor(num + 0.5)

find_windows = (appname) ->
  [win for win in *window.allwindows() when match(win\application!\title!, appname) != nil]

maximize = (win=window.focusedwindow!) -> win\maximize!
push_left_half = (win=window.focusedwindow!) -> win\movetounit({x: 0.0, y: 0.0, w: 0.5, h: 1.0})
push_right_half = (win=window.focusedwindow!) -> win\movetounit({x: 0.5, y: 0.0, w: 0.5, h: 1.0})

push_toscreen = (win, scr) ->
  win = win or window.focusedwindow!
  s = if type(scr) == 'number' then screen.allscreens![scr] else scr
  s = s or win\screen!
  id = win\id!

  fullscreen_change = win\isfullscreen! and s != win\screen!
  if fullscreen_change then
    win\setfullscreen(false)
    os.execute('sleep 3')
    win = window.windowforid(id)

  screenframe_old = win\screen!\frame!
  screenframe_new = s\frame!
  topleft = win\topleft!
  topleft = {
    x: topleft.x - screenframe_old.x + screenframe_new.x,
    y: topleft.y - screenframe_old.y + screenframe_new.y
  }
  
  win\settopleft(topleft)

  if fullscreen_change then win\setfullscreen(true)

push_nextscreen = (win=window.focusedwindow!) -> push_toscreen(win, win\screen!\next!)
push_prevscreen = (win=window.focusedwindow!) -> push_toscreen(win, win\screen!\previous!)

{
  :round, :find_windows,
  :maximize, :push_left_half, :push_right_half,
  :push_nextscreen, :push_prevscreen, :push_toscreen
}
