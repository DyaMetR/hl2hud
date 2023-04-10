
if SERVER then return end

HL2HUD.settings = {} -- namespace

local PATH    = 'DATA'
local DIR     = 'hl2hud'
local CURRENT = DIR .. '\\current.dat'
local SCHEMES = DIR .. '\\schemes\\'
local FIND    = SCHEMES .. '\\*.dat'
local SCHEME  = SCHEMES .. '\\%s.dat'

local LOG_TITLE = Color(220, 220, 220)
local LOG_SUBTITLE = Color(255, 220, 0)
local LOG_VERSION = Color(128, 128, 128)
local LOG_NORMAL = Color(255, 255, 255)
local LOG_ERROR = Color(255, 0, 0)

HL2HUD.settings.overrides = {} -- submitted scheme overrides
local settings = HL2HUD.scheme.CreateDataTable() -- merged settings
local client -- client settings

--[[------------------------------------------------------------------
  Copies the default scheme into the current settings table.
]]--------------------------------------------------------------------
local function ApplyDefault()
  local default = HL2HUD.scheme.GetDefault()
  table.Empty(settings.ClientScheme.Colors)
  table.Empty(settings.HudTextures)
  settings.HudLayout = table.Copy(default.HudLayout)
  settings.HudAnimations = table.Copy(default.HudAnimations)
  HL2HUD.utils.MergeColours(settings.ClientScheme.Colors, default.ClientScheme.Colors)
  settings.ClientScheme.Fonts = table.Copy(default.ClientScheme.Fonts)
  HL2HUD.utils.MergeTables(settings.HudTextures, default.HudTextures)
end

--[[------------------------------------------------------------------
  Reloads the client scheme.
]]--------------------------------------------------------------------
function HL2HUD.settings.ReloadScheme()
  HL2HUD.settings.ApplyClientScheme()
  HL2HUD.settings.ApplyOverride()
  HL2HUD.settings.GenerateFonts()
  HL2HUD.animations.Clear() -- reset animations
  HL2HUD.elements.Init(settings) -- initialize HUD elements
  HL2HUD.animations.StartAnimationSequence('Init') -- start initialization animation
end

--[[------------------------------------------------------------------
  Applies the given scheme data to the client configuration.
  @param {table} scheme
]]--------------------------------------------------------------------
function HL2HUD.settings.Apply(scheme)
  client = table.Copy(scheme)
  HL2HUD.settings.ReloadScheme()
end

--[[------------------------------------------------------------------
  Applies the client configuration to the final scheme.
]]--------------------------------------------------------------------
function HL2HUD.settings.ApplyClientScheme()
  ApplyDefault()
  HL2HUD.utils.MergeSchemeLayers(settings, client)
end

--[[------------------------------------------------------------------
  Fetches all active overrides and applies them.
]]--------------------------------------------------------------------
function HL2HUD.settings.ApplyOverride()
  for _, override in pairs(HL2HUD.settings.overrides) do
    HL2HUD.utils.MergeSchemeLayers(settings, override)
  end
end

--[[------------------------------------------------------------------
  Generates the fonts for all HUD elements.
]]--------------------------------------------------------------------
function HL2HUD.settings.GenerateFonts()
  -- fonts used by icons
  local fonts = {}
  for _, icons in pairs(settings.HudTextures) do
    for _, icon in pairs(icons) do
      if icon.type ~= HL2HUD.scheme.ICON_FONT then continue end
      fonts[icon.font] = true
    end
  end
  for name, _ in pairs(fonts) do
    local font = settings.ClientScheme.Fonts[name]
    HL2HUD.fonts.Add(string.format(HL2HUD.scheme.ICON_FORMAT, name), font.font, font.size, font.weight, font.additive, font.blur, font.scanlines, font.symbol, font.scalable, font.antialias)
  end

  -- fonts used by parameters
  for e, element in pairs(HL2HUD.elements.All()) do
    for p, parameter in pairs(element.parameters) do
      if parameter.type ~= HL2HUD.elements.PARAM_FONT then continue end
      local font = settings.ClientScheme.Fonts[settings.HudLayout[e][p]]
      HL2HUD.fonts.Add(parameter.font, font.font, font.size, font.weight, font.additive, font.blur, font.scanlines, font.symbol, font.scalable, font.antialias)
    end
  end
end

--[[------------------------------------------------------------------
  Fetches a registered scheme by name and applies it.
  @param {string} name
]]--------------------------------------------------------------------
function HL2HUD.settings.Load(name)
  local scheme = HL2HUD.scheme.Get(name)
  if name == HL2HUD.scheme.default then scheme = HL2HUD.scheme.CreateDataTable() end
  HL2HUD.settings.Apply(scheme)
  HL2HUD.settings.Save()
end

--[[------------------------------------------------------------------
  Saves the given scheme to disk.
  @param {string} path to save to
  @param {table} scheme data
]]--------------------------------------------------------------------
function HL2HUD.settings.WriteSchemeToDisk(path, scheme)
  local data = table.Copy(scheme)
  for category, textures in pairs(data.HudTextures) do
    for icon, texture in pairs(textures) do
      if texture == -1 or texture.type ~= HL2HUD.scheme.ICON_SPRITE then continue end
      texture.texture = surface.GetTextureNameByID(texture.texture)
    end
  end
  file.Write(path, util.TableToJSON(data))
end

--[[------------------------------------------------------------------
  Loads and returns the scheme found in the given path.
  @param {string} path to read from
  @return {table} scheme data
]]--------------------------------------------------------------------
function HL2HUD.settings.LoadSchemeFromDisk(path)
  local scheme = util.JSONToTable(file.Read(path, PATH))
  for category, textures in pairs(scheme.HudTextures) do
    for icon, texture in pairs(textures) do
      if isnumber(texture.texture) then continue end -- check if it was already parsed (from a numeric key entry)
      if isnumber(icon) then -- fix for stored ammo types which get converted to numbers (such as 357)
        textures[tostring(icon)] = texture
        textures[icon] = nil
      end
      if texture == -1 or texture.type ~= HL2HUD.scheme.ICON_SPRITE then continue end
      texture.texture = surface.GetTextureID(texture.texture)
    end
  end
  return scheme
end

--[[------------------------------------------------------------------
  Initializes the client configuration.
]]--------------------------------------------------------------------
function HL2HUD.settings.Init()
  -- create missing directories
  if not file.Exists(DIR, PATH) then
    file.CreateDir(DIR)
    file.CreateDir(SCHEMES)
  end

  -- load schemes
  MsgC(LOG_TITLE, '\n  H λ L F - L I F E ²  \n-- CUSTOMIZABLE HUD --\n')
  MsgC(LOG_SUBTITLE, 'By DyaMetR\n', LOG_VERSION, 'v' .. HL2HUD.version .. '\n')
  local files = file.Find(FIND, PATH)
  for _, filename in pairs(files) do
    local scheme = HL2HUD.settings.LoadSchemeFromDisk(SCHEMES .. filename)
    HL2HUD.scheme.Register(scheme.Name, scheme, true)
  end
  MsgC(LOG_NORMAL, table.Count(files) .. ' schemes loaded.\n')

  -- load last used configuration
  if file.Exists(CURRENT, PATH) then
    MsgC(LOG_NORMAL, 'Loading previously saved configuration...\n')
    HL2HUD.settings.Apply(HL2HUD.settings.LoadSchemeFromDisk(CURRENT))
  else
    HL2HUD.settings.Load(HL2HUD.scheme.default)
  end

  MsgC(LOG_SUBTITLE, 'Done.\n\n')
end

--[[------------------------------------------------------------------
  Saves the current scheme.
]]--------------------------------------------------------------------
function HL2HUD.settings.Save()
  HL2HUD.settings.WriteSchemeToDisk(CURRENT, client)
  if not file.Exists(CURRENT, PATH) then MsgC(LOG_ERROR, 'Current scheme could not be saved!') end
end

--[[------------------------------------------------------------------
  Generates a file name for the given scheme name.
  @param {string} scheme name
  @return {string} file name
]]--------------------------------------------------------------------
function HL2HUD.settings.GenerateFileName(name)
  return string.lower(name)
end

--[[------------------------------------------------------------------
  Whether there's a file with the given name in the schemes folder.
  @param {string} filename
  @return {boolean} exists
]]--------------------------------------------------------------------
function HL2HUD.settings.SchemeFileExists(filename)
  return file.Exists(string.format(SCHEME, filename), PATH)
end

--[[------------------------------------------------------------------
  Saves the given scheme to the disk.
  @param {string} print name
  @param {table} scheme data
]]--------------------------------------------------------------------
function HL2HUD.settings.SaveAs(name, scheme)
  local filename = HL2HUD.settings.GenerateFileName(name)
  scheme.Name = name -- save original name
  scheme.FileName = filename -- save file name
  HL2HUD.settings.WriteSchemeToDisk(string.format(SCHEME, filename), scheme)
  if not file.Exists(CURRENT, PATH) then MsgC(LOG_ERROR, string.format('Could not save scheme %s!', name)) end
  HL2HUD.scheme.Register(name, scheme, true)
end

--[[------------------------------------------------------------------
  Deletes the given scheme from the schemes folder.
  @param {string} file name of the scheme
]]--------------------------------------------------------------------
function HL2HUD.settings.Delete(filename)
  file.Delete(string.format(SCHEME, filename))
end

--[[------------------------------------------------------------------
  Returns the current settings used.
  @return {table} settings
]]--------------------------------------------------------------------
function HL2HUD.settings.Get()
  return settings
end

--[[------------------------------------------------------------------
  Returns the client configuration.
  @return {table} client settings
]]--------------------------------------------------------------------
function HL2HUD.settings.Client()
  return client
end

--[[------------------------------------------------------------------
  Reset scheme to default.
]]--------------------------------------------------------------------
concommand.Add('hl2hud_reset', function() HL2HUD.settings.Load(HL2HUD.scheme.default) end)
