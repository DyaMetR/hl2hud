
if SERVER then return end

local PANEL = {}

local BUTTON_WIDTH  = 128
local BUTTON_MARGIN = 3

--[[------------------------------------------------------------------
  Creates the list and options panel.
]]--------------------------------------------------------------------
function PANEL:Init()
  local options = vgui.Create('Panel', self)
  options:Dock(BOTTOM)
  options:DockMargin(0, BUTTON_MARGIN, 0, 0)

    local reset = vgui.Create('DPanel', options)
    reset:Dock(LEFT)
    reset:SetWide(BUTTON_WIDTH)

      local button = vgui.Create('DButton', reset)
      button:Dock(FILL)
      button:DockPadding(BUTTON_MARGIN, BUTTON_MARGIN, BUTTON_MARGIN, BUTTON_MARGIN)
      button:SetText('#hl2hud.menu.clientscheme.reset')
      button:SetIcon('icon16/bomb.png')
      button.DoClick = function() self:DoReset() end
      self.Button = button

    local bottom = vgui.Create('DPanel', options)
    bottom:Dock(FILL)
    bottom:DockMargin(BUTTON_MARGIN, 0, 0, 0)
    self.Bottom = bottom

  local list = vgui.Create('HL2HUD_PanelList', self)
  list:Dock(FILL)
  self.List = list
end

--[[------------------------------------------------------------------
  Creates the given panel and adds it to the bottom section.
  @param {string} panel class
  @return {Panel} created panel
]]--------------------------------------------------------------------
function PANEL:AddBottom(class)
  self.Bottom:Clear()
  local panel = vgui.Create(class, self.Bottom)
  panel:Dock(FILL)
  return panel
end

--[[------------------------------------------------------------------
  Adds a panel to the list.
  @param {string} panel class
  @return {Panel} created line
  @return {Panel} created panel
]]--------------------------------------------------------------------
function PANEL:AddLine(class)
  local line, panel = self.List:AddLine(class)
  panel:Dock(FILL)
  return line, panel
end

--[[------------------------------------------------------------------
  Sets the button's text and icon.
  @param {string} text
  @param {string} icon
]]--------------------------------------------------------------------
function PANEL:SetButton(text, icon)
  self.Button:SetText(text)
  self.Button:SetIcon(icon)
end

--[[------------------------------------------------------------------
  Clears the list.
]]--------------------------------------------------------------------
function PANEL:Clear()
  self.List:Clear()
end

--[[------------------------------------------------------------------
  Called when the reset button is pressed.
]]--------------------------------------------------------------------
function PANEL:DoReset() end

vgui.Register('HL2HUD_ResourceList', PANEL, 'Panel')
