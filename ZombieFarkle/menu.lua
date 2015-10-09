-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"
local game = require "class_game"
_G.Game = game

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5


--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()

	-- go to level1.lua scene
	storyboard.gotoScene( "level_game_intro", "fade", 500 )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for rulesBtn
local function onRulesBtnRelease()

	-- go to level1.lua scene
	storyboard.gotoScene( "level_rules", "fade", 500 )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for rulesBtn
local function onLeaderboardBtnRelease()

	-- go to level1.lua scene
	storyboard.gotoScene( "level_leaderboard", "fade", 500 )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for rulesBtn
local function onSetupBtnRelease()

	-- go to level1.lua scene
	storyboard.gotoScene( "level_setup", "fade", 500 )

	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
--
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
--
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "apocalypse_background_small.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	-- create/position logo/title image on upper-half of the screen
--	local titleLogo = display.newImageRect( "logo_zombie_farkle.png", 264, 84 )
--	titleLogo.x = display.contentWidth * 0.5
--	titleLogo.y = 100

	local titleLogo = display.newImageRect( "logo_zombie_farkle_new.png", 300, 300 )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 150

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Play Now",
		labelColor = { default={128}, over={156} },
		defaultFile="button_gray.png",
		overFile="button-over_gray.png",
		font = "101! Chunky Alpha",
		fontSize = 20,
		emboss = true,
		width=250, height=40,
		onRelease = onPlayBtnRelease	-- event listener function


--		id = "button3",
--		onEvent = buttonHandler,
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 150

	-- create a widget button (which will loads level2.lua on release)
	rulesBtn = widget.newButton{
		label="Rules",
		labelColor = { default={128}, over={156} },
		defaultFile="button_gray.png",
		overFile="button-over_gray.png",
		font = "101! Chunky Alpha",
		fontSize = 20,
		emboss = true,
		width=250, height=40,
		onRelease = onRulesBtnRelease	-- event listener function
	}
	rulesBtn.x = display.contentWidth*0.5
	rulesBtn.y = display.contentHeight - 110

	-- create a widget button (which will loads level2.lua on release)
	leaderboardBtn = widget.newButton{
		label="High Scores",
		labelColor = { default={128}, over={156} },
		defaultFile="button_gray.png",
		overFile="button-over_gray.png",
		font = "101! Chunky Alpha",
		fontSize = 20,
		emboss = true,
		width=250, height=40,
		onRelease = onLeaderboardBtnRelease	-- event listener function
	}
	leaderboardBtn.x = display.contentWidth*0.5
	leaderboardBtn.y = display.contentHeight - 70

	-- create a widget button (which will loads level2.lua on release)
	setupBtn = widget.newButton{
		label="Setup",
		labelColor = { default={128}, over={156} },
		defaultFile="button_gray.png",
		overFile="button-over_gray.png",
		font = "101! Chunky Alpha",
		fontSize = 20,
		emboss = true,
		width=250, height=40,
		onRelease = onSetupBtnRelease	-- event listener function
	}
	setupBtn.x = display.contentWidth*0.5
	setupBtn.y = display.contentHeight - 30

	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( titleLogo )
	group:insert( playBtn )
	group:insert( rulesBtn )
	group:insert( leaderboardBtn )
	group:insert( setupBtn )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)

end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)

end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
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