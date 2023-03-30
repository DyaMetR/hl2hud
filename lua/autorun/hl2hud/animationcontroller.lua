--[[------------------------------------------------------------------
	HUD animations API.

  Sequences are declared on the schemes. If you want a sequence to be shared within
  all schemes, add it to the default one.

  > HL2HUD.animations.StartAnimationSequence(sequence)
    - Queues all animations from this sequence.

  > HL2HUD.animations.StopAnimationSequence(sequence)
    - Stops an animation event on its tracks.

	https://github.com/ValveSoftware/source-sdk-2013/blob/master/mp/src/vgui2/vgui_controls/AnimationController.cpp
]]--------------------------------------------------------------------

if SERVER then return end

HL2HUD.animations = {} -- namespace

HL2HUD.animations.CMD_ANIMATE   = 'Animate' -- exception in commands

local Interpolators_e = {} -- registered interpolation functions
local Commands_e = {} -- registered command types
local m_ActiveAnimations = {} -- currently active animations
local m_PostedMessages = {} -- queued event commands

--[[------------------------------------------------------------------
	Runs the queued commands.
]]--------------------------------------------------------------------
local function UpdatePostedMessages()
	for i, msgRef in SortedPairs(m_PostedMessages) do
		if CurTime() < msgRef.startTime then continue end
		m_PostedMessages[i] = nil -- remove the event
		Commands_e[msgRef.commandType].run(msgRef) -- run the command type
	end
end

--[[------------------------------------------------------------------
	Runs the current animations.
]]--------------------------------------------------------------------
local function UpdateActiveAnimations()
	for i, anim in SortedPairs(m_ActiveAnimations) do
		if CurTime() < anim.startTime then continue end -- see if the anim is ready to start

		local value = HL2HUD.elements.Get(anim.panel).variables[anim.variable]

		if not anim.started then
			local startValue = value
			if istable(value) then startValue = table.Copy(value) end
			anim.startValue = startValue -- start the animation from the current value
			anim.started = true
		end

		local interpolated = Interpolators_e[anim.interpolator](math.min(math.max(CurTime() - anim.startTime, 0) / (anim.endTime - anim.startTime), 1), anim.interpolatorParam)
		if istable(value) then
			HL2HUD.utils.InterpolateTableValues(anim.startValue, anim.endValue, value, interpolated)
		else
      HL2HUD.elements.Get(anim.panel):Variable(anim.variable, ((anim.endValue - anim.startValue) * interpolated) + anim.startValue)
		end

		if CurTime() >= anim.endTime then -- see if we can remove the animation
			m_ActiveAnimations[i] = nil
		end
	end
end

--[[------------------------------------------------------------------
	Removes an existing set of commands from the queue.
	@param {string} sequence
]]--------------------------------------------------------------------
local function RemoveQueuedAnimationCommands(sequence)
	-- remove messages posted by this sequence
	for i, msg in pairs(m_PostedMessages) do
		if msg.sequence ~= sequence then continue end
		m_PostedMessages[i] = nil
	end

	-- remove all animations
	for i, anim in pairs(m_ActiveAnimations) do
		if anim.sequence ~= sequence then continue end
		m_ActiveAnimations[i] = nil
	end
end
HL2HUD.animations.StopAnimationSequence = RemoveQueuedAnimationCommands -- export function

--[[------------------------------------------------------------------
	Runs a single line of the script.
	@param {string} sequence
	@param {table} command
]]--------------------------------------------------------------------
local function ExecAnimationCommand(sequence, cmd)
	if cmd.commandType == HL2HUD.animations.CMD_ANIMATE then
		local startTime = CurTime() + cmd.startTime
		local target = cmd.target
		if isstring(target) then target = HL2HUD.settings.Get().ClientScheme.Colors[target] end
		m_ActiveAnimations[table.maxn(m_ActiveAnimations) + 1] = {
			panel = cmd.panel,
			sequence = sequence,
			variable = cmd.variable,
			interpolator = cmd.interpolator,
			interpolatorParam = cmd.interpolatorParam,
			startTime = startTime,
			endTime = startTime + cmd.duration,
			started = false,
			endValue = target
		}
	else
		m_PostedMessages[table.maxn(m_PostedMessages) + 1] = {
			sequence = sequence,
			commandType = cmd.commandType,
      param = cmd.param,
      param2 = cmd.param2,
			startTime = CurTime() + cmd.startTime
		}
	end
end

--[[------------------------------------------------------------------
	Runs an independent animation.
  @param {string} panel
  @param {string} variable
  @param {any} value
  @param {number} start time
  @param {number} duration
  @param {string} interpolator
  @param {number|nil} interpolator parameter
]]--------------------------------------------------------------------
function HL2HUD.animations.RunAnimationCommand(panel, variable, value, startTime, duration, interpolator, interpolatorParam)
  ExecAnimationCommand(nil, { commandType = HL2HUD.animations.CMD_ANIMATE, panel = panel, variable = variable, startTime = startTime, duration = duration, interpolator = interpolator, interpolatorParam = interpolatorParam })
end

--[[------------------------------------------------------------------
	Stops all animations ocurring on the given panel's variables.
  @param {string} panel name
  @param {string} sequence to ignore
]]--------------------------------------------------------------------
function HL2HUD.animations.StopPanelAnimations(panel, sequence)
  for i, anim in pairs(m_ActiveAnimations) do
    if anim.panel ~= panel or (sequence and anim.sequence == sequence) then continue end
    m_ActiveAnimations[i] = nil
  end
end

--[[------------------------------------------------------------------
	Stops animations running on the given panel's variable.
  @param {string} panel
  @param {string} variable
  @param {string} sequence to ignore
]]--------------------------------------------------------------------
function HL2HUD.animations.StopAnimation(panel, variable, sequence)
  for i, anim in pairs(m_ActiveAnimations) do
    if anim.panel ~= panel or anim.variable ~= variable or (sequence and anim.sequence == sequence) then continue end
    m_ActiveAnimations[i] = nil
  end
end

--[[------------------------------------------------------------------
	Returns all registered interpolators.
  @return {table} interpolators
]]--------------------------------------------------------------------
function HL2HUD.animations.GetInterpolators()
  return Interpolators_e
end

--[[------------------------------------------------------------------
	Returns all registered command types.
  @return {table} command types
]]--------------------------------------------------------------------
function HL2HUD.animations.GetCommandTypes()
  return Commands_e
end

--[[------------------------------------------------------------------
	Runs the queued commands.
]]--------------------------------------------------------------------
function HL2HUD.animations.UpdateAnimations()
	UpdatePostedMessages()
	UpdateActiveAnimations()
end

--[[------------------------------------------------------------------
	Starts an animation sequence script.
	@param {string} sequence
]]--------------------------------------------------------------------
function HL2HUD.animations.StartAnimationSequence(sequence)
	-- remove the existing command from the queue
	RemoveQueuedAnimationCommands(sequence)

	-- look through for the sequence
	local commands = HL2HUD.settings.Get().HudAnimations[sequence]

	-- execute the sequence
	for i, cmd in pairs(commands) do
		ExecAnimationCommand(sequence, cmd)
	end
end

--[[------------------------------------------------------------------
	Clears all posted animation sequences and messages.
]]--------------------------------------------------------------------
function HL2HUD.animations.Clear()
  table.Empty(m_ActiveAnimations)
  table.Empty(m_PostedMessages)
end

-- [[ Interpolators ]] --
Interpolators_e.Linear = function(t) return t end
Interpolators_e.Accel = function(t) return math.pow(t, 2) end
Interpolators_e.Deaccel = function(t) return 1 - math.pow(1 - t, 2) end
Interpolators_e.Pulse = function(t, param) return .5 + .5 * math.cos(t * 2 * math.pi * param) end
Interpolators_e.Flicker = function(t, param) if math.random() < param then return 1 else return 0 end end

-- [[ Command types ]] --

-- option fetching functions
local getSequences = function(scheme) return scheme.HudAnimations end

-- register command types
Commands_e.Animate = true -- workaround for the animations editor
Commands_e.RunEvent = { run = function(msg) HL2HUD.animations.StartAnimationSequence(msg.param) end, options = getSequences }
Commands_e.StopEvent = { run = function(msg) HL2HUD.animations.StopAnimationSequence(msg.param) end, options = getSequences }
Commands_e.StopAnimation = { run = function(msg) HL2HUD.animations.StopAnimation(msg.param, msg.param2, msg.sequence) end, options = HL2HUD.elements.All, optional = function(element) return HL2HUD.elements.Get(element).variables end }
Commands_e.StopPanelAnimations = { run = function(msg) HL2HUD.animations.StopPanelAnimations(msg.param, msg.sequence) end, options = HL2HUD.elements.All }
