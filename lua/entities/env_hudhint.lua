
ENT.Type    = 'point'

function ENT:KeyValue(key, value)
  if key ~= 'message' then return end
  self.m_iszMessage = value
end
