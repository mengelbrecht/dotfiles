utils = {}

function utils.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function utils.find_window(app)
    return fnutils.find(window.allwindows(), function(window)
        return string.match(window:application():title(), app) ~= nil
    end)
end
