-----------------------------------------------------------------------------------------
--
-- level_game_faction_select.lua
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
local function onBeginBtnRelease()

	-- go to level1.lua scene
	storyboard.gotoScene( "level_game", "fade", 500 )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function onRobotBtnRelease()

	_G.Game.CurrentHero = Die.HERO_ROBOT

	-- go to level1.lua scene
	storyboard.gotoScene( "level_game", "fade", 500 )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function onAlienBtnRelease()

	_G.Game.CurrentHero = Die.HERO_ALIEN

	-- go to level1.lua scene
	storyboard.gotoScene( "level_game", "fade", 500 )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function onNinjaBtnRelease()

	_G.Game.CurrentHero = Die.HERO_NINJA

	-- go to level1.lua scene
	storyboard.gotoScene( "level_game", "fade", 500 )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function onPirateBtnRelease()

	_G.Game.CurrentHero = Die.HERO_PIRATE

	-- go to level1.lua scene
	storyboard.gotoScene( "level_game", "fade", 500 )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function onMonkeyBtnRelease()

	_G.Game.CurrentHero = Die.HERO_MONKEY

	-- go to level1.lua scene
	storyboard.gotoScene( "level_game", "fade", 500 )

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

	local myText = display.newText( "Choose Your", display.contentCenterX, 50, "101! Chunky Alpha", 32 )
	myText:setFillColor( 0.75, 0.75, 0.75 )
	local myText2 = display.newText( "Team", display.contentCenterX, 90, "101! Chunky Alpha", 32 )
	myText2:setFillColor( 0.75, 0.75, 0.75 )

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="START",
		labelColor = { default={128}, over={156} },
--		defaultFile="button_gray.png",
--		overFile="button-over_gray.png",
		font = "101! Chunky Alpha",
		fontSize = 28,
		emboss = true,
		width=154, height=40,
		onRelease = onBeginBtnRelease	-- event listener function


--		id = "button3",
--		onEvent = buttonHandler,
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 50

	-- create a widget button (which will loads level1.lua on release)
	robotBtn = widget.newButton{
		defaultFile="dice_robot.png",
		overFile="dice_robot.png",
		width=80, height=80,
		onRelease = onRobotBtnRelease	-- event listener function
	}
	robotBtn.x = display.contentWidth*0.5
	robotBtn.y = display.contentHeight - 300

	-- create a widget button (which will loads level1.lua on release)
	alienBtn = widget.newButton{
		defaultFile="dice_alien.png",
		overFile="dice_alien.png",
		width=80, height=80,
		onRelease = onAlienBtnRelease	-- event listener function
	}
	alienBtn.x = display.contentWidth*0.5-100
	alienBtn.y = display.contentHeight - 260

	-- create a widget button (which will loads level1.lua on release)
	ninjaBtn = widget.newButton{
		defaultFile="dice_ninja.png",
		overFile="dice_ninja.png",
		width=80, height=80,
		onRelease = onNinjaBtnRelease	-- event listener function
	}
	ninjaBtn.x = display.contentWidth*0.5+100
	ninjaBtn.y = display.contentHeight - 260

	-- create a widget button (which will loads level1.lua on release)
	pirateBtn = widget.newButton{
		defaultFile="dice_pirate.png",
		overFile="dice_pirate.png",
		width=80, height=80,
		onRelease = onPirateBtnRelease	-- event listener function
	}
	pirateBtn.x = display.contentWidth*0.33333
	pirateBtn.y = display.contentHeight - 150

	-- create a widget button (which will loads level1.lua on release)
	monkeyBtn = widget.newButton{
		defaultFile="dice_monkey.png",
		overFile="dice_monkey.png",
		width=80, height=80,
		onRelease = onMonkeyBtnRelease	-- event listener function
	}
	monkeyBtn.x = display.contentWidth*0.6666
	monkeyBtn.y = display.contentHeight - 150


	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( myText )
	group:insert( myText2 )
	group:insert( playBtn )
	group:insert( robotBtn )
	group:insert( alienBtn )
	group:insert( ninjaBtn )
	group:insert( pirateBtn )
	group:insert( monkeyBtn )
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

-----------------------------------------------------------------------------------------

return scene