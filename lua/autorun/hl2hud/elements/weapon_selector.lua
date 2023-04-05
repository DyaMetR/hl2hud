
if SERVER then return end

local ELEMENT = HL2HUD.elements.Register('HudWeaponSelection', 'CHudWeaponSelection')

ELEMENT:SetDrawOnTop(true)

ELEMENT:Boolean('visible')
ELEMENT:Boolean('compact')
ELEMENT:Boolean('uppercase')
ELEMENT:Number('ypos')
ELEMENT:Number('SmallBoxSize')
ELEMENT:Number('LargeBoxWide')
ELEMENT:Number('LargeBoxTall')
ELEMENT:Number('BoxGap')
ELEMENT:Number('SelectionNumberXPos')
ELEMENT:Number('SelectionNumberYPos')
ELEMENT:Font('SelectionNumberFont')
ELEMENT:Number('TextYPos')
ELEMENT:Font('TextFont')
ELEMENT:Alignment('TextAlign')
ELEMENT:Boolean('SkipEmpty')
ELEMENT:Colour('EmptyWeaponColor')
ELEMENT:String('MoveSnd')
ELEMENT:String('SelectSnd')

function ELEMENT:Init()
  self:Variable('FgColor', table.Copy(self.colours.FgColor)) -- weapon icon colour
  self:Variable('SelectedFgColor', table.Copy(self.colours.BrightFg))
  self:Variable('TextColor', table.Copy(self.colours.SelectionTextFg)) -- weapon name colour
  self:Variable('NumberColor', table.Copy(self.colours.SelectionNumberFg)) -- slot number colour
  self:Variable('EmptyBoxColor', table.Copy(self.colours.SelectionEmptyBoxBg)) -- empty slot background
  self:Variable('BoxColor', table.Copy(self.colours.SelectionBoxBg)) -- slot background
  self:Variable('SelectedBoxColor', table.Copy(self.colours.SelectionSelectedBoxBg)) -- selected slot background
  self:Variable('Offset', 0)
  self:Variable('Alpha', 0)
  self:Variable('SelectionAlpha', 0)
end

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

function ELEMENT:OnThink()
  HL2HUD.switcher.CacheWeapons()
end

function ELEMENT:Draw(settings, scale)
  local smallBox, boxGap = settings.SmallBoxSize * scale, settings.BoxGap * scale
  local numX, numY = settings.SelectionNumberXPos * scale, settings.SelectionNumberYPos * scale
  local boxW, boxH = settings.LargeBoxWide * scale, settings.LargeBoxTall * scale
  local x, y = ScrW() * .5 - (smallBox * 5 + boxGap * 5 + boxW) * .5, settings.ypos * scale
  local curSlot, curPos, cache, cacheLength = HL2HUD.switcher.Import()

  for slot = 1, 6 do
    -- draw selected slot
    if curSlot == slot then
      local offset = y
      for pos = 1, cacheLength[slot] do
        local alpha = self.variables.Alpha
        local weapon = cache[slot][pos]
        if not IsValid(weapon) then continue end
        local tall, background, textpos = boxH, self.variables.BoxColor, settings.TextYPos * scale

        -- make unselected weapon slot smaller in compact mode
        if settings.compact and curPos ~= pos then
          tall = 20 * scale
          textpos = 16 * scale
        end

        -- change alpha values and background colour if selected
        if curPos == pos then
          background = self.variables.SelectedBoxColor
          alpha = self.variables.SelectionAlpha
        end

        surface.SetAlphaMultiplier(alpha / 255)
        draw.RoundedBox(8, x, offset, boxW, tall, background)

        -- draw weapon icon if not in compact mode or when it's selected
        if not settings.compact or curPos == pos then
          local database = HL2HUD.settings.Get().HudTextures
          local icon = database.Weapons[weapon:GetClass()]
          if icon then
            render.SetScissorRect(x, y, x + boxW, offset + boxH, true)
            local colour = self.variables.FgColor
            if curPos == pos then
              colour = self.variables.SelectedFgColor
            else
              if not weapon:HasAmmo() then colour = self.colours[settings.EmptyWeaponColor] end
            end
            HL2HUD.utils.DrawIcon(icon, x + boxW * .5, offset + boxH * .5, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            -- draw icon highlight if selected
            if curPos == pos then
              local selected = database.Selected[weapon:GetClass()]
              if selected then HL2HUD.utils.DrawIcon(selected, x + boxW * .5, offset + boxH * .5, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
            end
            render.SetScissorRect(0, 0, 0, 0, false)
          else
            if weapon.DrawWeaponSelection then
              local bounce, info = weapon.BounceWeaponIcon, weapon.DrawWeaponInfoBox
              if curPos ~= pos then
                render.SetScissorRect(x, y, x + boxW, offset + boxH, true) -- only cut the unselected weapons
                weapon.BounceWeaponIcon = false
                weapon.DrawWeaponInfoBox = false
              end
              local icoY = offset
              if AUTOICONS then icoY = offset - 16 * scale end
              weapon:DrawWeaponSelection(x, icoY, boxW, boxH, alpha)
              weapon.BounceWeaponIcon = bounce
              weapon.DrawWeaponInfoBox = info
              if curPos ~= pos then render.SetScissorRect(0, 0, 0, 0, false) end
            end
          end
        end

        -- draw slot number
        if pos == 1 then draw.SimpleText(slot, self.fonts.SelectionNumberFont, x + numX, y + numY, self.variables.NumberColor) end
        surface.SetAlphaMultiplier(1)

        -- draw weapon name if selected or when in compact mode
        if settings.compact or curPos == pos then
          surface.SetAlphaMultiplier(self.variables.SelectionAlpha / 255)
          local printname = language.GetPhrase(weapon:GetPrintName()) -- get weapon print name
          if settings.uppercase then printname = string.upper(printname) end -- make it uppercase if it's enabled
          if settings.compact then -- in compact mode move change the vertical alignment
            surface.SetFont(self.fonts.TextFont)
            local _, h = surface.GetTextSize(printname)
            textpos = textpos - h
          end
          render.SetScissorRect(x, y, x + boxW, offset + boxH, true)
          draw.DrawText(printname, self.fonts.TextFont, x + boxW * .5, offset + textpos, self.variables.TextColor, TEXT_ALIGN_CENTER)
          render.SetScissorRect(0, 0, 0, 0, false)
          surface.SetAlphaMultiplier(1)
        end

        -- move next slot
        offset = offset + tall + boxGap
      end
      x = x + boxW + boxGap
      continue
    end

    -- draw slot
    render.SetScissorRect(x, y, x + smallBox, y + smallBox, true)
    surface.SetAlphaMultiplier(self.variables.Alpha / 255)
    if cacheLength[slot] > 0 then
      draw.RoundedBox(8, x, y, smallBox, smallBox, self.colours.SelectionBoxBg)
      draw.SimpleText(slot, self.fonts.SelectionNumberFont, x + numX, y + numY, self.variables.NumberColor)
    else
      draw.RoundedBox(8, x, y, smallBox, smallBox, self.variables.EmptyBoxColor)
    end
    surface.SetAlphaMultiplier(1)
    render.SetScissorRect(0, 0, 0, 0, false)
    x = x + smallBox + boxGap
  end
end