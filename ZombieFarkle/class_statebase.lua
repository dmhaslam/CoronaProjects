-----------------------------------------------------------------------------------------
--
-- statebase.lua
--
-----------------------------------------------------------------------------------------

--------------------------------------------
local proxy = require "proxy"

-- forward declarations and other locals

StateBase =
{
	stateName = '',
	parentStateMachine = nil
}

function StateBase:new (o)
	o=o or {}
	setmetatable(o, self )
	self.__index = self
	return o
end

function StateBase:SetName( name )
	self.stateName = name
end

function StateBase:SetParentStateMachine( parentSM )
	self.parentStateMachine = parentSM
end

function StateBase:EnterState( scene )
end

function StateBase:UpdateState( fDt, scene )
end

function StateBase:ExitState( scene )
end

return StateMachine
