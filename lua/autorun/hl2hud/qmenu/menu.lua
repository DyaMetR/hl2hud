
if SERVER then return end

local URL_STEAMWORKSHOP = 'https://steamcommunity.com/workshop/filedetails/discussion/2954934766/6142387507319055361'
local URL_GITHUB = 'https://github.com/DyaMetR/hl2hud/issues/new'
--local URL_DOCUMENTATION = 'https://github.com/DyaMetR/hl2hud/blob/main/docs/index.md'

local MIN_W, MIN_H = 640, 480
local W, H = .6, .7

local FALLBACK_COLOUR = 'FgColor'
local CONTROL_FALLBACK = 'HL2HUD_Parameter'
local CONTROL = {
	[HL2HUD.elements.PARAM_NUMBER]	= 'HL2HUD_NumberParameter',
	[HL2HUD.elements.PARAM_STRING]	= 'HL2HUD_StringParameter',
	[HL2HUD.elements.PARAM_COLOUR]	= 'HL2HUD_ColourParameter',
	[HL2HUD.elements.PARAM_FONT]	= 'HL2HUD_FontParameter',
	[HL2HUD.elements.PARAM_OPTION]	= 'HL2HUD_OptionParameter',
	[HL2HUD.elements.PARAM_BOOLEAN]	= 'HL2HUD_BooleanParameter'
}

local PREVIEW_BACKGROUND = 'hl2hud/background%i.png'
local ILLEGAL_CHARACTERS = {'\'', '/', ':', '*', '?', '"', '<', '>', '|'}

--[[------------------------------------------------------------------
  Creates the customization menu.
]]--------------------------------------------------------------------
concommand.Add('hl2hud_menu', function()

  local default = HL2HUD.scheme.DefaultSettings()
  local cache = table.Copy(HL2HUD.settings.Client()) -- cache client scheme
	if table.IsEmpty(cache) then cache = HL2HUD.scheme.CreateDataTable() end -- if empty, create a blank data table
  local settings = table.Copy(default) -- create merged settings table between default and diff
  HL2HUD.utils.MergeSchemeLayers(settings, cache)

  -- [[ Window ]] --
  local frame = vgui.Create('HL2HUD_Frame')
  frame:SetTitle('#hl2hud.menu')
  frame:SetSize(math.max(ScrW() * W, MIN_W), math.max(ScrH() * H, MIN_H))
  frame:Center()
  frame:MakePopup()
  frame.ApplyScheme = function()
		-- check if the cache table is empty
		local valid = false
		for category, contents in pairs(cache) do
			if not istable(contents) then continue end
			if not table.IsEmpty(HL2HUD.scheme.GetDataReference()[category]) then
				for _, subcontents in pairs(contents) do
					if not table.IsEmpty(subcontents) then
						valid = true
						break
					end
				end
			else
				if not table.IsEmpty(contents) then
					valid = true
					break
				end
			end
		end

		-- apply scheme according to cache status
		if not valid then
    	HL2HUD.settings.Apply({})
		else
			HL2HUD.settings.Apply(cache)
		end
    HL2HUD.settings.Save()
  end
  frame.ReloadScheme = function(self)
    self.ClientScheme:ReloadScheme(settings)
    self.Preview:SetScheme(settings)
    self.LayoutPage:Reload()
    self.Sequences:Populate()
    self.Icons:Populate()
    self.PropertySheet:SetActiveTab(self.ClientScheme.Tab)
  end

    -- [[ Menu bar ]] --
    local file = frame:AddMenu('#hl2hud.menu.menubar.file')

      -- New
      file:AddOption('#hl2hud.menu.menubar.file.new', function()
        cache = HL2HUD.scheme.CreateDataTable() -- load client data
        settings = table.Copy(default) -- reload merged settings
        frame:ReloadScheme()
      end):SetIcon('icon16/page_add.png')

      -- Load
      local load, parent = file:AddSubMenu('#hl2hud.menu.menubar.file.open')
      parent:SetIcon('icon16/folder_page.png')
      load:SetDeleteSelf(false)
      frame.LoadSchemes = function()
        load:Clear()
        for name, data in SortedPairs(HL2HUD.scheme.All()) do
          load:AddOption(name, function()
            cache = table.Copy(data) -- load client data
            settings = table.Copy(default) -- reload merged settings
            HL2HUD.utils.MergeSchemeLayers(settings, cache)
            frame:ReloadScheme()
          end)
        end
      end
      frame:LoadSchemes()

      -- Save as...
      file:AddOption('#hl2hud.menu.menubar.file.save_as', function()
        Derma_StringRequest('#hl2hud.menu.menubar.file.save_as', '#hl2hud.menu.save_as.filename', '', function(value)
          local illegal = string.len(string.Trim(value)) <= 0
          for _, char in pairs(ILLEGAL_CHARACTERS) do
            if string.find(value, char) then
              illegal = true
              break
            end
          end
          if illegal then
            Derma_Message('#hl2hud.menu.save_as.format_error', '#hl2hud.menu.menubar.file.save_as', '#hl2hud.menu.save_as.ok')
          else
            local scheme = HL2HUD.scheme.Get(value)
            if scheme and scheme.engine then Derma_Message('#hl2hud.menu.save_as.duplicate_error', '#hl2hud.menu.menubar.file.save_as') return end
            if scheme or HL2HUD.settings.SchemeFileExists(HL2HUD.settings.GenerateFileName(value)) then
              Derma_Query('#hl2hud.menu.save_as.duplicate', '#hl2hud.menu.menubar.file.save_as', '#hl2hud.menu.save_as.yes', function()
                HL2HUD.settings.SaveAs(value, cache)
                frame:LoadSchemes()
              end, '#hl2hud.menu.save_as.no')
            else
              HL2HUD.settings.SaveAs(value, cache)
              if HL2HUD.toolmenu.list then HL2HUD.toolmenu.list:AddLine(value) end
              frame:LoadSchemes()
            end
          end
        end)
      end):SetIcon('icon16/disk.png')

      -- Exit
      file:AddOption('#hl2hud.menu.menubar.file.exit', function() frame:Close() end):SetIcon('icon16/cancel.png')

    local edit = frame:AddMenu('#hl2hud.menu.menubar.edit')

      -- Apply changes
      edit:AddOption('#hl2hud.menu.menubar.edit.apply', function() HL2HUD.settings.Apply(cache) end):SetIcon('icon16/accept.png')

			-- Submit
			if not game.SinglePlayer() and LocalPlayer():IsAdmin() then
				local submit, parent = edit:AddSubMenu('#hl2hud.menu.menubar.edit.submit')
				parent:SetIcon('icon16/shield.png')
				submit:SetDeleteSelf(false)

					-- .. as the server's default scheme
					submit:AddOption('#hl2hud.menu.menubar.edit.submit.default', function() HL2HUD.server.SubmitDefault(cache) end)

					-- .. as a server-wide scheme override
					submit:AddOption('#hl2hud.menu.menubar.edit.submit.override', function() HL2HUD.server.SubmitOverride(cache) end)
			end

    local help = frame:AddMenu('#hl2hud.menu.menubar.help')

      -- Report bug
      local bug, parent = help:AddSubMenu('#hl2hud.menu.menubar.help.bug_report')
      parent:SetIcon('icon16/bug.png')
      bug:SetDeleteSelf(false)

        -- ... on the Steam Workshop
        bug:AddOption('#hl2hud.menu.menubar.help.bug_report.steam', function() gui.OpenURL(URL_STEAMWORKSHOP) end):SetIcon('hl2hud/steam16.png')

        -- ... on the GitHub repository
        bug:AddOption('#hl2hud.menu.menubar.help.bug_report.github', function() gui.OpenURL(URL_GITHUB) end):SetIcon('hl2hud/github16.png')

      -- About
      help:AddSpacer()
      help:AddOption('#hl2hud.menu.menubar.help.about', function()
        local about = vgui.Create('HL2HUD_About')
        about:SetTitle('#hl2hud.menu.menubar.help.about')
        about:Center()
      end):SetIcon('icon16/information.png')

    -- [[ ClientScheme ]] --
    local scheme = frame:AddSheet('#hl2hud.menu.clientscheme', vgui.Create('Panel'), 'icon16/palette.png')

      local preview = vgui.Create('HL2HUD_Preview', scheme.Panel)
      preview:SetImage(string.format(PREVIEW_BACKGROUND, math.random(0, 1)))
      preview:Dock(TOP)
      preview:SetScheme(settings)
      frame.Preview = preview

      local editor = vgui.Create('DColumnSheet', scheme.Panel)
      editor:Dock(FILL)
      editor:DockMargin(0, 5, 0, 0)
      editor:GetChild(0):DockMargin(2, 1, 6, 0)

        -- colour list
        local colours = editor:AddSheet('#hl2hud.menu.clientscheme.colors', vgui.Create('HL2HUD_ResourceList'), 'icon16/color_wheel.png')
        colours.Panel:Dock(FILL)
        colours.Panel.CleanNullColours = function(self)
          for element, parameters in pairs(cache.HudLayout) do
            for parameter, value in pairs(parameters) do
              if HL2HUD.elements.Get(element).parameters[parameter].type ~= HL2HUD.elements.PARAM_COLOUR then continue end
              if cache.ClientScheme.Colors[value] then continue end
              cache.HudLayout[element][parameter] = nil
              settings.HudLayout[element][parameter] = default.HudLayout[element][parameter]
            end
          end
          for sequence, animations in pairs(cache.HudAnimations) do
            for _, cmd in pairs(animations) do
              if not isstring(cmd.target) or cache.ClientScheme.Colors[cmd.target] then continue end
              cmd.target = FALLBACK_COLOUR
            end
          end
        end
        colours.Panel.DoReset = function(self)
          table.Empty(cache.ClientScheme.Colors)
          settings.ClientScheme.Colors = table.Copy(default.ClientScheme.Colors)
          self:CleanNullColours()
          frame:ReloadScheme()
        end

          local bottom = colours.Panel:AddBottom('HL2HUD_ButtonedLine')
          bottom:DockMargin(2, 2, 2, 2)

            local picker = vgui.Create('DColorMixerButton', bottom)
            picker:SetSize(96, 20)
            picker:Dock(LEFT)

            local name = vgui.Create('DTextEntry', bottom)
            name:SetPlaceholderText('#hl2hud.menu.clientscheme.colors.name')
            name:Dock(FILL)
            name:DockMargin(2, 0, 2, 0)
            name:SetUpdateOnType(true)

          local add = bottom:AddButton('icon16/add.png', '#hl2hud.menu.clientscheme.colors.add')
          add:SetEnabled(false)
          add.DoClick = function()
            local colName, col = name:GetValue(), picker:GetValue()
            cache.ClientScheme.Colors[colName] = col
            settings.ClientScheme.Colors[colName] = col
            frame:ReloadScheme()
          end
          name.OnValueChange = function(self, value) add:SetEnabled(string.len(value) > 0) end

        -- font list
        local fonts = editor:AddSheet('#hl2hud.menu.clientscheme.fonts', vgui.Create('HL2HUD_ResourceList'), 'icon16/style.png')
        fonts.Panel:Dock(FILL)
        fonts.Panel.CleanNullFonts = function(self)
          for element, parameters in pairs(cache.HudLayout) do
            for parameter, value in pairs(parameters) do
              if HL2HUD.elements.Get(element).parameters[parameter].type ~= HL2HUD.elements.PARAM_FONT then continue end
              if cache.ClientScheme.Fonts[value] then continue end
              cache.HudLayout[element][parameter] = nil
              settings.HudLayout[element][parameter] = default.HudLayout[element][parameter]
            end
          end
        end
        fonts.Panel.DoReset = function(self)
          table.Empty(cache.ClientScheme.Fonts)
          settings.ClientScheme.Fonts = table.Copy(default.ClientScheme.Fonts)
          self:CleanNullFonts()
          frame:ReloadScheme()
        end

          local bottom = fonts.Panel:AddBottom('HL2HUD_ButtonedLine')
          bottom:DockPadding(2, 2, 2, 2)

            local name = vgui.Create('DTextEntry', bottom)
            name:SetPlaceholderText('#hl2hud.menu.clientscheme.fonts.name')
            name:Dock(LEFT)
            name:DockMargin(0, 0, 2, 0)
            name:SetUpdateOnType(true)

            local editor = vgui.Create('HL2HUD_FontEditor', bottom)
            editor:Dock(FILL)
            editor:DockMargin(0, 0, 2, 0)

            local add = bottom:AddButton('icon16/add.png', '#hl2hud.menu.clientscheme.fonts.add')
            add:SetEnabled(false)
            add.DoClick = function()
              local fontName, data = name:GetValue(), editor:GenerateFontData()
              cache.ClientScheme.Fonts[fontName] = data
              settings.ClientScheme.Fonts[fontName] = data
              frame:ReloadScheme()
            end
            name.OnValueChange = function(self, value) add:SetEnabled(string.len(value) > 0) end

          bottom.PerformLayout = function(self, w, h)
            name:SetWide((w - editor.Controls:GetWide()) * .4)
          end

    scheme.Panel.PerformLayout = function(self, w, h) preview:SetTall(h * .5) end
    scheme.ReloadScheme = function(_, scheme)

      -- populate colours
      colours.Panel:Clear()
      for colour, value in SortedPairs(scheme.ClientScheme.Colors) do
        local line, panel = colours.Panel:AddLine('HL2HUD_ColorResource')
        panel:SetText(colour)
        panel:SetValue(value)
        panel.OnValueChanged = function(_, value)
          cache.ClientScheme.Colors[colour] = value
          settings.ClientScheme.Colors[colour] = value
        end

        local button
        if default.ClientScheme.Colors[colour] then
          button = panel:AddButton('icon16/arrow_refresh.png', '#hl2hud.menu.clientscheme.colors.reset')
        else
          button = panel:AddButton('icon16/delete.png', '#hl2hud.menu.clientscheme.colors.remove')
        end
        button.DoClick = function()
          cache.ClientScheme.Colors[colour] = nil
          settings.ClientScheme.Colors[colour] = table.Copy(default.ClientScheme.Colors[colour])
          colours.Panel:CleanNullColours()
          frame:ReloadScheme()
        end
      end

      -- populate fonts
      fonts.Panel:Clear()
      for name, font in SortedPairs(scheme.ClientScheme.Fonts) do
        local line, panel = fonts.Panel:AddLine('HL2HUD_FontResource')
        panel:DockPadding(2, 2, 0, 2)
        panel:SetText(name)
        panel:SetFont(font.font, font.size, font.weight, font.additive, font.blur, font.scanlines, font.symbol, font.scaling ~= nil and font.scaling or font.scalable, font.antialias)
        panel.OnValueChanged = function(_, value)
          cache.ClientScheme.Fonts[name] = value
          settings.ClientScheme.Fonts[name] = value
          preview:ReloadFonts()
        end

        local button
        if default.ClientScheme.Fonts[name] then
          button = panel:AddButton('icon16/arrow_refresh.png', '#hl2hud.menu.clientscheme.fonts.reset')
        else
          button = panel:AddButton('icon16/delete.png', '#hl2hud.menu.clientscheme.fonts.remove')
        end
        button.DoClick = function()
          cache.ClientScheme.Fonts[name] = nil
          settings.ClientScheme.Fonts[name] = table.Copy(default.ClientScheme.Fonts[name])
          fonts.Panel:CleanNullFonts()
          frame:ReloadScheme()
        end
      end
    end
    frame.ClientScheme = scheme

    -- [[ HudLayout ]] --
    local layout = frame:AddSheet('#hl2hud.menu.hudlayout', vgui.Create('Panel'), 'icon16/layout.png')

      -- reset layout
      local header = vgui.Create('Panel', layout.Panel)
      header:Dock(TOP)

        local reset = vgui.Create('DButton', header)
        reset:Dock(LEFT)
        reset:SetText('#hl2hud.menu.hudlayout.reset')
        reset:SetIcon('icon16/layout_delete.png')
        reset:SetWide(128)
        reset.DoClick = function()
          table.Empty(cache.HudLayout)
          settings.HudLayout = table.Copy(default.HudLayout)
          layout:Reload()
        end

      -- elements list
      local elements = vgui.Create('DListView', layout.Panel)
      elements:AddColumn('#hl2hud.menu.hudlayout.elements')
      for element, _ in SortedPairsByMemberValue(HL2HUD.elements.All(), 'i') do
        elements:AddLine(element)
      end

      -- parameters list
      local element = vgui.Create('Panel', layout.Panel)
      element.Populate = function(self, element)
        self:Clear()

        -- reset element to default
        local reset = vgui.Create('DButton', self)
        reset:Dock(TOP)
        reset:DockMargin(0, 0, 0, 5)
        reset:SetWide(128)
        reset:SetText('#hl2hud.menu.hudlayout.elements.reset')
        reset:SetImage('icon16/bomb.png')
        reset.DoClick = function()
          if cache.HudLayout[element] then table.Empty(cache.HudLayout[element]) end
          settings.HudLayout[element] = table.Copy(default.HudLayout[element])
          self:Populate(element)
        end

        -- parameters controls
        local parameters = vgui.Create('HL2HUD_PanelList', self)
        parameters:Dock(FILL)
        for name, parameter in SortedPairsByMemberValue(HL2HUD.elements.Get(element).parameters, 'i') do
          local line, control = parameters:AddLine(CONTROL[parameter.type] or CONTROL_FALLBACK, self)
          line:SetTall(34)
          line:DockPadding(0, 0, 5, 0)
          control:Dock(FILL)
          control:SetTitle(name)
          control:SetSource(settings)
          control:SetParameter(element, name)
          control:SetValue(settings.HudLayout[element][name])
          control.OnValueChanged = function(_, value)
            if not cache.HudLayout[element] then cache.HudLayout[element] = {} end
            cache.HudLayout[element][name] = value
            settings.HudLayout[element][name] = value
          end
          control.OnValueReset = function()
            cache.HudLayout[element][name] = nil
            settings.HudLayout[element][name] = default.HudLayout[element][name]
            control:SetValue(default.HudLayout[element][name])
          end
        end
      end

      -- populate parameters list after selecting an element
      elements.OnRowSelected = function(_, _, row) element:Populate(row:GetValue(1)) end

      -- reset layout page
      layout.Reload = function()
        elements:ClearSelection()
        element:Clear()
      end
      frame.LayoutPage = layout

      -- divider
      local divider = vgui.Create('DHorizontalDivider', layout.Panel)
      divider:Dock(FILL)
      divider:SetLeft(elements)
      divider:SetRight(element)
      divider:SetLeftMin(128)
      divider:SetRightMin(512)
      divider:SetLeftWidth(frame:GetWide() * .26)
      divider:DockMargin(0, 5, 0, 0)

    -- [[ HudAnimations ]] --
    local animations = frame:AddSheet('#hl2hud.menu.hudanimations', vgui.Create('Panel'), 'icon16/film.png')

      local sequences = vgui.Create('Panel', animations.Panel)
      sequences.Populate = function(self)
        self.Sequence:Clear()
        self.Sequence:SetVisible(false)
        self.List:Clear()
        for sequence, _ in SortedPairs(settings.HudAnimations) do
          self.List:AddLine(sequence)
        end
      end
      frame.Sequences = sequences

        local header = vgui.Create('HL2HUD_ButtonedLine', sequences)
        header:Dock(TOP)

          local reset = vgui.Create('DButton', header)
          reset:Dock(LEFT)
          reset:SetText('#hl2hud.menu.hudanimations.reset')
          reset:SetImage('icon16/bomb.png')
          reset:SetWide(128)
          reset.DoClick = function()
            table.Empty(cache.HudAnimations)
            settings.HudAnimations = table.Copy(default.HudAnimations)
            sequences:Populate()
          end

          local name = vgui.Create('DTextEntry', header)
          name:SetWide(256)
          name:Dock(RIGHT)
          name:DockMargin(0, 2, 2, 2)
          name:SetPlaceholderText('#hl2hud.menu.hudanimations.sequences.name')
          name:SetUpdateOnType(true)

          local add = header:AddButton('icon16/add.png', '#hl2hud.menu.hudanimations.sequences.add')
          add.DoClick = function(self)
            local seqName = name:GetValue()
            cache.HudAnimations[seqName] = {}
            settings.HudAnimations[seqName] = {}
            sequences:Populate()
            name:SetValue('')
          end
          name.OnValueChange = function(self, value) add:SetEnabled(string.len(value) > 0) end

        local list = vgui.Create('DListView', sequences)
        list:SetMultiSelect(false)
        list:Dock(FILL)
        list:DockMargin(0, 5, 0, 0)
        list:AddColumn('#hl2hud.menu.hudanimations.sequences')
        list.OnRowSelected = function(self, _, line)
          sequences.Sequence:Populate(line:GetValue(1))
        end
        sequences.List = list

      local sequence = vgui.Create('HL2HUD_ResourceList', animations.Panel)
      sequence:SetVisible(false)
      sequence.Populate = function(self, seqname)
        local label = '#hl2hud.menu.hudanimations.sequences.reset'
        if not default.HudAnimations[seqname] then label = '#hl2hud.menu.hudanimations.sequences.remove' end
        self:Clear()
        self:SetButton(label, 'icon16/film_delete.png')
        self:SetVisible(true)

        for i, cmd in pairs(settings.HudAnimations[seqname]) do
          -- create canvas
          local _, panel = self:AddLine('Panel')
          panel:DockPadding(1, 1, 1, 1)

          -- create line
          local class = 'HL2HUD_CommandLine_Generic'
          if cmd.commandType == HL2HUD.animations.CMD_ANIMATE then class = 'HL2HUD_CommandLine_Animation' end
          local line = vgui.Create(class, panel)
          line:Dock(FILL)
          line:DockPadding(5, 0, 0, 0)
          line:AddColumn(cmd.commandType, '#hl2hud.menu.hudanimations.command.type')
          line:Populate(cmd)

          -- create editor
          line:AddButton('icon16/script_edit.png', '#hl2hud.menu.hudanimations.animations.edit_command').DoClick = function()
            local edit = vgui.Create('HL2HUD_CommandLineEdit', panel)
            edit:Dock(FILL)
            edit:SetText(cmd.commandType)

              -- select editor type
              local class = 'HL2HUD_CommandEditor'
              if cmd.commandType == HL2HUD.animations.CMD_ANIMATE then class = 'HL2HUD_AnimationEditor' end
              local params = vgui.Create(class, edit)
              params:Dock(FILL)
              params:DockMargin(0, 2, 2, 2)
              if cmd.commandType == 'StopAnimation' then params:AddParam2() end
              if params.SetColors then params:SetColors(cache.ClientScheme.Colors) end
              if params.Populate then params:Populate(cmd.commandType, cache) end
              params:PopulateFields(cmd)

              -- enable saving depending on the validity of data
              params.OnSelectionChanged = function(self) edit:SetCanApply(self:AreFieldsValid()) end

            -- apply changes
            edit.DoApply = function()
              local generated = params:GenerateCommandData()
              generated.commandType = cmd.commandType -- inject command type
              if not cache.HudAnimations[seqname] then cache.HudAnimations[seqname] = table.Copy(default.HudAnimations[seqname]) end
              cache.HudAnimations[seqname][i] = generated
              settings.HudAnimations[seqname][i] = generated
              sequence:Populate(seqname)
            end

            -- remove animation
            edit.DoRemove = function()
              if not cache.HudAnimations[seqname] then cache.HudAnimations[seqname] = table.Copy(default.HudAnimations[seqname]) end
              table.remove(cache.HudAnimations[seqname], i)
              table.remove(settings.HudAnimations[seqname], i)
              sequence:Populate(seqname)
            end
          end
        end
      end
      sequence.DoReset = function(self)
        local _ , line = list:GetSelectedLine()
        local seqname = line:GetValue(1)
        cache.HudAnimations[seqname] = nil
        settings.HudAnimations[seqname] = table.Copy(default.HudAnimations[seqname])
        for s, seq in pairs(settings.HudAnimations) do -- remove animations referencing this sequence
          for i, cmd in pairs(seq) do
            if cmd.commandType ~= 'RunEvent' and cmd.commandType ~= 'StopEvent' then continue end
            if cmd.param ~= seqname then continue end
            table.remove(cache.HudAnimations[s], i)
            table.remove(settings.HudAnimations[s], i)
          end
        end
        sequences:Populate()
      end

        local bottom = sequence:AddBottom('HL2HUD_ButtonedLine')

          local command = vgui.Create('DComboBox', bottom)
          command:SetTooltip('#hl2hud.menu.hudanimations.command.type')
          command:Dock(LEFT)
          command:DockMargin(2, 2, 0, 2)

          -- populate with registered command types
          for name, _ in pairs(HL2HUD.animations.GetCommandTypes()) do
            command:AddChoice(name)
          end

          -- add button
          local add = bottom:AddButton('icon16/add.png', '#hl2hud.menu.hudanimations.animations.add_command')
          add.DoClick = function()
            local _, line = list:GetSelectedLine()
            local seqname = line:GetValue(1)
            local generated = bottom:GetChild(2):GenerateCommandData()
            generated.commandType = command:GetValue()
            if not cache.HudAnimations[seqname] then cache.HudAnimations[seqname] = table.Copy(default.HudAnimations[seqname]) end
            table.insert(cache.HudAnimations[seqname], generated)
            table.insert(settings.HudAnimations[seqname], generated)
            sequence:Populate(seqname)
          end

          -- update add button status after changing values
          command.OnSelect = function(self, _, option)
            add:SetEnabled(false)
            if bottom:ChildCount() >= 3 then bottom:GetChild(2):Remove() end
            local class = 'HL2HUD_CommandEditor'
            if option == HL2HUD.animations.CMD_ANIMATE then class = 'HL2HUD_AnimationEditor' end
            local editor = vgui.Create(class, bottom)
            editor:Dock(FILL)
            editor:DockMargin(2, 2, 2, 2)
            if option == 'StopAnimation' then editor:AddParam2() end
            if editor.SetColors then editor:SetColors(cache.ClientScheme.Colors) end
            if editor.Populate then editor:Populate(option, cache) end
            editor.OnSelectionChanged = function() add:SetEnabled(editor:AreFieldsValid()) end
          end

        bottom.PerformLayout = function(self, w, h)
          command:SetWide(w / 6)
        end

      sequences.Sequence = sequence

      local divider = vgui.Create('DVerticalDivider', animations.Panel)
      divider:Dock(FILL)
      divider:SetTop(sequences)
      divider:SetBottom(sequence)
      divider:SetTopMin(128)
      divider:SetBottomMin(256)
      divider:SetTopHeight(frame:GetTall() * .33)

  -- [[ HudTextures ]] --
  local icons = frame:AddSheet('#hl2hud.menu.hudtextures', vgui.Create('DColumnSheet'), 'icon16/pictures.png')
  icons.Panel:GetChild(0):DockMargin(2, 1, 6, 0)
  icons.Panel:GetChild(0):SetWide(146)

    local weapons = vgui.Create('HL2HUD_TextureList')
    weapons.Editor:SetClassPlaceholder('#hl2hud.menu.hudtextures.weapons.weapon_class')
    weapons.OnAdded = function(_, class, data)
      cache.HudTextures.Weapons[class] = data
      settings.HudTextures.Weapons[class] = data
      weapons:Populate(settings.HudTextures.Weapons)
    end
    weapons.OnRemoved = function(_, class)
      local value
      if default.HudTextures.Weapons[class] then value = -1 end
      cache.HudTextures.Weapons[class] = value
      settings.HudTextures.Weapons[class] = nil
      weapons:Populate(settings.HudTextures.Weapons)
    end
    weapons.DoReset = function()
      table.Empty(cache.HudTextures.Weapons)
      settings.HudTextures.Weapons = table.Copy(default.HudTextures.Weapons)
      weapons:Populate(settings.HudTextures.Weapons)
    end
    weapons.OnValueChanged = function(_, class, data)
      cache.HudTextures.Weapons[class] = data
      settings.HudTextures.Weapons[class] = data
    end
    icons.Panel:AddSheet('#hl2hud.menu.hudtextures.weapons', weapons, 'icon16/gun.png')

    local selected = vgui.Create('HL2HUD_TextureList')
    selected.Editor:SetClassPlaceholder('#hl2hud.menu.hudtextures.weapons.weapon_class')
    selected.OnAdded = function(_, class, data)
      cache.HudTextures.Selected[class] = data
      settings.HudTextures.Selected[class] = data
      selected:Populate(settings.HudTextures.Selected)
    end
    selected.OnRemoved = function(_, class)
      local value
      if default.HudTextures.Selected[class] then value = -1 end
      cache.HudTextures.Selected[class] = value
      settings.HudTextures.Selected[class] = nil
      selected:Populate(settings.HudTextures.Selected)
    end
    selected.DoReset = function()
      table.Empty(cache.HudTextures.Selected)
      settings.HudTextures.Selected = table.Copy(default.HudTextures.Selected)
      selected:Populate(settings.HudTextures.Selected)
    end
    selected.OnValueChanged = function(_, class, data)
      cache.HudTextures.Selected[class] = data
      settings.HudTextures.Selected[class] = data
    end
    icons.Panel:AddSheet('#hl2hud.menu.hudtextures.selected_weapons', selected, 'icon16/arrow_in.png')

    local ammo = vgui.Create('HL2HUD_TextureList')
    ammo.Editor:SetClassPlaceholder('#hl2hud.menu.hudtextures.ammo.ammo_type')
    ammo.OnAdded = function(_, class, data)
      cache.HudTextures.AmmoInv[class] = data
      settings.HudTextures.AmmoInv[class] = data
      ammo:Populate(settings.HudTextures.AmmoInv)
    end
    ammo.OnRemoved = function(_, class)
      local value
      if default.HudTextures.AmmoInv[class] then value = -1 end
      cache.HudTextures.AmmoInv[class] = value
      settings.HudTextures.AmmoInv[class] = nil
      ammo:Populate(settings.HudTextures.AmmoInv)
    end
    ammo.DoReset = function()
      table.Empty(cache.HudTextures.AmmoInv)
      settings.HudTextures.AmmoInv = table.Copy(default.HudTextures.AmmoInv)
      ammo:Populate(settings.HudTextures.AmmoInv)
    end
    ammo.OnValueChanged = function(_, class, data)
      cache.HudTextures.AmmoInv[class] = data
      settings.HudTextures.AmmoInv[class] = data
    end
    icons.Panel:AddSheet('#hl2hud.menu.hudtextures.ammo', ammo, 'icon16/bomb.png')

    local pickup = vgui.Create('HL2HUD_TextureList')
    pickup.Editor:SetClassPlaceholder('#hl2hud.menu.hudtextures.ammo.ammo_type')
    pickup.OnAdded = function(_, class, data)
      cache.HudTextures.Ammo[class] = data
      settings.HudTextures.Ammo[class] = data
      pickup:Populate(settings.HudTextures.Ammo)
    end
    pickup.OnRemoved = function(_, class)
      local value
      if default.HudTextures.Ammo[class] then value = -1 end
      cache.HudTextures.Ammo[class] = value
      settings.HudTextures.Ammo[class] = nil
      pickup:Populate(settings.HudTextures.Ammo)
    end
    pickup.DoReset = function()
      table.Empty(cache.HudTextures.Ammo)
      settings.HudTextures.Ammo = table.Copy(default.HudTextures.Ammo)
      pickup:Populate(settings.HudTextures.Ammo)
    end
    pickup.OnValueChanged = function(_, class, data)
      cache.HudTextures.Ammo[class] = data
      settings.HudTextures.Ammo[class] = data
    end
    icons.Panel:AddSheet('#hl2hud.menu.hudtextures.ammo_pickup', pickup, 'icon16/coins_add.png')

    local ammowep = vgui.Create('HL2HUD_TextureList')
    ammowep.Editor:SetClassPlaceholder('#hl2hud.menu.hudtextures.ammo.ammo_type')
    ammowep.OnAdded = function(_, class, data)
      cache.HudTextures.AmmoWep[class] = data
      settings.HudTextures.AmmoWep[class] = data
      ammowep:Populate(settings.HudTextures.AmmoWep)
    end
    ammowep.OnRemoved = function(_, class)
      local value
      if default.HudTextures.AmmoWep[class] then value = -1 end
      cache.HudTextures.AmmoWep[class] = value
      settings.HudTextures.AmmoWep[class] = nil
      ammowep:Populate(settings.HudTextures.AmmoWep)
    end
    ammowep.DoReset = function()
      table.Empty(cache.HudTextures.AmmoWep)
      settings.HudTextures.Ammo = table.Copy(default.HudTextures.AmmoWep)
      ammowep:Populate(settings.HudTextures.AmmoWep)
    end
    ammowep.OnValueChanged = function(_, class, data)
      cache.HudTextures.AmmoWep[class] = data
      settings.HudTextures.AmmoWep[class] = data
    end
    icons.Panel:AddSheet('#hl2hud.menu.hudtextures.ammo_weapon', ammowep, 'icon16/information.png')

    local ent = vgui.Create('HL2HUD_TextureList')
    ent.Editor:SetClassPlaceholder('#hl2hud.menu.hudtextures.pickup.ent_class')
    ent.OnAdded = function(_, class, data)
      cache.HudTextures.Entities[class] = data
      settings.HudTextures.Entities[class] = data
      selected:Populate(settings.HudTextures.Entities)
    end
    ent.OnRemoved = function(_, class)
      local value
      if default.HudTextures.Entities[class] then value = -1 end
      cache.HudTextures.Entities[class] = value
      settings.HudTextures.Entities[class] = nil
      selected:Populate(settings.HudTextures.Entities)
    end
    ent.DoReset = function()
      table.Empty(cache.HudTextures.Entities)
      settings.HudTextures.Entities = table.Copy(default.HudTextures.Entities)
      selected:Populate(settings.HudTextures.Entities)
    end
    ent.OnValueChanged = function(_, class, data)
      cache.HudTextures.Entities[class] = data
      settings.HudTextures.Entities[class] = data
    end
    icons.Panel:AddSheet('#hl2hud.menu.hudtextures.pickup', ent, 'icon16/package_add.png')
  icons.Populate = function()
    weapons:SetFontSource(settings.ClientScheme.Fonts)
    weapons:Populate(settings.HudTextures.Weapons)
    selected:SetFontSource(settings.ClientScheme.Fonts)
    selected:Populate(settings.HudTextures.Selected)
    ammo:SetFontSource(settings.ClientScheme.Fonts)
    ammo:Populate(settings.HudTextures.AmmoInv)
    pickup:SetFontSource(settings.ClientScheme.Fonts)
    pickup:Populate(settings.HudTextures.Ammo)
    ammowep:SetFontSource(settings.ClientScheme.Fonts)
    ammowep:Populate(settings.HudTextures.AmmoWep)
    ent:SetFontSource(settings.ClientScheme.Fonts)
    ent:Populate(settings.HudTextures.Entities)
  end
  frame.Icons = icons

  -- [[ Initialize menu ]] --
  frame:ReloadScheme()
end)
