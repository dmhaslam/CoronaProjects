-----------------------------------------------------------------------------------------
--
-- statemachine.lua
--
-----------------------------------------------------------------------------------------

--------------------------------------------
local proxy = require "proxy"

local statebase = require "class_statebase"

-- forward declarations and other locals

StateMachine =
{
	CurrentState = nil,
	States = {},
}

function StateMachine:new (o)
	o=o or {}
	setmetatable(o, self )
	self.__index = self
	return o
end

function StateMachine:AddState( state, stateName )
	self.States[#self.States+1] = state
	state:SetName( stateName )
	state:SetParentStateMachine( self )
end

function StateMachine:Load( scene )
end

function StateMachine:Unload( scene )
end

function StateMachine:Initialize( scene )
end

function StateMachine:Reset()
end

function StateMachine:Update( fDt, scene )
	if self.CurrentState then
		self.CurrentState:UpdateState( fDt, scene )
	end
end

function StateMachine:GetStateByName( name )
	for i=1,#self.States do
		if self.States[i].stateName == name then
			return self.States[i]
		end
	end

	return nil
end

function StateMachine:SetState( stateName, scene )
	local newState = self:GetStateByName( stateName )
	if newState then
		if self.CurrentState then
			self.CurrentState:ExitState( scene )
		end

		self.CurrentState = newState
		self.CurrentState:EnterState( scene )
	end
end

function StateMachine:PrintStateMachineState()
	print( 'StateMachine:' )
	for i=1,#self.States do
		print( ' - '.. self.States[i].stateName )
	end

	if self.CurrentState then
		print( ' CurrentState - '.. self.CurrentState.stateName )
	end
end

return StateMachine
