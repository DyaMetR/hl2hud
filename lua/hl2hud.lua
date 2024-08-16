--[[------------------------------------------------------------------
  Manual initialization script.
  Run this if you're on a server that allows sv_allowcslua.

  WARNING: The following features will NOT work since they require
  the server-side part of the HUD to run, and it won't.
  - Poison damage indicator
  - FULL ammunition pickup message
  - Vehicle crosshairs
  - Squad status
]]--------------------------------------------------------------------

if SERVER then return end

include('autorun/hl2hud.lua') -- initialize HUD
UnintrusiveBindPress.init() -- manually initialize bind press
