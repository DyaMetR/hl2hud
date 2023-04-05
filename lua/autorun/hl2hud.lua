--[[------------------------------------------------------------------
  Half-Life 2 HUD
  Version 1.0.4
  April 4th, 2023
  Made by DyaMetR
  * full credits found in the details below
]]--------------------------------------------------------------------

HL2HUD = {}

-- hook name
HL2HUD.hookname			= 'hl2hud'

if CLIENT then
  -- addon information
  HL2HUD.name				= 'Half-Life 2 HUD'
  HL2HUD.category		= 'DyaMetR'
  HL2HUD.version		= '1.0.4'
  HL2HUD.date				= 'April 4th, 2023'
  HL2HUD.credits		= { -- {name, contribution}
    {'DyaMetR', 'Developer'},
    {'Valve Corporation', 'Original design\nCounter-Strike scheme design\nHalfLife2\nBoxRocket\nCounter-Strike font'},
    {'Team Garry', 'Default design'},
    {'Breadmen', 'Entropy Zero scheme design\nEntropy Zero 2 scheme design'},
    {'TeamGT', '1187 scheme design'},
    {'SMOD Developer\'s Group', 'SMOD scheme design\nSMODGUI'},
    {'CD2 Development Team', 'Combine Destiny scheme design'},
    {'Crowbar Collective', 'Black Mesa scheme design\nBlack Mesa ammunition icons'},
    {'Albert-Jan Pool', 'DIN'},
    {'Michael Moss', 'Android Insomnia'},
    {'Ray Larabie', 'Frak\nPricedown'},
    {'Nick Shinn', 'Alphaville Light'},
    {'Benn Coifman', 'Empire Builder'},
    {'Peter Wiegel', 'Alte Din 1451 Mittelschrift'},
    {'Brian J. Bonislawsky', 'Transponder AOE'},
    {'Leandro Ribeiro', 'Cogan-Light'},
    {'Mehmet Abacı', 'Typo Digit'},
    {'Dusit Supasawat', 'DS-Digital'},
    {'Microsoft Corporation', 'Bahnschrift Light'},
    {'Randy Ford', 'Futured'},
    {'Matsilagi', 'Additional testing'}
  }
end

--[[------------------------------------------------------------------
Includes a file sharedwise
@param {string} file
]]--------------------------------------------------------------------
function HL2HUD.include(path)
  include(path)
  if SERVER then AddCSLuaFile(path) end
end

-- include core
HL2HUD.include('hl2hud/init.lua')
