--[[------------------------------------------------------------------
  Half-Life 2 HUD
  Version 1.5.1
  May 2nd, 2023
  Made by DyaMetR
  * full credits found in the details below
]]--------------------------------------------------------------------

HL2HUD = HL2HUD or {}

-- hook name
HL2HUD.hookname			= 'hl2hud'

if CLIENT then
  -- addon information
  HL2HUD.name				= 'Half-Life 2 HUD'
  HL2HUD.version		= '1.5.1'
  HL2HUD.date				= 'May 2nd, 2023'
  HL2HUD.credits		= { -- {name, contribution}
    {'DyaMetR', 'Developer'},
    {'Valve Corporation', 'Original design\nCounter-Strike scheme design\nHalfLife2\nBoxRocket\nCounter-Strike font'},
    {'Team Garry', 'Default design'},
    {'Breadmen', 'Entropy Zero scheme design\nEntropy Zero 2 scheme design\nez2_hud'},
    {'TeamGT', '1187 scheme design'},
    {'SMOD Developer\'s Group', 'SMOD scheme design\nSMODGUI'},
    {'CD2 Development Team', 'Combine Destiny scheme design'},
    {'Crowbar Collective', 'Black Mesa scheme design\nBlack Mesa ammunition icons'},
    {'Eyaura', 'G String scheme design\nG String Beta scheme design\ngstring_crosshairs\ngstring2'},
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
    {'Dale Harris', 'Birdman'},
    {'Matthew Welch', 'White Rabbit'},
    {'Subhashish Panigrahi', 'eLePhAnT uNcLe'},
    {'Unknown', 'GarbageFont'},
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
