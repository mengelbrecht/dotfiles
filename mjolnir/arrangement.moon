require 'moonscript'

import find_windows, push_toscreen from require 'utils'
alert = require 'mjolnir.alert'

class arrangement
  new: (title) =>
    @apps = {}
    @title = title

  add: (appname, config) => @apps[appname] = config

  perform: (appname) =>
    config = @apps[appname]
    for win in *find_windows(appname)
      if config.unit then win\movetounit(config.unit)
      if config.screen then push_toscreen(win, config.screen)
      if config.action
        switch config.action
          when "close" then win\close!
          when "fullscreen" then win\setfullscreen(true)

  perform_all: =>
    alert.show('Arranging ' .. @title, 1)
    for appname,_ in pairs(@apps) do @perform(appname)

arrangement
