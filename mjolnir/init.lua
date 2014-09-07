package.path = os.getenv("HOME") .. "/.mjolnir/rocks/share/lua/5.2/?.lua;" ..
               os.getenv("HOME") .. "/.mjolnir/rocks/share/lua/5.2/?/init.lua;" ..
               os.getenv("HOME") .. "/.mjolnir/?.lua;" ..
               package.path .. ";./?/init.lua"
package.cpath = os.getenv("HOME") .. "/.mjolnir/rocks/lib/lua/5.2/?.so;" .. package.cpath

require 'moonscript'
require 'main'
