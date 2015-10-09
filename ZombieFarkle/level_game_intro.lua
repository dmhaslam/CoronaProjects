-----------------------------------------------------------------------------------------
--
-- level_game_intro.lua
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
--	storyboard.gotoScene( "level_game_faction_select", "fade", 500 )
	storyboard.gotoScene( "level_game", "fade", 500 )

	return true	-- indicates successful touch
end

-- Our ScrollView listener
local function scrollListener( event )
	local phase = event.phase
	local direction = event.direction

	if "began" == phase then
		--print( "Began" )
	elseif "moved" == phase then
		--print( "Moved" )
	elseif "ended" == phase then
		--print( "Ended" )
	end

	return true
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newImageRect( "apocalypse_background_small.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	-- Create a ScrollView
--	local scrollView = widget.newScrollView
--	{
--		left = 0,
--		top = 75,
--		width = display.contentWidth,
--		height = display.contentHeight-150,
--		bottomPadding = 0,
--		id = "onBottom",
--		horizontalScrollDisabled = true,
--		verticalScrollDisabled = false,
--		listener = scrollListener,
--	}

	--Create a text object for the scrollViews title
	local titleText = display.newText("INTRO", display.contentCenterX, 48, "101! Chunky Alpha", 32)
	titleText:setFillColor( 0.75, 0.75, 0.75 )

	-- insert the text object into the created display group
--	scrollView:insert( titleText )

	--Create a large text string
	local lotsOfText = "Well, it finally happened... The zombie apocalypse is here! Maybe it was a government experiment gone awry. Maybe it was the result of some new virus. Maybe it is Mother Nature's way of pushing the reset button. We will likely never know the cause, but the walking dead now roam the world looking for sweet, delicious brains. But never fear, Humanity, mighty heroes are here to vanquish the zombie hordes! Join them in the fight to save the planet from the hordes of undead, before it is too late..."

	--Create a text object containing the large text string and insert it into the scrollView
	local lotsOfTextObject = display.newText( lotsOfText, display.contentCenterX, 0, 300, 0, "Helvetica", 18)
	lotsOfTextObject:setFillColor( 0.75, 0.75, 0.75 )
	lotsOfTextObject.anchorY = 0.0		-- Top
	--------------------------------lotsOfTextObject:setReferencePoint( display.TopCenterReferencePoint )
--	lotsOfTextObject.y = titleText.y + titleText.contentHeight + 10
	lotsOfTextObject.y = 75

--	scrollView:insert( lotsOfTextObject )

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="Begin",
		labelColor = { default={128}, over={156} },
		defaultFile="button_gray.png",
		overFile="button-over_gray.png",
		font = "101! Chunky Alpha",
		fontSize = 20,
		emboss = true,
		width=250, height=40,
		onRelease = onBeginBtnRelease	-- event listener function


--		id = "button3",
--		onEvent = buttonHandler,
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 50


	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( titleText )
--	group:insert( scrollView )
	group:insert( lotsOfTextObject )
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