--[[------------------------------------------------------------------
	A button previewing a colour which opens a colour mixer.
	
	Featuring reused code from 9XHUD.
	https://github.com/DyaMetR/98hud/blob/master/lua/autorun/98hud/qmenu/derma/DColorMixerButton.lua
]]--------------------------------------------------------------------

if SERVER then return end

local COLOUR_FRAME = Color(96, 96, 96)
local MIXER_MARGIN = 5

local PANEL = {}

--[[------------------------------------------------------------------
  Initialize default values.
]]--------------------------------------------------------------------
function PANEL:Init()
	self.Value = Color(255, 255, 255)
	self.ColorMixerWide = 256 -- colour picker default width
	self.ColorMixerTall = 256 -- colour picker default height
	self:SetText('')
end

--[[------------------------------------------------------------------
  Paint the colour on the whole button.
]]--------------------------------------------------------------------
function PANEL:Paint()
	draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), COLOUR_FRAME)
	draw.RoundedBox(0, 1, 1, self:GetWide() - 2, self:GetTall() - 2, self.Value)
end

--[[------------------------------------------------------------------
  Called when the value changes
  @param {Color} new colour
]]--------------------------------------------------------------------
function PANEL:OnValueChanged(color) end

--[[------------------------------------------------------------------
  Sets the value of the colour its holding and calls OnValueChanged
  @param {Color} colour
]]--------------------------------------------------------------------
function PANEL:SetValue(color)
	self.Value = color
	self:OnValueChanged(color)
end

--[[------------------------------------------------------------------
  Returns the colour its holding
  @return {Color} colour
]]--------------------------------------------------------------------
function PANEL:GetValue()
	return self.Value
end

--[[------------------------------------------------------------------
  Creates the colour picker
]]--------------------------------------------------------------------
function PANEL:CreateColorMixer()
	-- get absolute position
	local frame = self
	local x, y = self.x, self.y
	while frame:GetParent() do
		frame = frame:GetParent()
		x = x + frame.x
		y = y + frame.y
	end

  -- render above if we're too close to the screen's limit
  if y + self.ColorMixerTall + self:GetTall() > ScrH() then
    y = y - self.ColorMixerTall
  else
    y = y + self:GetTall()
  end

	-- create colour mixer
	self.ColorMixer = vgui.Create('DFrame')
	self.ColorMixer:SetPos(x, y) -- absolute screen position
	self.ColorMixer:SetSize(self.ColorMixerWide, self.ColorMixerTall)
	self.ColorMixer:ShowCloseButton(false)
	self.ColorMixer:SetTitle('')
	self.ColorMixer:MakePopup()
	self.ColorMixer.OnSizeChanged = function(_self, w, h) _self.Control:SetSize(w - (MIXER_MARGIN * 2), h - (MIXER_MARGIN * 2)) end
	self.ColorMixer.OnFocusChanged = function(_self, gained)
		if not gained then
			timer.Simple(0.1, function() -- cheating death with this simple trick -- not the cleanest, but I couldn't find a better way for now
				if not self or not IsValid(self) or not self.ColorMixer then return end
				if self.ColorMixer.Control.txtR:HasFocus() or self.ColorMixer.Control.txtG:HasFocus() or self.ColorMixer.Control.txtB:HasFocus() then return end
				self:DestroyColorMixer()
			end)
		end
	end
	self.ColorMixer.Control = vgui.Create('DColorMixer', self.ColorMixer)
	self.ColorMixer.Control:SetPos(MIXER_MARGIN, MIXER_MARGIN)
	self.ColorMixer.Control:SetSize(self.ColorMixer:GetWide() - (MIXER_MARGIN * 2), self.ColorMixer:GetTall() - (MIXER_MARGIN * 2))
	self.ColorMixer.Control:SetColor(self.Value)
	self.ColorMixer.Control.ValueChanged = function(_self, value) self:SetValue(value) end
end

--[[------------------------------------------------------------------
  Gets the colour picker panel (if active)
  @return {DColorMixer|nil} colour picker
]]--------------------------------------------------------------------
function PANEL:GetColorMixer()
 	return self.ColorMixer
end

--[[------------------------------------------------------------------
  Sets the colour picker width
  @param {number} width
]]--------------------------------------------------------------------
function PANEL:SetColorMixerWide(w)
	self.ColorMixerWide = w
	if not self.ColorMixer then return end
	self.ColorMixer:SetWide(w)
end

--[[------------------------------------------------------------------
  Sets the colour picker height
  @param {number} height
]]--------------------------------------------------------------------
function PANEL:SetColorMixerHeight(h)
	self.ColorMixerTall = h
	if not self.ColorMixer then return end
	self.ColorMixer:SetTall(h)
end

--[[------------------------------------------------------------------
  Sets the colour picker size
  @param {number} width
  @param {number} height
]]--------------------------------------------------------------------
function PANEL:SetColorMixerSize(w, h)
	self:SetColorMixerWide(w)
	self:SetColorMixerTall(h)
end

--[[------------------------------------------------------------------
  Removes the colour mixer (if present)
]]--------------------------------------------------------------------
function PANEL:DestroyColorMixer()
	if not self.ColorMixer then return end
	self.ColorMixer:Remove()
	self.ColorMixer = nil
end

--[[------------------------------------------------------------------
  Removes the colour mixer upon deletion
]]--------------------------------------------------------------------
function PANEL:OnRemove()
	self:DestroyColorMixer()
end

--[[------------------------------------------------------------------
  Toggles the colour picker upon clicking it
]]--------------------------------------------------------------------
function PANEL:DoClick()
	if self.ColorMixer then
		self:DestroyColorMixer()
	else
		self:CreateColorMixer()
	end
end

vgui.Register('DColorMixerButton', PANEL, 'DButton')
