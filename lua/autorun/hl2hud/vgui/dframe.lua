
if SERVER then return end

local PANEL = {}

local BUTTON_WIDTH  = 75
local BUTTON_HEIGHT = 23
local BUTTON_MARGIN = 3

local LOCALE_APPLY  = 'Apply'
local LOCALE_CANCEL = 'Cancel'
local LOCALE_OK     = 'OK'

--[[------------------------------------------------------------------
  Creates a button from the bottom options.
  @param {Panel} parent panel
  @param {string} text
  @return {DButton} button
]]--------------------------------------------------------------------
local function OptionButton(parent, text)
  local button = vgui.Create('DButton', parent)
  button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
  button:Dock(RIGHT)
  button:DockMargin(0, 0, BUTTON_MARGIN, 0)
  button:SetText(text)
  return button
end

--[[------------------------------------------------------------------
  Initialize property sheet, buttons and menu bar.
]]--------------------------------------------------------------------
function PANEL:Init()
  -- menu bar
  local menu = vgui.Create('DMenuBar', self)
  menu:Dock(TOP)
  menu:DockMargin(0, 0, 0, BUTTON_MARGIN)
  self.MenuBar = menu

  -- scheme options
  local options = vgui.Create('Panel', self)
  options:Dock(BOTTOM)
  options:DockMargin(0, BUTTON_MARGIN, 0, 0)

    -- apply scheme
    local apply = OptionButton(options, LOCALE_APPLY)
    apply.DoClick = function() self:ApplyScheme() end

    -- cancel
    local cancel = OptionButton(options, LOCALE_CANCEL)
    cancel.DoClick = function() self:Close() end

    -- apply and close
    local ok = OptionButton(options, LOCALE_OK)
    ok.DoClick = function()
      self:ApplyScheme()
      self:Close()
    end

  -- property sheet
  local properties = vgui.Create('DPropertySheet', self)
  properties:Dock(FILL)
  self.PropertySheet = properties
end

--[[------------------------------------------------------------------
  Adds a menu to the menu bar.
  @param {string} label
  @return {DMenu} created menu
]]--------------------------------------------------------------------
function PANEL:AddMenu(menu)
  return self.MenuBar:AddMenu(menu)
end

--[[------------------------------------------------------------------
  Adds a sheet to the property sheet.
  @param {string} name
  @param {Panel} panel
  @param {string} icon
  @param {string} description
  @return {table} tab properties
]]--------------------------------------------------------------------
function PANEL:AddSheet(name, panel, icon, description)
  return self.PropertySheet:AddSheet(name, panel, icon, nil, nil, description)
end

--[[------------------------------------------------------------------
  Called to apply the currently cached scheme.
]]--------------------------------------------------------------------
function PANEL:ApplyScheme() end

vgui.Register('HL2HUD_Frame', PANEL, 'DFrame')
