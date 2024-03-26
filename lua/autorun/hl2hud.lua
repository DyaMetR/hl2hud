--[[------------------------------------------------------------------
  Half-Life 2 HUD
  Version 1.7.3
  Match 26th, 2024
  Made by DyaMetR
  * full credits found in the details below
]]--------------------------------------------------------------------

HL2HUD = HL2HUD or {}

-- hook name
HL2HUD.hookname			= 'hl2hud'

if CLIENT then
  -- addon information
  HL2HUD.name				= 'Half-Life 2 HUD'
  HL2HUD.version		= '1.7.3'
  HL2HUD.date				= 'March 26th, 2024'
  HL2HUD.credits		= { -- {name, contribution}
    {'DyaMetR', '#hl2hud.credits.author'},
    {'Valve Corporation', '#hl2hud.credits.valve'},
    {'Facepunch', '#hl2hud.credits.facepunch'},
    {'Breadmen', '#hl2hud.credits.entropyzero'},
    {'TeamGT', '#hl2hud.credits.1187'},
    {'SMOD Developer\'s Group', '#hl2hud.credits.smod'},
    {'CD2 Development Team', '#hl2hud.credits.cd'},
    {'Crowbar Collective', '#hl2hud.credits.blackmesa'},
    {'Eyaura', '#hl2hud.credits.gstring'},
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
    {'Matsilagi', '#hl2hud.credits.other'},
    {'IRBS', '#hl2hud.credits.cn_localization'},
    {'NovaDiablox', '#hl2hud.credits.tr_localization'}
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
