-----------------------------------------------------------------------------------------
--
-- level_leaderboard.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

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
	storyboard.gotoScene( "menu", "fade", 500 )

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

	local myText = display.newText( "HIGH SCORES", display.contentCenterX, 50, "101! Chunky Alpha", 32 )
	myText:setFillColor( 0.75, 0.75, 0.75 )

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="DONE",
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


	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( myText )
	group:insert( playBtn )
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