
local NET_DEFAULT = 'hl2hud_default'
local NET_OVERRIDE = 'hl2hud_override'

if SERVER then

  local PATH    = 'DATA'
  local DIR     = 'hl2hud'
  local FILE_DEFAULT = DIR .. '\\default.dat'
  local FILE_OVERRIDE = DIR .. '\\override.dat'

  -- super admin only console variable
  local superadmin = CreateConVar('hl2hud_superadminonly', 1, { FCVAR_ARCHIVE }, 'Limits server-wide override changes to super admins only (instead of admins only)')

  -- networking
  util.AddNetworkString(NET_DEFAULT)
  util.AddNetworkString(NET_OVERRIDE)

  -- schemes
  local default = {}
  local override = {}

  -- [[ Load server configuration ]] --
  hook.Add('Initialize', HL2HUD.hookname, function()
    if game.SinglePlayer() then return end
    if file.Exists(FILE_DEFAULT, PATH) then default = util.JSONToTable(file.Read(FILE_DEFAULT, PATH)) end
    if file.Exists(FILE_OVERRIDE, PATH) then override = util.JSONToTable(file.Read(FILE_OVERRIDE, PATH)) end
  end)

  -- [[ Submit server information after joining ]] --
  hook.Add('PlayerInitialSpawn', HL2HUD.hookname, function(_player)
    if game.SinglePlayer() then return end

    -- send default scheme
    if not table.IsEmpty(default) then
      net.Start(NET_DEFAULT)
      net.WriteTable(default)
      net.Send(_player)
    end

    -- send scheme override
    if not table.IsEmpty(override) then
      net.Start(NET_OVERRIDE)
      net.WriteTable(override)
      net.Send(_player)
    end
  end)

  -- [[ Receive default scheme submittion ]] --
  net.Receive(NET_DEFAULT, function(_, _player)
    if game.SinglePlayer() then return end
    if not _player:IsAdmin() then return end
    if superadmin:GetBool() and not _player:IsSuperAdmin() then return end
    if not file.Exists(DIR, PATH) then file.CreateDir(DIR) end
    default = net.ReadTable()
    net.Start(NET_DEFAULT)
    net.WriteTable(default)
    net.Broadcast()
    file.Write(FILE_DEFAULT, util.TableToJSON(default))
  end)

  -- [[ Receive scheme override submittion ]] --
  net.Receive(NET_OVERRIDE, function(_, _player)
    if game.SinglePlayer() then return end
    if not _player:IsAdmin() then return end
    if superadmin:GetBool() and not _player:IsSuperAdmin() then return end
    if not file.Exists(DIR, PATH) then file.CreateDir(DIR) end
    override = net.ReadTable()
    net.Start(NET_OVERRIDE)
    net.WriteTable(override)
    net.Broadcast()
    file.Write(FILE_OVERRIDE, util.TableToJSON(override))
  end)

end

if CLIENT then

  HL2HUD.server = {} -- namespace

  -- [[ Receive default scheme ]] --
  net.Receive(NET_DEFAULT, function()
    local scheme = net.ReadTable()
    if table.IsEmpty(scheme) then scheme = nil end
    HL2HUD.server.default = scheme
    if HL2HUD.toolmenu.overrides then HL2HUD.toolmenu.overrides:Refresh() end
    if not table.IsEmpty(HL2HUD.settings.Client()) then return end
    HL2HUD.settings.ReloadScheme()
  end)

  -- [[ Receive server override ]] --
  net.Receive(NET_OVERRIDE, function()
    local scheme = net.ReadTable()
    if table.IsEmpty(scheme) then scheme = nil end
    HL2HUD.server.override = scheme
    if HL2HUD.toolmenu.overrides then HL2HUD.toolmenu.overrides:Refresh() end
    HL2HUD.settings.ReloadScheme()
  end)

  --[[------------------------------------------------------------------
    Submits the given scheme as the server's default.
    @param {table} scheme
  ]]--------------------------------------------------------------------
  function HL2HUD.server.SubmitDefault(scheme)
    net.Start(NET_DEFAULT)
    net.WriteTable(scheme)
    net.SendToServer()
  end

  --[[------------------------------------------------------------------
    Submits the removal of the default scheme.
  ]]--------------------------------------------------------------------
  function HL2HUD.server.RemoveDefault()
    HL2HUD.server.SubmitDefault({})
  end

  --[[------------------------------------------------------------------
    Submits the given scheme as a server-wide override.
    @param {table} scheme
  ]]--------------------------------------------------------------------
  function HL2HUD.server.SubmitOverride(scheme)
    net.Start(NET_OVERRIDE)
    net.WriteTable(scheme)
    net.SendToServer()
  end

  --[[------------------------------------------------------------------
    Submits the removal of the override.
  ]]--------------------------------------------------------------------
  function HL2HUD.server.RemoveOverride()
    HL2HUD.server.SubmitOverride({})
  end

  if game.SinglePlayer() then return end

  -- [[ Submit default scheme console command ]] --
  concommand.Add('hl2hud_submitdefault', function()
    local scheme = HL2HUD.settings.Client()
    if table.IsEmpty(scheme) then scheme = HL2HUD.scheme.DefaultSettings() end
    HL2HUD.server.SubmitDefault(scheme)
  end)

  -- [[ Submit scheme override console command ]] --
  concommand.Add('hl2hud_submitoverride', function()
    local scheme = HL2HUD.settings.Client()
    if table.IsEmpty(scheme) then scheme = HL2HUD.scheme.DefaultSettings() end
    HL2HUD.server.SubmitOverride(scheme)
  end)

  -- [[ Console command to reset server overrides ]] --
  concommand.Add('hl2hud_svreset', function()
    HL2HUD.server.RemoveDefault()
    HL2HUD.server.RemoveOverride()
  end)

end
