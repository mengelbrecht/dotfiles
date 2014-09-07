require 'moonscript'
import match from string
import push_toscreen, snap_all from require 'grid'
window = require 'mjolnir.window'

config = {}

find_windows = (app) ->
  [win for win in *window.allwindows() when match(win\application!\title!, app) != nil]

add = (title, tbl) -> config[title] = tbl

arrange_app = (app, config) ->
  for win in *find_windows(app)
    if config.unit then win\movetounit(config.unit)
    if config.screen then push_toscreen(win, config.screen)
    if config.action
      switch config.action
        when "close" then win\close!
        when "fullscreen" then win\setfullscreen(true)

arrange = (title) ->
  for app, config in pairs(config[title]) do arrange_app(app, config)
  snap_all!

{:add, :arrange}
