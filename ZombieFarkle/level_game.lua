-----------------------------------------------------------------------------------------
--
-- level_game.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"
--local die = require "class_dice"
--local game = require "class_game"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

-- 'onRelease' event listener for playBtn
local function onMenuBtnRelease()
        _G.Game:Reset()
        _G.Game:ResetDice()
        
        _G.Game.stateMachine:SetState( 'State_ChooseHero', _G.Game.scene )
        
        storyboard.gotoScene( "menu", "fade", 500 )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function onResetBtnRelease()
        _G.Game:Reset()
        _G.Game:ResetDice()
        
        _G.Game.stateMachine:SetState( 'State_ChooseHero', _G.Game.scene )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function onScoreBtnRelease()

	-- go to level1.lua scene
	_G.Game:ScoreSelectedDice( true )
        
        if _G.Game.modifiedScore <= 0 then
            _G.Game.stateMachine:SetState( 'State_Results', _G.Game.scene )                        
        else
            _G.Game.stateMachine:SetState( 'State_ChooseHero', _G.Game.scene )            
        end

	return true	-- indicates successful touch
end

local function onRollBtnRelease()

	if _G.Game.stateMachine.CurrentState.stateName == 'State_ZombieAttack' then
            return true
        end
                
        -- first lock any selected dice
        _G.Game:ScoreSelectedDice( false )
        
        _G.Game:ShowDice( true )
	_G.Game:RollActiveDice()
                
	_G.Game:UpdateDice()
	print( 'cur state name: '.. _G.Game.stateMachine.CurrentState.stateName )
--	if _G.Game.stateMachine.CurrentState.stateName == 'State_Roll' then
		local nextState = _G.Game:EvaluateRolledDice()
		print( nextState )
		_G.Game.stateMachine:SetState( nextState, _G.Game.scene )
--	end
	return true	-- indicates successful touch
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newImageRect( "apocalypse_background_small.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

--	local myText = display.newText( "GAME", display.contentCenterX, 50, "101! Chunky Alpha", 32 )
--	myText:setFillColor( 0.75, 0.75, 0.75 )

	-- add score button
	local buttonWidth = (screenW - screenH/8)/2
	local buttonHeight = 40 --screenH/8
	local buttonHeightHero = screenH/8
	local diceSpacing = screenH/32

	menuBtn = widget.newButton{
		label="MENU",
		labelColor = { default={128}, over={156} },
		defaultFile="button_gray.png",
		overFile="button-over_gray.png",
		font = "101! Chunky Alpha",
		fontSize = 20,
		emboss = true,
		width=buttonWidth,
		height=buttonHeight,
		onRelease = onMenuBtnRelease	-- event listener function
	}
	menuBtn.x = display.contentWidth*0.5 + (buttonWidth + buttonHeightHero)/2
	menuBtn.y = 20

	resetBtn = widget.newButton{
		label="RESET",
		labelColor = { default={128}, over={156} },
		defaultFile="button_gray.png",
		overFile="button-over_gray.png",
		font = "101! Chunky Alpha",
		fontSize = 20,
		emboss = true,
		width=buttonWidth,
		height=buttonHeight,
		onRelease = onResetBtnRelease	-- event listener function
	}
	resetBtn.x = display.contentWidth*0.5 + (buttonWidth + buttonHeightHero)/2
	resetBtn.y = 20 + buttonHeight

	scoreBtn = widget.newButton{
		label="SCORE",
		labelColor = { default={128}, over={156} },
		defaultFile="button_gray.png",
		overFile="button-over_gray.png",
		font = "101! Chunky Alpha",
		fontSize = 20,
		emboss = true,
		width=buttonWidth,
		height=buttonHeight,
		onRelease = onScoreBtnRelease	-- event listener function


--		id = "button3",
--		onEvent = buttonHandler,
	}
	scoreBtn.x = display.contentWidth*0.5 - (buttonWidth + buttonHeightHero)/2
	scoreBtn.y = display.contentHeight - 30

	-- add roll button
	rollBtn = widget.newButton{
		label="ROLL",
		labelColor = { default={128}, over={156} },
		defaultFile="button_gray.png",
		overFile="button-over_gray.png",
		font = "101! Chunky Alpha",
		fontSize = 20,
		emboss = true,
		width=buttonWidth,
		height=buttonHeight,
		onRelease = onRollBtnRelease	-- event listener function


--		id = "button3",
--		onEvent = buttonHandler,
	}
	rollBtn.x = display.contentWidth*0.5 + (buttonWidth + buttonHeightHero)/2
	rollBtn.y = display.contentHeight - 30

        totalScoreText = display.newText( "Total Score", display.contentWidth-(buttonWidth/2), 100, "101! Chunky Alpha", 12 )
        totalScoreText:setFillColor( 200/255, 200/255, 200/255 )

        totalScoreValue = display.newText( "0", display.contentWidth-(buttonWidth/2), 120, "101! Chunky Alpha", 15 )
        totalScoreValue:setFillColor( 200/255, 200/255, 200/255 )

        currentScoreText = display.newText( "Current Score", display.contentWidth-(buttonWidth/2), 150, "101! Chunky Alpha", 12 )
        currentScoreText:setFillColor( 200/255, 200/255, 200/255 )

        currentScoreValue = display.newText( "0", display.contentWidth-(buttonWidth/2), 170, "101! Chunky Alpha", 15 )
        currentScoreValue:setFillColor( 200/255, 200/255, 200/255 )

        modifiedScoreText = display.newText( "Modified Score", display.contentWidth-(buttonWidth/2), 190, "101! Chunky Alpha", 12 )
        modifiedScoreText:setFillColor( 200/255, 200/255, 200/255 )

        modifiedScoreValue = display.newText( "0", display.contentWidth-(buttonWidth/2), 210, "101! Chunky Alpha", 15 )
        modifiedScoreValue:setFillColor( 200/255, 200/255, 200/255 )

        curZombieScoreValue = display.newText( "0", display.contentWidth-(buttonWidth/2)-30, 230, "101! Chunky Alpha", 10 )
        curZombieScoreValue:setFillColor( 1, 1, 1 )
        curTurnScoreDeltaValue = display.newText( "0", display.contentWidth-(buttonWidth/2)+30, 230, "101! Chunky Alpha", 10 )
        curTurnScoreDeltaValue:setFillColor( 1, 1, 1 )

	-- all display objects must be inserted into group
	group:insert( background )
--	group:insert( myText )
	group:insert( menuBtn )
	group:insert( resetBtn )
	group:insert( scoreBtn )
	group:insert( rollBtn )
	group:insert( modifiedScoreText )
	group:insert( modifiedScoreValue )
	group:insert( totalScoreText )
	group:insert( totalScoreValue )
	group:insert( currentScoreText )
	group:insert( currentScoreValue )

	group:insert( curZombieScoreValue )
	group:insert( curTurnScoreDeltaValue )

	print( scoreBtn )
	print( rollBtn )
	_G.Game.scoreButton = scoreBtn
	_G.Game.rollButton = rollBtn
	_G.Game.modifiedScoreValue = modifiedScoreValue
	_G.Game.totalScoreValue = totalScoreValue
	_G.Game.currentScoreValue = currentScoreValue
	_G.Game.curTurnScoreDeltaValue = curTurnScoreDeltaValue

	_G.Game:InitializeScene( group )
	_G.Game:InitializeStateMachine()
        _G.Game.modifiedScore = _G.Game.Constants.MODIFIED_SCORE_INIT
        _G.Game.modifiedScoreValue.text = _G.Game:GetModifiedPercentage( 0 )
        _G.Game.curTurnScoreDeltaValue.text = _G.Game.modifiedScore
        math.randomseed( system.getTimer() )

--	_G.Game.HeroDie:Set( _G.Game.CurrentHero )
        _G.Game.HeroDie:Show( false )
	print( 'set hero size: ' .. buttonHeight )
	print( 'set hero pos: ' .. display.contentWidth*0.5 .. ', ' .. display.contentHeight - 50 )

	_G.Game:SetDiceSize( buttonHeightHero )
	_G.Game:SetDiceSpacing( diceSpacing )
	_G.Game:UpdateDice()

--	_G.Game.HeroDie:SetSizeInPixels( buttonHeight )
--	_G.Game.HeroDie:SetPosition( display.contentWidth*0.5, display.contentHeight - 50 )
end

function scene:enterFrame( event )
	local container = self.container
	_G.Game:Update( 0.01666 )
        
        curZombieScoreValue.text = _G.Game.curZombieScore
        curTurnScoreDeltaValue.text = _G.Game.modifiedScore
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view


end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view


end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

Runtime:addEventListener( "enterFrame", scene );

-----------------------------------------------------------------------------------------

return scene