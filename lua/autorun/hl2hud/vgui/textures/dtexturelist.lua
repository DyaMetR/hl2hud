
if SERVER then return end

local PANEL = {}

function PANEL:Init()
  self:Dock(FILL)

  local editor = self:AddBottom('HL2HUD_TextureEditor')
  editor:DockMargin(2, 2, 2, 2)
  self.Editor = editor

    local add = editor:AddButton('icon16/add.png', '#hl2hud.menu.hudtextures.list.add')
    add.DoClick = function() self:OnAdded(editor:GenerateIconData()) end
    add:SetEnabled(false)

  editor.OnValueChanged = function() add:SetEnabled(editor:Validated()) end
end

--[[------------------------------------------------------------------
  Populates the list with the given icons.
  @param {table} icon list
]]--------------------------------------------------------------------
function PANEL:Populate(list)
  self:Clear()
  for class, data in pairs(list) do
    if data == -1 then continue end
    local line, panel = self:AddLine('HL2HUD_TextureEditor')
    panel:SetIconData(class, data)
    panel:AddButton('icon16/delete.png', '#hl2hud.menu.hudtextures.list.remove').DoClick = function() self:OnRemoved(class) end
    panel:SetFontSource(self.Fonts)
    panel:MakeClassReadOnly()
    panel.OnValueChanged = function() self:OnValueChanged(panel:GenerateIconData()) end
  end
end

--[[------------------------------------------------------------------
  Sets the font table used when populating the font selector.
  @param {table} fonts
]]--------------------------------------------------------------------
function PANEL:SetFontSource(fonts)
  self.Fonts = fonts
  if not self.Editor then return end
  self.Editor:SetFontSource(fonts)
end

--[[------------------------------------------------------------------
  Called when an icon is signaled to be removed.
]]--------------------------------------------------------------------
function PANEL:OnRemoved(class) end

--[[------------------------------------------------------------------
  Called when an icon is signaled to be added.
]]--------------------------------------------------------------------
function PANEL:OnAdded(class, data) end

--[[------------------------------------------------------------------
  Called when an icon's parameters are changed.
]]--------------------------------------------------------------------
function PANEL:OnValueChanged(class, data) end

vgui.Register('HL2HUD_TextureList', PANEL, 'HL2HUD_ResourceList')
