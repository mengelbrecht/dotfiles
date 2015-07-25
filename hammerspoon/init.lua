require 'action'
require 'grid'
require 'hotkey_modal'
require 'profile'

----------------------------------------------------------------------------------------------------
-- Profiles
----------------------------------------------------------------------------------------------------
local grid1 = Grid.new(6, 6)

local home = Profile.new('Home', {69671680}, {
  ["Atom"]          = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["Google Chrome"] = {Action.MoveToScreen.new(2), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["iTunes"]        = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["Mail"]          = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["Reeder"]        = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["Safari"]        = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["SourceTree"]    = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["Spotify"]       = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.8, 1.0)},
  ["Terminal"]      = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.5, 0.5, 0.5, 0.5)},
  ["TextMate"]      = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.5, 0.0, 0.5, 1.0)},
  ["Xcode"]         = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 0.7, 1.0)},
  ["_"]             = {Action.Snap.new(grid1)}
})

----------------------------------------------------------------------------------------------------

local work = Profile.new('Work', {69732352, 188898833, 188898834, 188915586}, {
  ["Atom"]              = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["Dash"]              = {Action.MoveToScreen.new(2), Action.MoveToUnit.new(0.0, 0.0, 0.5, 1.0)},
  ["Google Chrome"]     = {Action.MoveToScreen.new(2), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["iTunes"]            = {Action.Close.new()},
  ["Parallels Desktop"] = {Action.MoveToScreen.new(2), Action.FullScreen.new()},
  ["Safari"]            = {Action.MoveToScreen.new(2), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["SourceTree"]        = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["Terminal"]          = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.5, 0.5, 0.5, 0.5)},
  ["TextMate"]          = {Action.MoveToScreen.new(2), Action.MoveToUnit.new(0.5, 0.0, 0.5, 1.0)},
  ["Tower"]             = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["Xcode"]             = {Action.MoveToScreen.new(1), Action.MoveToUnit.new(0.0, 0.0, 1.0, 1.0)},
  ["_"]                 = {Action.Snap.new(grid1)}
})

----------------------------------------------------------------------------------------------------
-- Hotkey Bindings
----------------------------------------------------------------------------------------------------

local splitModifiers = {'ctrl', 'alt'}
local modalModifiers = {'cmd', 'alt'}
local arrangementModifiers = {'cmd', 'shift'}

hs.hotkey.bind(splitModifiers, 'UP', function() Action.Maximize.new():perform() end)
hs.hotkey.bind(splitModifiers, 'DOWN', function() Action.MoveToNextScreen.new():perform() end)
hs.hotkey.bind(splitModifiers, 'LEFT', function() Action.MoveToUnit.new(0.0, 0.0, 0.5, 1.0):perform() end)
hs.hotkey.bind(splitModifiers, 'RIGHT', function() Action.MoveToUnit.new(0.5, 0.0, 0.5, 1.0):perform() end)
hs.hotkey.bind(splitModifiers, 'SPACE', function() grid1:snapAll() end)
hs.hotkey.bind(splitModifiers, 'H', function() hs.hints.windowHints() end)

local position = HotkeyModal.new('Position', modalModifiers, '1')
position:bind({}, 'UP', function() grid1:positionTopRight() end)
position:bind({}, 'DOWN', function() grid1:positionBottomLeft() end)
position:bind({}, 'LEFT', function() grid1:positionTopLeft() end)
position:bind({}, 'RIGHT', function() grid1:positionBottomRight() end)
position:bind({}, 'RETURN', function() position:exit() end)

local resize = HotkeyModal.new('Resize', modalModifiers, '2')
resize:bind({}, 'UP', function() grid1:resizeShorter() end)
resize:bind({}, 'DOWN', function() grid1:resizeTaller() end)
resize:bind({}, 'LEFT', function() grid1:resizeThinner() end)
resize:bind({}, 'RIGHT', function() grid1:resizeWider() end)
resize:bind({}, 'RETURN', function() resize:exit() end)

local move = HotkeyModal.new('Move', modalModifiers, '3')
move:bind({}, 'UP', function() grid1:moveUp() end)
move:bind({}, 'DOWN', function() grid1:moveDown() end)
move:bind({}, 'LEFT', function() grid1:moveLeft() end)
move:bind({}, 'RIGHT', function() grid1:moveRight() end)
move:bind({}, 'RETURN', function() move:exit() end)

local appShortcuts = {
  ['a'] = 'Atom',
  ['c'] = 'Google Chrome',
  ['d'] = 'Dash',
  ['e'] = 'TextMate',
  ['f'] = 'Finder',
  ['g'] = 'Tower',
  ['m'] = 'iTunes',
  ['p'] = 'Parallels Desktop',
  ['t'] = 'Terminal',
  ['x'] = 'Xcode',
}

for shortcut, appName in pairs(appShortcuts) do
  hs.hotkey.bind({'alt', 'cmd'}, shortcut, function() hs.application.launchOrFocus(appName) end)
end

hs.hotkey.bind(arrangementModifiers, '1', function() Profile.activateActiveProfile() end)
hs.hotkey.bind(arrangementModifiers, '2', function() home:activate() end)
hs.hotkey.bind(arrangementModifiers, '3', function() work:activate() end)

----------------------------------------------------------------------------------------------------
-- Settings and Watcher
----------------------------------------------------------------------------------------------------
hs.window.animationDuration = 0.1

hs.application.watcher.new(
  function(appName, event)
    if event == hs.application.watcher.launched then
      local profile = Profile.activeProfile()
      local app = hs.appfinder.appFromName(appName)
      if profile and app then profile:activateFor(app) end
    end
  end
):start()

hs.screen.watcher.new(
  function()
    Profile.checkKnownProfile()
    Profile.activateActiveProfile()
  end
):start()

hs.pathwatcher.new(hs.configdir,
  function(files)
    hs.reload()
  end
):start()

hs.alert("Hammerspoon loaded", 1)

Profile.checkKnownProfile()
