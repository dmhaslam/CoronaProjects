-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

--------------------------------------------
local proxy = require "proxy"

-- forward declarations and other locals

Die =
{
-- constants
	fileRobot = "dice_robot.png",
	fileAlien = "dice_alien.png",
	fileNinja = "dice_ninja.png",
	filePirate = "dice_pirate.png",
	fileMonkey = "dice_monkey.png",
	fileZombie = "dice_zombie.png",
	fileHeroBorder = "dice_hero_border.png",

	HERO_NONE = -1,
	HERO_ROBOT = 1,
	HERO_ALIEN = 2,
	HERO_NINJA = 3,
	HERO_PIRATE = 4,
	HERO_MONKEY = 5,
	ZOMBIE = 6,

-- member
	group = {},
	currentValue = -1,
	active = true,
	locked = false,
	selected = false,
	scoringInUse = false,
	infoOnly = false,
	curRenderSlotActive = 1,
	curRenderSlotLocked = -1,
	previousSize = 100,
	position = { 0, 0 },
        index = 0
}

function Die:new (o)
	o=o or {}
	setmetatable(o, self )
	self.__index = self
	return o
end

function Die:touch( event )
	if _G.Game.stateMachine.CurrentState.stateName == 'State_ZombieAttack' then
            return true
        end
	if "ended" == event.phase then
		local dieGroup = event.target
		print( 'event triggered: '..event.name )

		if self.active and not self.selected then
			self.selected = true
			self.curRenderSlotLocked = 100
		elseif self.currentValue ~= self.ZOMBIE then
			self.selected = false
			self.curRenderSlotLocked = -1
		end
		_G.Game:UpdateDice()

		-- tap only triggers change from original to different color
--		local topObject = dieGroup[1]

--		if ( topObject.isVisible ) then
--			local bottomObject = group[2]

			-- Dissolve to bottomObject (different color)
--			transition.dissolve( topObject, bottomObject, 500 )

			-- Restore after some random delay
--			transition.dissolve( bottomObject, topObject, 500, math.random( 3000, 10000 ) )
--		end

		-- we handled it so return true to stop propagation
		return true
	end
end

function Die:LoadImages()
	self.group = display.newGroup()
--	self.group = proxy.get_proxy_for( self.group )

	local imageRobot = display.newImage( self.fileRobot )
	self.group:insert( imageRobot, true )
	self.currentValue = 1

	local imageAlien = display.newImage( self.fileAlien )
	self.group:insert( imageAlien, true )
	imageAlien.isVisible = false

	local imageNinja = display.newImage( self.fileNinja )
	self.group:insert( imageNinja, true )
	imageNinja.isVisible = false

	local imagePirate = display.newImage( self.filePirate )
	self.group:insert( imagePirate, true )
	imagePirate.isVisible = false

	local imageMonkey = display.newImage( self.fileMonkey )
	self.group:insert( imageMonkey, true )
	imageMonkey.isVisible = false

	local imageZombie = display.newImage( self.fileZombie )
	self.group:insert( imageZombie, true )
	imageZombie.isVisible = false

	local imageHeroBorder = display.newImage( self.fileHeroBorder )
	self.group:insert( imageHeroBorder, true )
	imageHeroBorder.isVisible = false

	-- connect buttonListener. touching the fish will cause it to change to file2's image
	self.group:addEventListener( "touch", self )

	self:SetScale( 1.0 )

	return self.group
end

function Die:SetPosition( x, y )
	local newX = x - self.position[1]
	local newY = y - self.position[2]
	self.position = { x, y }
	self.group:translate( newX, newY )
end

function Die:SetScale( scale )
	for i=1,7 do
		local oldObject = self.group[i]
		oldObject:scale( scale, scale )
	end
end

function Die:SetSizeInPixels( size )
	local scale = size/self.previousSize
	self.previousSize = size
	for i=1,7 do
		local oldObject = self.group[i]
		oldObject:scale( scale, scale )
	end
end

function Die:Show( show )
	if show then
		for i=1,6 do
			local curObject = self.group[i]
			if i==self.currentValue then
				curObject.isVisible = true
			else
				curObject.isVisible = false
			end
		end
                if self.currentValue == _G.Game.CurrentHero then
                    self.group[7].isVisible = true
                else
                    self.group[7].isVisible = false
                end
	else
		for i=1,7 do
			local curObject = self.group[i]
			curObject.isVisible = false
		end
	end
end

function Die:Set( side )
--	print( 'setting dice to: '..side )
	if self.currentValue ~= side then
		local oldObject = self.group[self.currentValue]
		local newObject = self.group[side]
		transition.dissolve( oldObject, newObject, 10 )
		self.currentValue = side
                
                if self.currentValue == _G.Game.CurrentHero then
                    self.group[7].isVisible = true
                else
                    self.group[7].isVisible = false
                end
	end
end

function Die:Roll()
--        math.randomseed( system.getTimer() )
        local newValue = math.random( Die.HERO_ROBOT, Die.ZOMBIE )
--	print( 'newValue = '..newValue )
--        newValue = Die.HERO_ROBOT
    
	self:Set( newValue )
end

function Die:GetGroup()
	return self.group
end

return Die
