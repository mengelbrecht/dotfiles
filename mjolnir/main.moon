require 'moonscript'
alert = require 'mjolnir.alert'
hotkey = require 'mjolnir.hotkey'
arrangement = require 'arrangement'
grid = require 'grid'
hotkey_modal = require 'hotkey_modal'

----------------------------------------------------------------------------------------------------
-- Window Arrangements
----------------------------------------------------------------------------------------------------
home_arrangement =
  ["iTunes"]:     {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}},
  ["Mail"]:       {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}},
  ["Safari"]:     {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}},
  ["SourceTree"]: {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}},
  ["Spotify"]:    {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.8, h: 1.0}},
  ["Terminal"]:   {screen: 1, unit: {x: 0.5, y: 0.5, w: 0.5, h: 0.5}},
  ["TextMate"]:   {screen: 1, unit: {x: 0.5, y: 0.0, w: 0.5, h: 1.0}},
  ["Tower"]:      {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}},
  ["Xcode"]:      {screen: 1, unit: {x: 0.0, y: 0.0, w: 0.7, h: 1.0}}

arrangement.add("Home", home_arrangement)

work_arrangement =
  ["Dash"]:              {screen: 2, unit: {x: 0.0, y: 0.0, w: 0.5, h: 1.0}},
  ["iTunes"]:            {action: "close"},
  ["Parallels Desktop"]: {screen: 2, action: "fullscreen"},
  ["Safari"]:            {screen: 2, unit: {x: 0.0, y: 0.0, w: 1.0, h: 1.0}},
  ["SourceTree"]:        {screen: 1, unit: {x: 0.0, y: 0.0, w: 1.0, h: 1.0}},
  ["Terminal"]:          {screen: 1, unit: {x: 0.5, y: 0.5, w: 0.5, h: 0.5}},
  ["TextMate"]:          {screen: 2, unit: {x: 0.5, y: 0.0, w: 0.5, h: 1.0}},
  ["Tower"]:             {screen: 1, unit: {x: 0.0, y: 0.0, w: 1.0, h: 1.0}},
  ["Xcode"]:             {screen: 1, unit: {x: 0.0, y: 0.0, w: 1.0, h: 1.0}}
  
arrangement.add("Work", work_arrangement)

----------------------------------------------------------------------------------------------------
-- Hotkeys
----------------------------------------------------------------------------------------------------
arrangement_modifiers = {'cmd', 'shift'}
modal_modifiers = {'cmd', 'alt'}

hotkey.bind(arrangement_modifiers, '1', ->
  alert.show("Arranging Home", 1)
  arrangement.arrange('Home'))

hotkey.bind(arrangement_modifiers, '2', ->
  alert.show("Arranging Work", 1)
  arrangement.arrange('Work'))

split = hotkey_modal(modal_modifiers, '1')
split.entered = -> alert.show('Split Mode', 1)
split.exited = -> alert.show("done", 0.5)
split\bind({}, 'UP', grid.maximize)
split\bind({}, 'LEFT', grid.push_left_half)
split\bind({}, 'SPACE', grid.snap_all)
split\bind({}, 'RIGHT', grid.push_right_half)
split\bind({}, 'DOWN', grid.push_nextscreen)
split\bind({}, 'RETURN', -> split\exit!)

position = hotkey_modal(modal_modifiers, '2')
position.entered = -> alert.show('Position Mode', 1)
position.exited = -> alert.show("done", 0.5)
position\bind({}, 'LEFT', grid.position_topleft)
position\bind({}, 'UP', grid.position_topright)
position\bind({}, 'DOWN', grid.position_bottomleft)
position\bind({}, 'RIGHT', grid.position_bottomright)
position\bind({}, 'RETURN', -> position\exit!)

resize = hotkey_modal(modal_modifiers, '3')
resize.entered = -> alert.show('Resize Mode', 1)
resize.exited = -> alert.show("done", 0.5)
resize\bind({}, 'UP', grid.resize_shorter)
resize\bind({}, 'LEFT', grid.resize_thinner)
resize\bind({}, 'RIGHT', grid.resize_wider)
resize\bind({}, 'DOWN', grid.resize_taller)
resize\bind({}, 'RETURN', -> resize\exit!)

move = hotkey_modal(modal_modifiers, '4')
move.entered = -> alert.show('Move Mode', 1)
move.exited = -> alert.show("done", 0.5)
move\bind({}, 'UP', grid.move_up)
move\bind({}, 'DOWN', grid.move_down)
move\bind({}, 'LEFT', grid.move_left)
move\bind({}, 'RIGHT', grid.move_right)
move\bind({}, 'RETURN', -> move\exit!)

alert.show("Mjolnir loaded", 0.5)
