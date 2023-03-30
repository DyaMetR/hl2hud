
local NET = HL2HUD.hookname .. '_squad'

local SQUAD_MEMBER_ADDED = 0
local SQUAD_MEMBER_LEFT = 1
local SQUAD_MEMBER_DIED = 2

if SERVER and game.SinglePlayer() then -- NPC squads work only in single player

  util.AddNetworkString(NET)

  local PLAYER_SQUAD = 'player_squad'

  --[[------------------------------------------------------------------
    When the squad member count changes update the player.
  ]]--------------------------------------------------------------------
  local lastSquad = {}
  hook.Add('Think', NET, function()
    local squad = ai.GetSquadMembers(PLAYER_SQUAD)
    if not squad then return end
    if #squad == #lastSquad then return end

    -- check what happened
    local enum = SQUAD_MEMBER_ADDED
    if #squad < #lastSquad then
      enum = SQUAD_MEMBER_LEFT
      for _, member in pairs(lastSquad) do
        if not IsValid(member) or member:GetSquad() == PLAYER_SQUAD then continue end
        enum = SQUAD_MEMBER_DIED
        break
      end
    end

    -- count medics
    local medics = 0
    for _, member in pairs(squad) do
      if not IsValid(member) or not member:HasSpawnFlags(SF_CITIZEN_MEDIC) then continue end
      medics = medics + 1
    end

    -- send information
    net.Start(NET)
    net.WriteInt(enum, 4)
    net.WriteInt(#squad, 4)
    net.WriteInt(medics, 4)
    net.Broadcast()
    lastSquad = squad
  end)

end

if SERVER then return end

local ELEMENT = HL2HUD.elements.Register('HudSquadStatus', 'CHudSquadStatus')

ELEMENT:Boolean('visible')
ELEMENT:Number('xpos')
ELEMENT:Number('ypos')
ELEMENT:Number('wide')
ELEMENT:Number('tall')
ELEMENT:Alignment('halign')
ELEMENT:Alignment('valign')
ELEMENT:Number('text_xpos')
ELEMENT:Number('text_ypos')
ELEMENT:String('text')
ELEMENT:Font('text_font')
ELEMENT:Colour('SquadIconColor')
ELEMENT:Number('IconInsetX')
ELEMENT:Number('IconInsetY')
ELEMENT:Number('IconGap')
ELEMENT:String('IconMember')
ELEMENT:String('IconMedic')
ELEMENT:Font('IconFont')

local lastMembers, members, medics = 0, 0, 0
function ELEMENT:Init()
  self:Variable('BgColor', table.Copy(self.colours.BgColor))
  self:Variable('Alpha', 0)
  self:Variable('LastMemberColor', table.Copy(self.colours.SquadMemberLeft))
  self:Variable('SquadTextColor', table.Copy(self.colours.SquadMember))
  if lastMembers > 0 then
    HL2HUD.animations.StartAnimationSequence('SquadStatusShow')
    HL2HUD.animations.StartAnimationSequence('SquadMemberAdded')
  end
  members = lastMembers
end

function ELEMENT:Draw(settings, scale)
  local x, y = settings.xpos * scale, settings.ypos * scale
  local w, h = settings.wide * scale, settings.tall * scale
  if settings.halign > 1 then x = ScrW() - (x + w) end
  if settings.valign > 1 then y = ScrH() - (y + h) end
  render.SetScissorRect(x, y, x + w, y + h, true)
  surface.SetAlphaMultiplier(self.variables.Alpha / 255)
  draw.RoundedBox(8, x, y, w, h, self.variables.BgColor)
  draw.SimpleText(settings.text, self.fonts.text_font, x + settings.text_xpos * scale, y + settings.text_ypos * scale, self.variables.SquadTextColor)
  for i=1, members - 1 do
    local icon = settings.IconMember
    if medics >= i then icon = settings.IconMedic end
    draw.SimpleText(icon, self.fonts.IconFont, x + (settings.IconInsetX + settings.IconGap * (i - 1)) * scale, y + settings.IconInsetY * scale, self.colours[settings.SquadIconColor])
  end
  draw.SimpleText(settings.IconMember, self.fonts.IconFont, x + (settings.IconInsetX + settings.IconGap * (members - 1)) * scale, y + settings.IconInsetY * scale, self.variables.LastMemberColor)
  surface.SetAlphaMultiplier(1)
  render.SetScissorRect(0, 0, 0, 0, false)
end

-- [[ Squad members changed ]] --
net.Receive(NET, function()
  local enum = net.ReadInt(4)
  members = net.ReadInt(4)
  medics = net.ReadInt(4)
  if enum == SQUAD_MEMBER_ADDED then
    ELEMENT.variables.LastMemberColor.a = 0 -- reset last member icon
    HL2HUD.animations.StartAnimationSequence('SquadMemberAdded')
    if lastMembers <= 0 then HL2HUD.animations.StartAnimationSequence('SquadStatusShow') end
    lastMembers = members
  else
    if enum == SQUAD_MEMBER_DIED then
      HL2HUD.animations.StartAnimationSequence('SquadMemberDied')
    else
      HL2HUD.animations.StartAnimationSequence('SquadMemberLeft')
    end
    if members <= 0 then HL2HUD.animations.StartAnimationSequence('SquadStatusHide') end
    lastMembers = members
    members = members + 1
  end
end)
