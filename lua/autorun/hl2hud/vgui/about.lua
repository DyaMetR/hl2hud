
if SERVER then return end

local PANEL = {}

local URL_STEAM   = 'https://steamcommunity.com/id/dyametr/myworkshopfiles/'
local URL_GITHUB  = 'https://github.com/DyaMetR/hl2hud'

local LOCALE_AUTHOR     = 'by %s'
local LOCALE_VERSION    = 'Version %s'
local LOCALE_THANKS     = 'Thank you very much for downloading and using %s.'
local LOCALE_DISCLAIMER = 'All third-party fonts and designs belong to their original owners.'
local LOCALE_COPYRIGHT  = 'No copyright infringement intended.'
local LOCALE_WORKSHOP   = 'Check out the rest of my Workshop!'
local LOCALE_REPOSITORY = 'GitHub repository'

-- title font
surface.CreateFont('hl2hud_about_title', {
  font = 'HalfLife2',
  size = 36
})

-- subtitle font
surface.CreateFont('hl2hud_about_subtitle', {
  font = 'Verdana',
  size = 18,
  weight = 600
})

--[[------------------------------------------------------------------
  Populate the about page.
]]--------------------------------------------------------------------
function PANEL:Init()
  local header = vgui.Create('DImage', self)
  header:SetTall(154)
  header:Dock(TOP)
  header:DockPadding(0, 24, 0, 0)
  header:SetImage('hl2hud/background0.png')
  header:SetImageColor(Color(144, 144, 144))
  header:SetKeepAspect(true)

    local title = vgui.Create('DLabel', header)
    title:SetFont('hl2hud_about_title')
    title:SetText('HALF-LIFE\'')
    title:SizeToContents()
    title:Dock(TOP)
    title:DockMargin(0, 0, 0, 6)
    title:SetContentAlignment(8)

    local subtitle = vgui.Create('DLabel', header)
    subtitle:SetFont('hl2hud_about_subtitle')
    subtitle:SetText('CUSTOMIZABLE HEADS UP DISPLAY')
    subtitle:Dock(TOP)
    subtitle:DockMargin(0, 0, 0, 8)
    subtitle:SetContentAlignment(8)

    local version = vgui.Create('DLabel', header)
    version:SetText(string.format(LOCALE_VERSION, HL2HUD.version))
    version:SetFont('DermaDefaultBold')
    version:Dock(TOP)
    version:SetContentAlignment(8)

    local author = vgui.Create('DLabel', header)
    author:SetText(string.format(LOCALE_AUTHOR, 'DyaMetR'))
    author:SizeToContents()
    author:Dock(LEFT)
    author:DockMargin(8, 14, 0, 0)

    local date = vgui.Create('DLabel', header)
    date:SetText(HL2HUD.date)
    date:SizeToContents()
    date:Dock(RIGHT)
    date:DockMargin(0, 14, 8, 0)

  local contents = vgui.Create('Panel', self)
  contents:Dock(FILL)
  contents:DockMargin(8, 10, 8, 0)

    local thanks = vgui.Create('DLabel', contents)
    thanks:SetText(string.format(LOCALE_THANKS, HL2HUD.name))
    thanks:SizeToContents()
    thanks:Dock(TOP)
    thanks:DockMargin(0, 0, 0, 12)

    local disclaimer = vgui.Create('DLabel', contents)
    disclaimer:SetText(LOCALE_DISCLAIMER)
    disclaimer:SizeToContents()
    disclaimer:Dock(TOP)
    disclaimer:DockMargin(0, 0, 0, 4)

    local copyright = vgui.Create('DLabel', contents)
    copyright:SetText(LOCALE_COPYRIGHT)
    copyright:SetFont('DermaDefaultBold')
    copyright:SizeToContents()
    copyright:Dock(TOP)

  local footer = vgui.Create('Panel', self)
  footer:SetTall(32)
  footer:Dock(BOTTOM)
  footer:DockMargin(4, 0, 4, 4)

    local steam = vgui.Create('DImageButton', footer)
    steam:SetTooltip(LOCALE_WORKSHOP)
    steam:SetWide(32)
    steam:Dock(RIGHT)
    steam:DockMargin(8, 0, 0, 0)
    steam:SetImage('hl2hud/steam32.png')
    steam.DoClick = function() gui.OpenURL(URL_STEAM) end

    local github = vgui.Create('DImageButton', footer)
    github:SetTooltip(LOCALE_REPOSITORY)
    github:SetWide(32)
    github:Dock(RIGHT)
    github:SetImage('hl2hud/github32.png')
    github.DoClick = function() gui.OpenURL(URL_GITHUB) end

  self:SetSize(480, 290)
  self:SetDraggable(false)
  self:SetBackgroundBlur(true)
  self:MakePopup()
  self:DoModal()
end

vgui.Register('HL2HUD_About', PANEL, 'DFrame')
