require 'moonscript'

import insert from table
alert = require 'mjolnir.alert'
hotkey = require 'mjolnir.hotkey'
arrangement = require 'arrangement'
grid = require 'grid'
hotkey_modal = require 'hotkey_modal'
utils = require 'utils'

----------------------------------------------------------------------------------------------------
-- Grid and Arrangements
----------------------------------------------------------------------------------------------------
grid1 = grid(6, 6)

home = arrangement('Home')
home\add("iTunes",     {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}})
home\add("Mail",       {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}})
home\add("Safari",     {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}})
home\add("SourceTree", {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}})
home\add("Spotify",    {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.8, h: 1.0}})
home\add("Terminal",   {screen: 1, unit: {x: 0.5, y: 0.5, w: 0.5, h: 0.5}})
home\add("TextMate",   {screen: 1, unit: {x: 0.5, y: 0.0, w: 0.5, h: 1.0}})
home\add("Tower",      {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}})
home\add("Xcode",      {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}})

work = arrangement('Work')
work\add("Dash",              {screen: 2, unit: {x: 0.0, y: 0.0, w: 0.5, h: 1.0}})
work\add("iTunes",            {action: "close"})
work\add("Parallels Desktop", {screen: 2, action: "fullscreen"})
work\add("Safari",            {screen: 2, unit: {x: 0.0, y: 0.0, w: 1.0, h: 1.0}})
work\add("SourceTree",        {screen: 1, unit: {x: 0.0, y: 0.0, w: 1.0, h: 1.0}})
work\add("Terminal",          {screen: 1, unit: {x: 0.5, y: 0.5, w: 0.5, h: 0.5}})
work\add("TextMate",          {screen: 2, unit: {x: 0.5, y: 0.0, w: 0.5, h: 1.0}})
work\add("Tower",             {screen: 1, unit: {x: 0.0, y: 0.0, w: 1.0, h: 1.0}})
work\add("Xcode",             {screen: 1, unit: {x: 0.0, y: 0.0, w: 1.0, h: 1.0}})

----------------------------------------------------------------------------------------------------
-- Hotkey Bindings
----------------------------------------------------------------------------------------------------
modal_modifiers = {'cmd', 'alt'}
arrangement_modifiers = {'cmd', 'shift'}

split = hotkey_modal('Split', modal_modifiers, '1')
split\bind({}, 'UP', utils.maximize)
split\bind({}, 'LEFT', utils.push_left_half)
split\bind({}, 'SPACE', grid1\snap_all)
split\bind({}, 'RIGHT', utils.push_right_half)
split\bind({}, 'DOWN', utils.push_nextscreen)
split\bind({}, 'RETURN', split\exit)

position = hotkey_modal('Position', modal_modifiers, '2')
position\bind({}, 'LEFT', grid1\position_topleft)
position\bind({}, 'UP', grid1\position_topright)
position\bind({}, 'DOWN', grid1\position_bottomleft)
position\bind({}, 'RIGHT', grid1\position_bottomright)
position\bind({}, 'RETURN', position\exit)

resize = hotkey_modal('Resize', modal_modifiers, '3')
resize\bind({}, 'UP', grid1\resize_shorter)
resize\bind({}, 'LEFT', grid1\resize_thinner)
resize\bind({}, 'RIGHT', grid1\resize_wider)
resize\bind({}, 'DOWN', grid1\resize_taller)
resize\bind({}, 'RETURN', resize\exit)

move = hotkey_modal('Move', modal_modifiers, '4')
move\bind({}, 'UP', grid1\move_up)
move\bind({}, 'DOWN', grid1\move_down)
move\bind({}, 'LEFT', grid1\move_left)
move\bind({}, 'RIGHT', grid1\move_right)
move\bind({}, 'RETURN', move\exit)

arrange = (a) ->
  a\perform_all!
  grid1\snap_all!

hotkey.bind(arrangement_modifiers, '1', -> arrange(home))
hotkey.bind(arrangement_modifiers, '2', -> arrange(work))

----------------------------------------------------------------------------------------------------
alert.show("Mjolnir loaded", 0.5)
