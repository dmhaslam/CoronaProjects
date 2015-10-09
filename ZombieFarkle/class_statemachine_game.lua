-----------------------------------------------------------------------------------------
--
-- statemachine_game.lua
--
-----------------------------------------------------------------------------------------

--------------------------------------------
local proxy = require "proxy"

local statebase = require "class_statebase"
local statemachine = require "class_statemachine"

-- include Corona's "widget" library
local widget = require "widget"

-- Create a new class that inherits from a base class
--
function inheritsFrom( baseClass, data )

    -- The following lines are equivalent to the SimpleClass example:

    -- Create the table and metatable representing the class.
    local new_class = {}
    local class_mt = { __index = new_class }

    -- Note that this function uses class_mt as an upvalue, so every instance
    -- of the class will share the same metatable.
    --
    function new_class:new()
        local newinst = {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    -- The following is the key to implementing inheritance:

    -- The __index member of the new class's metatable references the
    -- base class.  This implies that all methods of the base class will
    -- be exposed to the sub-class, and that the sub-class can override
    -- any of these methods.
    --
    if baseClass then
        setmetatable( new_class, { __index = baseClass } )
    end

    return new_class
end

-- create state: State_ChooseHero
State_ChooseHero_Data =
{
	stateName = 'State_ChooseHero',
	myText = nil,
	myText2 = nil,
	robotBtn = nil,
	alienBtn = nil,
	ninjaBtn = nil,
	pirateBtn = nil,
	monkeyBtn = nil,
}

State_ChooseHero = inheritsFrom( StateBase, State_ChooseHero_Data )

-- 'onRelease' event listener for playBtn
function State_ChooseHero:onRobotBtnRelease()
	_G.Game.CurrentHero = Die.HERO_ROBOT
	_G.Game.stateMachine:SetState( 'State_Roll', _G.Game.scene )
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
function State_ChooseHero:onAlienBtnRelease()
	_G.Game.CurrentHero = Die.HERO_ALIEN
	_G.Game.stateMachine:SetState( 'State_Roll', _G.Game.scene )
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
function State_ChooseHero:onNinjaBtnRelease()
	_G.Game.CurrentHero = Die.HERO_NINJA
	_G.Game.stateMachine:SetState( 'State_Roll', _G.Game.scene )
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
function State_ChooseHero:onPirateBtnRelease()
	_G.Game.CurrentHero = Die.HERO_PIRATE
	_G.Game.stateMachine:SetState( 'State_Roll', _G.Game.scene )
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
function State_ChooseHero:onMonkeyBtnRelease()
	_G.Game.CurrentHero = Die.HERO_MONKEY
	_G.Game.stateMachine:SetState( 'State_Roll', _G.Game.scene )
	return true	-- indicates successful touch
end

function State_ChooseHero:EnterState( scene )
	print( 'State_ChooseHero:EnterState' )

	_G.Game:ShowDice( false )
	_G.Game.scoreButton:setEnabled( false )
	_G.Game.rollButton:setEnabled( false )

	self.myText = display.newText( "Choose Your Team", display.contentCenterX, display.contentCenterY+10, "101! Chunky Alpha", 24 )
	self.myText:setFillColor( 0.75, 0.75, 0.75 )

	local buttonScale = 0.7

	-- create a widget button (which will loads level1.lua on release)
	self.robotBtn = widget.newButton{
		defaultFile="dice_robot.png",
		overFile="dice_robot.png",
		width=80, height=80,
		onRelease = self.onRobotBtnRelease	-- event listener function
	}
	self.robotBtn.x = display.contentWidth*0.5
	self.robotBtn.y = display.contentCenterY+70
	self.robotBtn:scale( buttonScale, buttonScale )

	-- create a widget button (which will loads level1.lua on release)
	self.alienBtn = widget.newButton{
		defaultFile="dice_alien.png",
		overFile="dice_alien.png",
		width=80, height=80,
		onRelease = self.onAlienBtnRelease	-- event listener function
	}
	self.alienBtn.x = display.contentWidth*0.25
	self.alienBtn.y = display.contentCenterY+70
	self.alienBtn:scale( buttonScale, buttonScale )

	-- create a widget button (which will loads level1.lua on release)
	self.ninjaBtn = widget.newButton{
		defaultFile="dice_ninja.png",
		overFile="dice_ninja.png",
		width=80, height=80,
		onRelease = self.onNinjaBtnRelease	-- event listener function
	}
	self.ninjaBtn.x = display.contentWidth*0.75
	self.ninjaBtn.y = display.contentCenterY+70
	self.ninjaBtn:scale( buttonScale, buttonScale )

	-- create a widget button (which will loads level1.lua on release)
	self.pirateBtn = widget.newButton{
		defaultFile="dice_pirate.png",
		overFile="dice_pirate.png",
		width=80, height=80,
		onRelease = self.onPirateBtnRelease	-- event listener function
	}
	self.pirateBtn.x = display.contentWidth*0.375
	self.pirateBtn.y = display.contentCenterY+140
	self.pirateBtn:scale( buttonScale, buttonScale )

	-- create a widget button (which will loads level1.lua on release)
	self.monkeyBtn = widget.newButton{
		defaultFile="dice_monkey.png",
		overFile="dice_monkey.png",
		width=80, height=80,
		onRelease = self.onMonkeyBtnRelease	-- event listener function
	}
	self.monkeyBtn.x = display.contentWidth*0.625
	self.monkeyBtn.y = display.contentCenterY+140
	self.monkeyBtn:scale( buttonScale, buttonScale )

	_G.Game.HeroDie:Show( false )

	scene:insert( self.myText )
	scene:insert( self.robotBtn )
	scene:insert( self.alienBtn )
	scene:insert( self.ninjaBtn )
	scene:insert( self.pirateBtn )
	scene:insert( self.monkeyBtn )
end

function State_ChooseHero:UpdateState( fDt, scene )
--	self.parentStateMachine:SetState( 'State_Roll', scene )
end

function State_ChooseHero:ExitState( scene )
	print( 'State_ChooseHero:ExitState' )

	scene:remove( self.myText )
	scene:remove( self.robotBtn )
	scene:remove( self.alienBtn )
	scene:remove( self.ninjaBtn )
	scene:remove( self.pirateBtn )
	scene:remove( self.monkeyBtn )
        
        _G.Game.turnCount = _G.Game.turnCount + 1
        _G.Game.curTurnScoreDelta = _G.Game.curTurnScoreDelta + _G.Game.Constants.TURN_ZOMBIE_SCORE_DELTA
        _G.Game.curZombieScore = _G.Game.curZombieScore + _G.Game.curTurnScoreDelta
end

-- create state: State_Roll
State_Roll_Data =
{
	stateName = 'State_Roll',
	waitingForRoll = true,
}

State_Roll = inheritsFrom( StateBase, State_Roll_Data )

function State_Roll:EnterState( scene )
	print( 'State_Roll:EnterState' )

--	_G.Game:ShowDice( true )
	_G.Game.HeroDie:Show( true )
	_G.Game.HeroDie:Set( _G.Game.CurrentHero )
	_G.Game:UpdateDice()
	_G.Game.rollButton:setEnabled( true )
	waitingForRoll = true
end

function State_Roll:UpdateState( fDt, scene )
end

function State_Roll:ExitState( scene )
	print( 'State_Roll:ExitState' )
	_G.Game:UpdateDice()
	_G.Game.rollButton:setEnabled( false )
end

-- create state: State_ZombieAttack
State_ZombieAttack_Data =
{
	stateName = 'State_ZombieAttack',
	curTime = 2.0,
	myText = nil,
}

State_ZombieAttack = inheritsFrom( StateBase, State_ZombieAttack_Data )

function State_ZombieAttack:EnterState( scene )
	print( 'State_ZombieAttack:EnterState' )

	curTime = 1.0
end

function State_ZombieAttack:UpdateState( fDt, scene )
	local oldTime = curTime
	curTime = curTime - fDt
	if oldTime > 0.5 and curTime <= 0.5 then
		self.myText = display.newText( "Zombies!", display.contentCenterX, display.contentCenterY+80, "101! Chunky Alpha", 32 )
		self.myText:setFillColor( 0.4, 0.6, 0.4 )
		scene:insert( self.myText )
	elseif curTime <= 0.0 then
		_G.Game:SelectZombieDice()
		_G.Game:UpdateDice()

		self.parentStateMachine:SetState( 'State_SelectDiceSets', scene )
	end
end

function State_ZombieAttack:ExitState( scene )
	print( 'State_ZombieAttack:ExitState' )
        if self.myText then
            scene:remove( self.myText )
        end
	_G.Game.scoreButton:setEnabled( true )
end

-- create state: State_Farkle
State_Farkle_Data =
{
	stateName = 'State_Farkle',
	curTime = 1.0,
	myText = nil,
}

State_Farkle = inheritsFrom( StateBase, State_Farkle_Data )

function State_Farkle:EnterState( scene )
	print( 'State_Farkle:EnterState' )
	curTime = 1.0
        _G.Game.currentScore = 0
        _G.Game.currentScoreValue.text = 0
        _G.Game:ResetDice()
end

function State_Farkle:UpdateState( fDt, scene )
--	self.parentStateMachine:SetState( 'State_SelectDiceSets', scene )
	local oldTime = curTime
	curTime = curTime - fDt
	if oldTime >0.5 and curTime <= 0.5 then
		self.myText = display.newText( "FARKLE!", display.contentCenterX, display.contentCenterY+80, "101! Chunky Alpha", 32 )
		self.myText:setFillColor( 1.0, 0.25, 0.25 )
		scene:insert( self.myText )
	elseif curTime <= 0.0 then
                _G.Game:ScoreZombie( 2 )
                if _G.Game.modifiedScore <= 0 then
                    self.parentStateMachine:SetState( 'State_Results', scene )                        
                else
                    self.parentStateMachine:SetState( 'State_ChooseHero', scene )            
                end
	end
end

function State_Farkle:ExitState( scene )
	print( 'State_ZombieAttack:ExitState' )
	scene:remove( self.myText )
end

-- create state: State_SelectDiceSets
State_SelectDiceSets_Data =
{
	stateName = 'State_SelectDiceSets',
}

State_SelectDiceSets = inheritsFrom( StateBase, State_SelectDiceSets_Data )

function State_SelectDiceSets:EnterState( scene )
	print( 'State_SelectDiceSets:EnterState' )
end

function State_SelectDiceSets:UpdateState( fDt, scene )
--	self.parentStateMachine:SetState( 'State_Score', scene )
end

function State_SelectDiceSets:ExitState( scene )
	print( 'State_SelectDiceSets:ExitState' )
end

-- create state: State_Score
State_Score_Data =
{
	stateName = 'State_Score',
}

State_Score = inheritsFrom( StateBase, State_Score_Data )

function State_Score:EnterState( scene )
	print( 'State_Score:EnterState' )
end

function State_Score:UpdateState( fDt, scene )
--	self.parentStateMachine:SetState( 'State_Results', scene )
end

function State_Score:ExitState( scene )
	print( 'State_Score:ExitState' )
end

-- create state: State_Results
State_Results_Data =
{
	stateName = 'State_Results',
	curTime = 2.0,
	myText = nil,
}

State_Results = inheritsFrom( StateBase, State_Results_Data )

function State_Results:EnterState( scene )
	print( 'State_Results:EnterState' )
	curTime = 2.0
        _G.Game.currentScore = 0
        _G.Game.currentScoreValue.text = 0
        _G.Game:ResetDice()
end

function State_Results:UpdateState( fDt, scene )
--	self.parentStateMachine:SetState( 'State_Roll', scene )
	local oldTime = curTime
	curTime = curTime - fDt
	if oldTime >1.0 and curTime <= 1.0 then
		self.myText = display.newText( "GAME OVER\n".._G.Game.totalScore, display.contentCenterX, display.contentCenterY+80, "101! Chunky Alpha", 40 )
		self.myText:setFillColor( 1.0, 0.25, 0.25 )
		scene:insert( self.myText )
	elseif curTime <= 0.0 then
                _G.Game.modifiedScore = _G.Game.Constants.MODIFIED_SCORE_INIT
                _G.Game.modifiedScoreValue.text = _G.Game:GetModifiedPercentage( 0 )
                _G.Game.totalScore = 0
                _G.Game.totalScoreValue.text = _G.Game.totalScore
                _G.Game.currentScore = 0
                _G.Game.currentScoreValue.text = _G.Game.currentScore
                _G.Game.curTurnScoreDeltaValue.text = _G.Game.modifiedScore
                
		self.parentStateMachine:SetState( 'State_ChooseHero', scene )
	end
end

function State_Results:ExitState( scene )
	print( 'State_Results:ExitState' )
	scene:remove( self.myText )
        
        _G.Game:Reset()
        _G.Game:ResetDice()
        
end




StateMachineGame_Data =
{
}

StateMachineGame = inheritsFrom( StateMachine, StateMachineGame_Data )

function StateMachineGame:Load( scene )
	print( 'StateMachineGame:Load() called...' )
	local newStateChooseHero = State_ChooseHero:new()
	self:AddState(newStateChooseHero, 'State_ChooseHero')

	local newStateRoll = State_Roll:new()
	self:AddState(newStateRoll, 'State_Roll')

	local newStateZombieAttack = State_ZombieAttack:new()
	self:AddState(newStateZombieAttack, 'State_ZombieAttack')

	local newStateFarkle = State_Farkle:new()
	self:AddState(newStateFarkle, 'State_Farkle')

	local newStateSelectDiceSets = State_SelectDiceSets:new()
	self:AddState(newStateSelectDiceSets, 'State_SelectDiceSets')

	local newStateScore = State_Score:new()
	self:AddState(newStateScore, 'State_Score')

	local newStateResults = State_Results:new()
	self:AddState(newStateResults, 'State_Results')

	self:PrintStateMachineState()
end

function StateMachineGame:Unload( scene )

end

function StateMachineGame:Initialize( scene )
	self:SetState( 'State_ChooseHero', scene )
end

return StateMachineGame
