require 'moonscript'

import insert from table
alert = require 'mjolnir.alert'
hotkey = require 'mjolnir.hotkey'

modals = {} -- List of registered modals

class hotkey_modal
  new: (title, mods, key) =>
    insert(modals, @)
    @key = hotkey.bind(mods, key, -> @enter(self))
    @keys = {}
    @title = title
    @active = false

  bind: (mods, key, pressedfn, releasedfn) =>
    insert(@keys, hotkey.new(mods, key, pressedfn, releasedfn))

  disable_other_modals: (using modals) =>
    for m in *modals do if m != @ and m\is_active! then m\exit!

  enter: (using modals) =>
    @disable_other_modals!
    @active = true
    @key\disable()
    for key in *@keys do hotkey.enable(key)
    alert.show(@title .. ' Mode', 1)

  exit: =>
    @active = false
    for key in *@keys do hotkey.disable(key)
    @key\enable()
    alert.show("done", 0.5)
    
  is_active: => @active

hotkey_modal
