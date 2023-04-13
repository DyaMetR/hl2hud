if SERVER then return end

HL2HUD.toolmenu = HL2HUD.toolmenu or {}

local CATEGORY = 'Utilities'
local UID = 'hl2hud'

local LOCALE_ENABLE         = 'Enabled'
local LOCALE_NOSUIT         = 'Draw without suit'
local LOCALE_HIDECHUD       = 'Keep CHud elements hidden'
local LOCALE_MINIMAL_HINTS  = 'Minimal hints'
local LOCALE_LIMITER        = 'Limit scale (up to 1080p)'
local LOCALE_WARNING        = 'Some things may stop working properly past 1080p! Disable at your own risk.'
local LOCALE_SCHEMES        = 'Schemes'
local LOCALE_RESET          = 'Reset scheme to default'
local LOCALE_EDIT           = 'Edit current scheme'
local LOCALE_CREDITS        = 'Credits'

local LOCALE_SCHEME_LOAD		= 'Load scheme'
local LOCALE_SCHEME_DELETE	= 'Delete scheme'
local LOCALE_SCHEME_ENGINE	= 'Default schemes cannot be deleted'

local LOCALE_MODAL_DELETE		= 'Are you sure you want to delete scheme \'%s\'? This cannot be undone!'
local LOCALE_MODAL_ACCEPT		= 'Yes, delete it'
local LOCALE_MODAL_CANCEL		= 'Cancel'

-- populate tool menu
hook.Add('PopulateToolMenu', UID, function()
  -- add option
  spawnmenu.AddToolMenuOption(CATEGORY, HL2HUD.name, UID, 'Settings', nil, nil, function(panel)
    panel:ClearControls()

    -- parameters
    panel:CheckBox(LOCALE_ENABLE, 'hl2hud_enabled')
    panel:CheckBox(LOCALE_NOSUIT, 'hl2hud_nosuit')
    panel:CheckBox(LOCALE_HIDECHUD, 'hl2hud_alwayshide')
    panel:CheckBox(LOCALE_MINIMAL_HINTS, 'hl2hud_minimalhints')
    panel:CheckBox(LOCALE_LIMITER, 'hl2hud_limitscale')
    panel:ControlHelp(LOCALE_WARNING)

    -- list of schemes
    local schemes = vgui.Create('Panel')
    schemes:SetTall(256)

    local list = vgui.Create('DListView', schemes)
    list:Dock(FILL)
    list:SetMultiSelect(false)
    list:AddColumn(LOCALE_SCHEMES)
    list.DoDoubleClick = function(_, _, line)
      HL2HUD.settings.Load(line:GetValue(1))
    end
    list.Populate = function(self)
      for scheme, _ in pairs(HL2HUD.scheme.All()) do
        list:AddLine(scheme)
      end
      list:SortByColumn(1)
    end

    local options = vgui.Create('Panel', schemes)
    options:Dock(BOTTOM)

    local buttons = vgui.Create('Panel', options)
    buttons:Dock(RIGHT)
    buttons:SetSize(40)

    local load = vgui.Create('DImageButton', buttons)
    load:SetImage('icon16/cd_go.png')
    load:SetSize(16, 16)
    load:SetY(4)
    load:SetDisabled(true)
    load.DoClick = function()
      local _, line = list:GetSelectedLine()
      HL2HUD.settings.Load(line:GetValue(1))
    end

    local delete = vgui.Create('DImageButton', buttons)
    delete:SetImage('icon16/delete.png')
    delete:SetSize(16, 16)
    delete:SetPos(20, 4)
    delete:SetEnabled(false)
		delete.DoClick = function()
			local i, line = list:GetSelectedLine()
			Derma_Query(string.format(LOCALE_MODAL_DELETE, line:GetValue(1)), LOCALE_SCHEME_DELETE, LOCALE_MODAL_ACCEPT, function()
        local name = line:GetValue(1)
        HL2HUD.settings.Delete(HL2HUD.scheme.Get(name).FileName)
				HL2HUD.scheme.Remove(name)
				list:RemoveLine(i)
        load:SetEnabled(false)
        delete:SetEnabled(false)
			end, LOCALE_MODAL_CANCEL)
		end

    list.OnRowSelected = function(self, _, row)
      local tooltip = LOCALE_SCHEME_DELETE
      delete:SetDisabled(HL2HUD.scheme.Get(row:GetValue(1)).engine)
      if delete:GetDisabled() then tooltip = LOCALE_SCHEME_DELETE_UNABLE end
      delete:SetTooltip(tooltip)
      if not load:GetDisabled() then return end
      load:SetEnabled(true)
      load:SetTooltip(LOCALE_SCHEME_LOAD)
    end
    list:Populate()

    panel:AddItem(schemes)
    HL2HUD.toolmenu.list = list

    -- menu button
    panel:Button(LOCALE_EDIT, 'hl2hud_menu')

    -- mandatory reset button
    panel:Button(LOCALE_RESET, 'hl2hud_reset')

    -- credits
    panel:Help('\n' .. LOCALE_CREDITS) -- separator
    for i=1, #HL2HUD.credits do
      local credit = HL2HUD.credits[i]
      panel:Help(credit[1])
      panel:ControlHelp(credit[2])
    end
    panel:Help('\n' .. HL2HUD.date .. '\n')
  end)
end)
