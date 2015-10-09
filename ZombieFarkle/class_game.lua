-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

print( 'processing game.lua' )

local die = require "class_dice"
local scores = require "class_scores"
--local statemachine = require "class_statemachine"
--local statebase = require "class_statebase"
local stateMachineGame = require "class_statemachine_game"



Game =
{
-- members
	CurrentHero = -1,
	HeroDie = die:new(),
	Dice =
	{
		die:new(),
		die:new(),
		die:new(),
		die:new(),
		die:new(),
		die:new(),
	},

	DiceActivePositions =
	{
		{ 0, 0 },
		{ 0, 0 },
		{ 0, 0 },
		{ 0, 0 },
		{ 0, 0 },
		{ 0, 0 },
	},

	DiceLockedPositions =
	{
		{ 0, 0 },
		{ 0, 0 },
		{ 0, 0 },
		{ 0, 0 },
		{ 0, 0 },
		{ 0, 0 },
	},

	Scoring =
	{
		Zombie = -50,
		Hero_1x = 100,
		Hero_2x = 200,
		Hero_3x = 600,
		Hero_4x = 1000,
		Hero_5x = 1500,
		Hero_6x = 2000,
		Standard_2x = 100,
		Standard_3x = 300,
		Standard_4x = 500,
		Standard_5x = 750,
		Standard_6x = 1000,
		ThreePair = 1000,
		FiveStraight = 750,
	},

        Constants =
        {
            MODIFIED_SCORE_INIT = 500,
            ZOMBIE_SCORE = 10,
            ZOMBIE_FARKLE_DELTA = 10,
            ZOMBIE_ATTACK_DELTA = 0,
            HORDE_TURN_DELAY = 3,
            TURN_ZOMBIE_SCORE_DELTA = 5,
        },
        
	diceSize = 60,
	diceSpacing = 5,

	stateMachine = stateMachineGame:new(),
	scene = nil,
	scoreButton = nil,
	rollButton = nil,
        
        totalScoreValue = nil,
        totalScore = 0,
        
        currentScoreValue = nil,
        currentScore = 0,
        
        modifiedScoreValue = nil,
        modifiedScore = 0,
        
        turnCount = 0,
        curZombieScore = 0,
        curTurnScoreDelta = 0,
        
        scoreTable = scores:new(),
}

function Game:ButtonListener( event )
--	if "ended" == event.phase then
--		local dieGroup = event.target

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
--		return true
--	end
end

function Game:InitializeStateMachine()
	self.stateMachine:Load()
	self.stateMachine:Initialize( self.scene )
        
        self.curZombieScore = self.Constants.ZOMBIE_SCORE
end

function Game:Update( fDt )
	self.stateMachine:Update( fDt, self.scene )
--	print( 'Game:Update( fDt ) called...' )
end

function Game:InitializeScene( group )
	self.scene = group
	self.HeroDie:LoadImages()
	group:insert( self.HeroDie:GetGroup() )
	for i=1,6 do
		self.Dice[i]:LoadImages()
		group:insert( self.Dice[i]:GetGroup() )
	end

	self.HeroDie:SetSizeInPixels( screenH/8 )
	self.HeroDie:SetPosition( screenW*0.5, screenH-30 )

	local diceHeight = screenH/10
	self.Dice[1]:SetPosition( screenW*0.5-70, screenH*0.5-70 )
	self.Dice[2]:SetPosition( screenW*0.5, screenH*0.5-70 )
	self.Dice[3]:SetPosition( screenW*0.5+70, screenH*0.5-70 )
	self.Dice[4]:SetPosition( screenW*0.5-70, screenH*0.5-140 )
	self.Dice[5]:SetPosition( screenW*0.5, screenH*0.5-140 )
	self.Dice[6]:SetPosition( screenW*0.5+70, screenH*0.5-140 )

        self.Dice[1].index = 1
        self.Dice[2].index = 2
        self.Dice[3].index = 3
        self.Dice[4].index = 4
        self.Dice[5].index = 5
        self.Dice[6].index = 6
        
        self.scoreTable:LoadImages( group )
        self.scoreTable:SetSize( 150, 200 )
        self.scoreTable:SetPosition( 5, 5 )
end

function Game:UpdateDicePositions()
	local actieRowHeight1 = screenH - ( 30 + self.diceSpacing*2 + self.diceSize*2 )
	local actieRowHeight2 = screenH - ( 30 + self.diceSpacing + self.diceSize )
	self.DiceActivePositions[1] = { halfW - (self.diceSpacing + self.diceSize), actieRowHeight1 }
	self.DiceActivePositions[2] = { halfW, actieRowHeight1 }
	self.DiceActivePositions[3] = { halfW + (self.diceSpacing + self.diceSize), actieRowHeight1 }
	self.DiceActivePositions[4] = { halfW - (self.diceSpacing + self.diceSize), actieRowHeight2 }
	self.DiceActivePositions[5] = { halfW, actieRowHeight2 }
	self.DiceActivePositions[6] = { halfW + (self.diceSpacing + self.diceSize), actieRowHeight2 }

	local lockedRowHeight = screenH - ( 40 + self.diceSpacing*3 + self.diceSize*2.5 )
	self.DiceLockedPositions[1] = { halfW - (self.diceSpacing*2.5 + self.diceSize*1.25), lockedRowHeight }
	self.DiceLockedPositions[2] = { halfW - (self.diceSpacing*1.5 + self.diceSize*0.75), lockedRowHeight }
	self.DiceLockedPositions[3] = { halfW - (self.diceSpacing*0.5 + self.diceSize*0.25), lockedRowHeight }
	self.DiceLockedPositions[4] = { halfW + (self.diceSpacing*0.5 + self.diceSize*0.25), lockedRowHeight }
	self.DiceLockedPositions[5] = { halfW + (self.diceSpacing*1.5 + self.diceSize*0.75), lockedRowHeight }
	self.DiceLockedPositions[6] = { halfW + (self.diceSpacing*2.5 + self.diceSize*1.25), lockedRowHeight }
end

function Game:SetDiceSize( size )
	self.diceSize = size
	self:UpdateDicePositions()
	self:UpdateDice()
end

function Game:SetDiceSpacing( spacing )
	self.diceSpacing = spacing
	self:UpdateDicePositions()
	self:UpdateDice()
end

function Game:UpdateDice()
	local activeDiceIndex = 0
	local lockedDiceIndex = 0

	self:UpdateDicePositions()

	local selectedDieCount = 0
	for i=1,6 do
		if self.Dice[i].locked or self.Dice[i].selected then
			selectedDieCount = selectedDieCount + 1
		end
	end

	print( 'selectedDieCount = '..selectedDieCount )
	if selectedDieCount > 0 then
		for i=1,selectedDieCount do
			local lowestIndex = 10000
			for d=1,6 do
				if self.Dice[d].locked or self.Dice[d].selected then
					if self.Dice[d].curRenderSlotLocked < lowestIndex and self.Dice[d].curRenderSlotLocked >= i then
						lowestIndex = self.Dice[d].curRenderSlotLocked
					end
				end
			end
			print( 'lowestIndex = '..lowestIndex )
			for d=1,6 do
				if self.Dice[d].locked or self.Dice[d].selected then
					if self.Dice[d].curRenderSlotLocked == lowestIndex then
						self.Dice[d].curRenderSlotLocked = i
					end
				end
			end
		end
	end

--	self:PrintDiceState()

--	print( self.diceSize )
	for i=1,6 do
		if self.Dice[i].active and not self.Dice[i].selected then
			self.Dice[i]:SetSizeInPixels( self.diceSize )
			activeDiceIndex = activeDiceIndex+1
			self.Dice[i]:SetPosition( self.DiceActivePositions[self.Dice[i].curRenderSlotActive][1], self.DiceActivePositions[self.Dice[i].curRenderSlotActive][2] )
		else
			self.Dice[i]:SetSizeInPixels( self.diceSize/2 )
			lockedDiceIndex = lockedDiceIndex+1
			self.Dice[i]:SetPosition( self.DiceLockedPositions[self.Dice[i].curRenderSlotLocked][1], self.DiceLockedPositions[self.Dice[i].curRenderSlotLocked][2] )
		end
	end
        
        local hasPoints, pointTotal = self:EvaluateDicePointTotal( true )
        local displayScore = self.currentScore + pointTotal
        self.currentScoreValue.text = displayScore
        
        self.modifiedScoreValue.text = self:GetModifiedPercentage( pointTotal )
        _G.Game.curTurnScoreDeltaValue.text = _G.Game.modifiedScore
        
        if hasPoints then
            self.scoreButton:setEnabled( true )
            self.rollButton:setEnabled( true )
        end
end

function Game:ShowDice( show )
	for i=1,6 do
		self.Dice[i]:Show( show )
	end
end

function Game:RollActiveDice()
	local curRenderSlot = 1
	for i=1,6 do
		if not self.Dice[i].locked then
			self.Dice[i]:Roll()
			self.Dice[i].curRenderSlotActive = curRenderSlot
			curRenderSlot = curRenderSlot + 1
		end
	end
end

function Game:EvaluateDicePointTotal( selectedOnly )
	local hasPoints = false
	local pointTotal = 0
	local diceInUse = 0

	local diceTypeCounts =
	{
		[self.Dice[1].HERO_ROBOT] = 0,
		[self.Dice[1].HERO_ALIEN] = 0,
		[self.Dice[1].HERO_NINJA] = 0,
		[self.Dice[1].HERO_PIRATE] = 0,
		[self.Dice[1].HERO_MONKEY] = 0,
		[self.Dice[1].ZOMBIE] = 0,
	}

	local diceToTest = {}
        
        local hasHero = false;
	for i=1,6 do
            if not self.Dice[i].locked then
                if self.Dice[i].currentValue == self.CurrentHero then
                    hasHero = true; 
                end
            end
        end
        
	for i=1,6 do
		if selectedOnly then
			if self.Dice[i].selected and not self.Dice[i].locked then
				if self.Dice[i].currentValue == self.Dice[i].ZOMBIE then
					diceInUse = diceInUse + 1
					hasPoints = true
                                        if not hasHero then
                                            pointTotal = pointTotal + self.Scoring.Zombie   
                                        end
				else
					self.Dice[i].scoringInUse = false
					diceToTest[#diceToTest+1] = self.Dice[i]
					diceTypeCounts[self.Dice[i].currentValue] = diceTypeCounts[self.Dice[i].currentValue] + 1
				end
			end
		else
			if self.Dice[i].active or self.Dice[i].selected then
                            if not self.Dice[i].locked then
				if self.Dice[i].currentValue == self.Dice[i].ZOMBIE then
					diceInUse = diceInUse + 1
					hasPoints = true
					if not hasHero then
                                            pointTotal = pointTotal + self.Scoring.Zombie
                                        end
				else
					self.Dice[i].scoringInUse = false
					diceToTest[#diceToTest+1] = self.Dice[i]
					diceTypeCounts[self.Dice[i].currentValue] = diceTypeCounts[self.Dice[i].currentValue] + 1
				end
                            end
			end
		end
	end

	print( 'EvaluateDicePointTotal' )
	print( '	HERO_ROBOT: '..diceTypeCounts[1] )
	print( '	HERO_ALIEN: '..diceTypeCounts[2] )
	print( '	HERO_NINJA: '..diceTypeCounts[3] )
	print( '	HERO_PIRATE: '..diceTypeCounts[4] )
	print( '	HERO_MONKEY: '..diceTypeCounts[5] )
	print( '	ZOMBIE: '..diceTypeCounts[6] )

	if #diceToTest >= 6 then
		-- check scoring sets of 6 dice
		local pairCount = 0
		for i=1,6 do
			if diceTypeCounts[i] == 6 then
				hasPoints = true
				if i==self.CurrentHero then
					pointTotal = pointTotal + self.Scoring.Hero_6x
				else
					pointTotal = pointTotal + self.Scoring.Standard_6x
				end

				for k,v in ipairs( diceToTest ) do
					v.scoringInUse = true
					diceTypeCounts[v.currentValue] = diceTypeCounts[v.currentValue]-1
				end
			elseif diceTypeCounts[i] == 2 then
				pairCount = pairCount + 1
			end

			if pairCount == 3 then
				hasPoints = true
				pointTotal = pointTotal + self.Scoring.ThreePair

				for k,v in ipairs( diceToTest ) do
					v.scoringInUse = true
					diceTypeCounts[v.currentValue] = diceTypeCounts[v.currentValue]-1
				end
                                pairCount = 0
			end
		end
	end
        if #diceToTest >= 5 then
                -- check scoring for one of each hero
                local allFive = true
                for i=1,5 do
                    if diceTypeCounts[i] < 1 then
                        allFive = false
                    end
                end
                if allFive then
                    hasPoints = true
                    pointTotal = pointTotal + self.Scoring.FiveStraight
                    for i=1,5 do
                        local diceSelected = false
                        for k,v in ipairs( diceToTest ) do
                            if v.currentValue == i then
                                if diceSelected == false then
                                    diceSelected = true
                                    v.scoringInUse = true
                                    diceTypeCounts[v.currentValue] = diceTypeCounts[v.currentValue]-1                                  
                                end
                            end
                        end
                    end
               end
                -- check scoring sets of 5 dice
		for i=1,6 do
			if diceTypeCounts[i] == 5 then
				hasPoints = true
				if i==self.CurrentHero then
					pointTotal = pointTotal + self.Scoring.Hero_5x
				else
					pointTotal = pointTotal + self.Scoring.Standard_5x
				end

				for k,v in ipairs( diceToTest ) do
					if v.currentValue == i then
						v.scoringInUse = true
						diceTypeCounts[v.currentValue] = diceTypeCounts[v.currentValue]-1
					end
				end
			end
		end
	end
        if #diceToTest >= 4 then
		-- check scoring sets of 4 dice
		for i=1,6 do
			if diceTypeCounts[i] == 4 then
				hasPoints = true
				if i==self.CurrentHero then
					pointTotal = pointTotal + self.Scoring.Hero_4x
				else
					pointTotal = pointTotal + self.Scoring.Standard_4x
				end

				for k,v in ipairs( diceToTest ) do
					if v.currentValue == i then
						v.scoringInUse = true
						diceTypeCounts[v.currentValue] = diceTypeCounts[v.currentValue]-1
					end
				end
			end
		end
	end
        if #diceToTest >= 3 then
		-- check scoring sets of 3 dice
		for i=1,6 do
			if diceTypeCounts[i] == 3 then
				hasPoints = true
				if i==self.CurrentHero then
					pointTotal = pointTotal + self.Scoring.Hero_3x
				else
					pointTotal = pointTotal + self.Scoring.Standard_3x
				end

				for k,v in ipairs( diceToTest ) do
					if v.currentValue == i then
						v.scoringInUse = true
						diceTypeCounts[v.currentValue] = diceTypeCounts[v.currentValue]-1
					end
				end
			end
		end
	end
        if #diceToTest >= 2 then
		-- check scoring sets of 2 dice
		for i=1,6 do
			if diceTypeCounts[i] == 2 then
				hasPoints = true
				if i==self.CurrentHero then
					pointTotal = pointTotal + self.Scoring.Hero_2x
				else
					pointTotal = pointTotal + self.Scoring.Standard_2x
				end

				for k,v in ipairs( diceToTest ) do
					if v.currentValue == i then
						v.scoringInUse = true
						diceTypeCounts[v.currentValue] = diceTypeCounts[v.currentValue]-1
					end
				end
			end
		end
	end
        if #diceToTest >= 1 then
		-- check scoring sets of 1 dice
		for i=1,6 do
			if diceTypeCounts[i] == 1 and i==self.CurrentHero then
				hasPoints = true
				pointTotal = pointTotal + self.Scoring.Hero_1x

				for k,v in ipairs( diceToTest ) do
					if v.currentValue == i then
						v.scoringInUse = true
						diceTypeCounts[v.currentValue] = diceTypeCounts[v.currentValue]-1
					end
				end
			end
		end
	end

	print( 'EvaluateDicePointTotal: '..pointTotal )
	return hasPoints, pointTotal
end

function Game:EvaluateRolledDice()
	local hasPoints, pointTotal = self:EvaluateDicePointTotal( false )
	for i=1,6 do
		if not self.Dice[i].locked then
			if self.Dice[i].currentValue == self.Dice[i].ZOMBIE then
				return 'State_ZombieAttack'
			end
		end
	end

	if hasPoints then
		return 'State_SelectDiceSets'
	end

	return 'State_Farkle'
end

function Game:SelectZombieDice()
        local zombieCount = 0
        for i=1,6 do
		if not self.Dice[i].locked then
			if self.Dice[i].currentValue == self.Dice[i].ZOMBIE then
				self.Dice[i].selected = true
				self.Dice[i].curRenderSlotLocked = 100+i
                                zombieCount = zombieCount + 1
                        end
		end
	end
        
        self:ScoreZombie( zombieCount )
end

function Game:ScoreSelectedDice( addToTotal )
--	print( '------------------------------------' )
--	self:PrintDiceState()
--	print( '------------------------------------' )
        local hasPoints, pointTotal = self:EvaluateDicePointTotal( true )
        self.currentScore = self.currentScore + pointTotal
        
        if addToTotal then
            self.totalScore = self.totalScore + self.currentScore
            self.totalScoreValue.text = self.totalScore
            self.modifiedScore = self.modifiedScore + self.currentScore
            self.currentScore = 0
            self.modifiedScoreValue.text = self:GetModifiedPercentage( 0 )
            self.curTurnScoreDeltaValue.text = self.modifiedScore
            self.currentScoreValue.text = self.currentScore
      end
        
        local lockedDiceCount = 0
	for i=1,6 do
		if self.Dice[i].selected then
			self.Dice[i].locked = true
		end
 		if self.Dice[i].locked then
			lockedDiceCount = lockedDiceCount + 1
		end               
	end
        
        -- check to see if all the dice are locked, if they are, unlock them.
        if lockedDiceCount == 6 or addToTotal then
            for i=1,6 do
                self.Dice[i].selected = false
                self.Dice[i].locked = false
            end
        end
end

function Game:ScoreZombie( count )
    local perZombieScore = self.curZombieScore * count
    
    if self.turnCount > self.Constants.HORDE_TURN_DELAY then
        self.modifiedScore = self.modifiedScore - perZombieScore
        self.modifiedScoreValue.text = self:GetModifiedPercentage( 0 )     
        self.curTurnScoreDeltaValue.text = self.modifiedScore
    end
end

function Game:SetModifiedScore( score, isDelta )
    if isDelta then
        self.modifiedScore = self.modifiedScore + score  
    else
        self.modifiedScore = score  
    end
    self.modifiedScoreValue.text = self:GetModifiedPercentage( 0 )   
    self.curTurnScoreDeltaValue.text = self.modifiedScore
end

function Game:GetModifiedPercentage( tempPointTotal )
    local potentialFullScore = self.totalScore + self.currentScore + tempPointTotal
    local cleanModifiedScore = potentialFullScore - self.modifiedScore - tempPointTotal
    local percentage = cleanModifiedScore / potentialFullScore
    
    if percentage > 1.0 then
        percentage = 1.0
    elseif percentage < 0.0 then
        percentage = 0.0
    end
    
    percentage = percentage * 100.0
    
    return percentage
end

function Game:ResetDice()
    for i=1,6 do
        self.Dice[i].selected = false
        self.Dice[i].locked = false
    end
end

function Game:Reset()
    self.modifiedScore = self.Constants.MODIFIED_SCORE_INIT
    self.modifiedScoreValue.text = self:GetModifiedPercentage( 0 )
    self.totalScore = 0
    self.totalScoreValue.text = self.totalScore
    self.currentScore = 0
    self.currentScoreValue.text = self.currentScore
    self.curZombieScore = self.Constants.ZOMBIE_SCORE
    self.curTurnScoreDelta = 0
    self.turnCount = 0
end
    
function Game:PrintDiceState()
	for i=1,6 do
		print( 'Dice '..i..':' )
		print( '   currentValue = '..self.Dice[i].currentValue )
		print( '   curRenderSlotActive = '..self.Dice[i].curRenderSlotActive )
		print( '   curRenderSlotLocked = '..self.Dice[i].curRenderSlotLocked )
		if self.Dice[i].active then print( '   active = true' ) else print( '   active = false' ) end
		if self.Dice[i].locked then print( '   locked = true' ) else print( '   locked = false' ) end
		if self.Dice[i].selected then print( '   selected = true' ) else print( '   selected = false' ) end
	end
end

return Game
