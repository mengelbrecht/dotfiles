require('grid')
require('utils')

arrangement = {}

arrangement.config = {}

function arrangement.add(title, tbl)
  arrangement.config[title] = tbl
end

function arrangement.arrange_app(app, config)
  local win = utils.find_window(app)
  if win == nil then return end

  if config.grid then ext.grid.setsimple(win, config.grid) end
  if config.screen then ext.grid.pushwindow_toscreen(win, config.screen) end
  if config.action then
    if config.action == "close" then win:close()
    elseif config.action == "fullscreen" then win:setfullscreen(true)
    end
  end
end

function arrangement.arrange(title)
  hydra.alert("Arranging " .. title, 1)
  for app, config in pairs (arrangement.config[title]) do
    arrangement.arrange_app(app, config)
  end
  ext.grid.snap_all()
end

function arrangement.menu_items(menu)
  local items = {}
  for title in pairs(arrangement.config) do
    table.insert(items, {title = "  " .. title, fn = function() arrangement.arrange(title) end})
  end
  table.sort(items, function(a, b) return a.title < b.title end)
  table.insert(items, 1, {title = "Arrangement", disabled = true})
  return items
end
