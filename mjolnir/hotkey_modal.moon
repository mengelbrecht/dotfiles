require 'moonscript'
import insert from table
hotkey = require 'mjolnir.hotkey'

class hotkey_modal
  new: (mods, key) =>
    @key = hotkey.bind(mods, key, -> @enter(self))
    @keys = {}

  bind: (mods, key, pressedfn, releasedfn) =>
    insert(@keys, hotkey.new(mods, key, pressedfn, releasedfn))

  enter: =>
    @key\disable()
    for key in *@keys do hotkey.enable(key)
    @entered()

  exit: =>
    for key in *@keys do hotkey.disable(key)
    @key\enable()
    @exited()
    
  entered: =>
  exited: =>

hotkey_modal
