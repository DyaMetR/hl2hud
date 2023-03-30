--[[------------------------------------------------------------------
  Override API.

  Allows addon developers and server owners to submit partial or
  complete overrides of the clients' schemes.

  > HL2HUD.override.Submit(id, scheme)
    - Apply a scheme override. You can find the scheme table structure
    in the 'ischeme.lua' script file.

  > Hl2HUD.override.Remove(id)
    - Reverts an override.

  WARNING: Do not submit overrides in loops or paint functions as
  reloading the scheme is a costly procedure. It's going to lag. A lot.
]]--------------------------------------------------------------------

if SERVER then return end

HL2HUD.override = {} -- namespace

--[[------------------------------------------------------------------
  Adds the given scheme override to the list and reloads the scheme.
  @param {string} override identifier
  @param {table} scheme
]]--------------------------------------------------------------------
function HL2HUD.override.Submit(id, scheme)
  HL2HUD.settings.overrides[id] = scheme
  HL2HUD.settings.ReloadScheme()
end

--[[------------------------------------------------------------------
  Removes a scheme override from the list and reloads the scheme.
  @param {string} override identifier
]]--------------------------------------------------------------------
function HL2HUD.override.Remove(id)
  HL2HUD.settings.overrides[id] = nil
  HL2HUD.settings.ReloadScheme()
end

--[[------------------------------------------------------------------
  Returns an override's data.
  @param {string} override identifier
  @return {table} scheme data
]]--------------------------------------------------------------------
function HL2HUD.override.Get(id)
  return HL2HUD.settings.overrides[id]
end
