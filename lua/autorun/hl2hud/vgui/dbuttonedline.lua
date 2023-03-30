
if SERVER then return end

local PANEL = {}

local BUTTON_SIZE, BUTTON_MARGIN = 16, 4

--[[------------------------------------------------------------------
  Creates the button panel.
]]--------------------------------------------------------------------
function PANEL:Init()
  local buttons = vgui.Create('Panel', self)
  buttons:Dock(RIGHT)
  buttons.OnChildAdded = function(self, panel)
    self:SetWide(BUTTON_MARGIN + self:ChildCount() * (BUTTON_SIZE + BUTTON_MARGIN))
  end
  buttons.PerformLayout = function(self, w, h)
    for i, child in pairs(self:GetChildren()) do
      child:SetPos(BUTTON_MARGIN + (i - 1) * (BUTTON_SIZE + BUTTON_MARGIN), (self:GetTall() * .5) - BUTTON_SIZE * .5)
    end
  end
  self.Buttons = buttons
end

--[[------------------------------------------------------------------
  Adds a button to the right and returns it.
  @param {string} icon
  @param {string|nil} tooltip
  @return {DImageButton} created button
]]--------------------------------------------------------------------
function PANEL:AddButton(icon, tooltip)
  local button = vgui.Create('DImageButton', self.Buttons)
  button:SetSize(BUTTON_SIZE, BUTTON_SIZE)
  button:SetImage(icon)
  button:SetTooltip(tooltip or false)
  return button
end

vgui.Register('HL2HUD_ButtonedLine', PANEL, 'Panel')
