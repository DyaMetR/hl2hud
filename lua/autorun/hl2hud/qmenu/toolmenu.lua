if SERVER then return end

HL2HUD.toolmenu = HL2HUD.toolmenu or {}

local CATEGORY = 'Utilities'
local UID = 'hl2hud'

-- create strikeout font
surface.CreateFont('DermaDefaultStrike', {
  font = 'Tahoma',
  size = 13,
  strikeout = true
})

--[[------------------------------------------------------------------
  Helper function to add a panel with a label and a button.
  @param {Panel} parent
  @param {string} label text
  @param {string} button tooltip
  @param {function} button function
  @return {Panel} panel
  @return {DLabel} label
]]--------------------------------------------------------------------
local function AddOverrideLabel(parent, text, tooltip, click)
  local panel = vgui.Create('Panel', parent)
  panel:Dock(TOP)
  panel:SetTall(16)

    local label = vgui.Create('DLabel', panel)
    label:SetText(text)
    label:SetTextColor(label:GetSkin().Colours.Label.Dark)
    label:SizeToContents()

    local button = vgui.Create('DImageButton', panel)
    button:SetWide(16)
    button:SetImage('icon16/delete.png')
    button:Dock(RIGHT)
    button:SetTooltip(tooltip)
    button.DoClick = click

  return panel, label
end

-- populate tool menu
hook.Add('PopulateToolMenu', UID, function()
  -- change how client settings is shown in singleplayer
  local label = '#hl2hud.qmenu.client'
  if game.SinglePlayer() then label = '#spawnmenu.utilities.settings' end

  -- client settings
  spawnmenu.AddToolMenuOption(CATEGORY, HL2HUD.name, UID, label, nil, nil, function(panel)
    panel:ClearControls()

    -- parameters
    panel:CheckBox('#hl2hud.qmenu.client.enabled', 'hl2hud_enabled')
    panel:CheckBox('#hl2hud.qmenu.client.draw_without_suit', 'hl2hud_nosuit')
    panel:CheckBox('#hl2hud.qmenu.client.hide_chud', 'hl2hud_alwayshide')
    panel:CheckBox('#hl2hud.qmenu.client.minimal_hints', 'hl2hud_minimalhints')
    panel:ControlHelp('#hl2hud.qmenu.client.minimal_hints.help')
    panel:CheckBox('#hl2hud.qmenu.client.limit_scale', 'hl2hud_limitscale')
    panel:ControlHelp('#hl2hud.qmenu.client.limit_scale.help')

    -- list of schemes
    local schemes = vgui.Create('Panel')
    schemes:SetTall(256)

    local list = vgui.Create('DListView', schemes)
    list:Dock(FILL)
    list:SetMultiSelect(false)
    list:AddColumn('#hl2hud.qmenu.client.schemes')
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
			Derma_Query(string.format(language.GetPhrase('hl2hud.qmenu.client.schemes.delete_scheme.prompt'), line:GetValue(1)), '#hl2hud.qmenu.client.schemes.delete_scheme', '#hl2hud.qmenu.client.schemes.delete_scheme.accept', function()
        local name = line:GetValue(1)
        HL2HUD.settings.Delete(HL2HUD.scheme.Get(name).FileName)
				HL2HUD.scheme.Remove(name)
				list:RemoveLine(i)
        load:SetEnabled(false)
        delete:SetEnabled(false)
			end, '#hl2hud.qmenu.client.schemes.delete_scheme.cancel')
		end

    list.OnRowSelected = function(self, _, row)
      local tooltip = '#hl2hud.qmenu.client.schemes.delete_scheme'
      delete:SetDisabled(HL2HUD.scheme.Get(row:GetValue(1)).engine)
      if delete:GetDisabled() then tooltip = '#hl2hud.qmenu.client.schemes.unremovable_scheme' end
      delete:SetTooltip(tooltip)
      if not load:GetDisabled() then return end
      load:SetEnabled(true)
      load:SetTooltip('#hl2hud.qmenu.client.schemes.load_scheme')
    end
    list:Populate()

    panel:AddItem(schemes)
    HL2HUD.toolmenu.list = list

    -- menu button
    panel:Button('#hl2hud.qmenu.client.edit_scheme', 'hl2hud_menu')

    -- mandatory reset button
    panel:Button('#hl2hud.qmenu.client.reset_scheme', 'hl2hud_reset')

    -- credits
    panel:Help('\n' .. language.GetPhrase('hl2hud.credits')) -- separator
    for i=1, #HL2HUD.credits do
      local credit = HL2HUD.credits[i]
      panel:Help(credit[1])
      panel:ControlHelp(credit[2])
    end
    panel:Help('\n' .. HL2HUD.date .. '\n')
  end)

  if game.SinglePlayer() then return end

  -- server settings
  spawnmenu.AddToolMenuOption(CATEGORY, HL2HUD.name, 'sv_' .. UID, '#spawnmenu.utilities.server_settings', nil, nil, function(panel)
    panel:ClearControls()
    panel:Help('#utilities.serversettings')

    -- parameters
    panel:CheckBox('#hl2hud.qmenu.server.client_default', 'hl2hud_csdefaultenabled')
    panel:ControlHelp('#hl2hud.qmenu.server.client_default.help')
    panel:CheckBox('#hl2hud.qmenu.server.superadmin_only', 'hl2hud_superadminonly')
    panel:ControlHelp('#hl2hud.qmenu.server.superadmin_only.help')
  end)

  -- admin settings
  spawnmenu.AddToolMenuOption(CATEGORY, HL2HUD.name, 'op_' .. UID, '#hl2hud.qmenu.admin', nil, nil, function(panel)
    panel:ClearControls()
    panel:Help('#hl2hud.qmenu.admin.description')

    -- override status
    panel:Help('#hl2hud.qmenu.admin.overrides')
    local overrides = vgui.Create('Panel', panel)
    overrides:Dock(TOP)
    overrides:DockMargin(24, 4, 16, 4)
    overrides:SetTall(48)
    overrides.Refresh = function(self)
      local skin = self:GetSkin()
      self:Clear()

      if not HL2HUD.server.default and not HL2HUD.server.override then
        local none = vgui.Create('DLabel', self)
        none:Dock(TOP)
        none:SetText('#hl2hud.qmenu.admin.overrides.none')
        none:SizeToContents()
      else
        if HL2HUD.server.default then
          local _, label = AddOverrideLabel(self, '#hl2hud.qmenu.admin.overrides.default', '#hl2hud.qmenu.admin.overrides.default.remove', function() HL2HUD.server.RemoveDefault() end)
          if HL2HUD.server.override then
            label:SetTextColor(skin.Colours.Label.Default)
            label:SetFont('DermaDefaultStrike')
          end
        end
        if HL2HUD.server.override then
          AddOverrideLabel(self, '#hl2hud.qmenu.admin.overrides.override', '#hl2hud.qmenu.admin.overrides.override.remove', function() HL2HUD.server.RemoveOverride() end)
        end
      end
    end
    overrides:Refresh()
    HL2HUD.toolmenu.overrides = overrides

    -- submit
    panel:Help('#hl2hud.qmenu.admin.submit')
    panel:Button('#hl2hud.qmenu.admin.submit.default', 'hl2hud_submitdefault')
    panel:Button('#hl2hud.qmenu.admin.submit.override', 'hl2hud_submitoverride')
    panel:Help('')
    panel:Button('#hl2hud.qmenu.admin.reset', 'hl2hud_svreset')
  end)
end)
