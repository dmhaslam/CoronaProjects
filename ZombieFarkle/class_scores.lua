-----------------------------------------------------------------------------------------
--
-- scores.lua
--
-----------------------------------------------------------------------------------------

--------------------------------------------
local proxy = require "proxy"
local widget = require "widget"

-- forward declarations and other locals

Scores =
{
-- member
    group = {},
    width = 100,
    height = 100,
    posX = 0,
    posY = 0,
    titleButton = {},
    
    zombieButton = {},
    kind2Button = {},
    kind3Button = {},
    kind4Button = {},
    kind5Button = {},
    kind6Button = {},
    
    heroButton = {},
    hero2Button = {},
    hero3Button = {},
    hero4Button = {},
    hero5Button = {},
    hero6Button = {},
    
    different5Button = {},
    pair3Button = {},
}

function Scores:new (o)
	o=o or {}
	setmetatable(o, self )
	self.__index = self
	return o
end

function Scores:AddButton( group, buttonLabel, buttonWidth, buttonHeight, x, y )
    local newBtn = widget.newButton{
        label=buttonLabel,
        labelColor = { default={128}, over={156} },
        defaultFile="button_gray.png",
        overFile="button-over_gray.png",
        font = "101! Chunky Alpha",
        fontSize = 10,
        emboss = true,
        width=buttonWidth,
        height=buttonHeight,
    }
    newBtn.x = x
    newBtn.y = y
    
    group:insert( newBtn )
    
    return newBtn
end

function Scores:LoadImages( group )
    self.group = group
    
    self.titleButton = self:AddButton( self.group, "SCORES", 180, 20, 90, 10 )
    
    self.zombieButton = self:AddButton( self.group, "Z      ".._G.Game.Scoring.Zombie, 90, 20, 45, 30 )
    self.kind2Button = self:AddButton( self.group, "AA     ".._G.Game.Scoring.Standard_2x, 90, 20, 45, 50 )
    self.kind3Button = self:AddButton( self.group, "AAA    ".._G.Game.Scoring.Standard_3x, 90, 20, 45, 70 )
    self.kind4Button = self:AddButton( self.group, "AAAA   ".._G.Game.Scoring.Standard_4x, 90, 20, 45, 90 )
    self.kind5Button = self:AddButton( self.group, "AAAAA  ".._G.Game.Scoring.Standard_5x, 90, 20, 45, 110 )
    self.kind6Button = self:AddButton( self.group, "AAAAAA ".._G.Game.Scoring.Standard_6x, 90, 20, 45, 130 )
    
    self.heroButton = self:AddButton( self.group, "H      ".._G.Game.Scoring.Hero_1x, 90, 20, 135, 30 )
    self.hero2Button = self:AddButton( self.group, "HH     ".._G.Game.Scoring.Hero_2x, 90, 20, 135, 50 )
    self.hero3Button = self:AddButton( self.group, "HHH    ".._G.Game.Scoring.Hero_3x, 90, 20, 135, 70 )
    self.hero4Button = self:AddButton( self.group, "HHHH   ".._G.Game.Scoring.Hero_4x, 90, 20, 135, 90 )
    self.hero5Button = self:AddButton( self.group, "HHHHH  ".._G.Game.Scoring.Hero_5x, 90, 20, 135, 110 )
    self.hero6Button = self:AddButton( self.group, "HHHHHH ".._G.Game.Scoring.Hero_6x, 90, 20, 135, 130 )
    
    self.pair3Button = self:AddButton( self.group, "AABBCC ".._G.Game.Scoring.ThreePair, 180, 20, 90, 150 )
    self.different5Button = self:AddButton( self.group, "ABCDE  ".._G.Game.Scoring.FiveStraight, 180, 20, 90, 170 )
end

function Scores:SetSize( width, height )
    self.width = width
    self.height = height
    
    self:UpdatePositions()
end

function Scores:SetPosition( x, y )
    self.posX = x
    self.posY = y
    
    self:UpdatePositions()
end

function Scores:UpdateButton( button, width, height, x, y )
--    button.width = width
--    button.height = height
--    button.x = x
--    button.y = y 
end

function Scores:UpdatePositions()
    local titleButtonHeight = 0
    local buttonHeight = 0
    local curHeight = self.height
    
    while curHeight > 9 do
        buttonHeight = buttonHeight + 1
        curHeight = curHeight - 9
    end
    
    titleButtonHeight = buttonHeight + curHeight
    
    local fullWidth = self.width
    local halfWidth = self.width/2
    
    local curX, curYCol1, curYCol2, curYFull
    curX = titleButtonHeight/2 + self.posX
    curYCol1 = self.posY + self.width/4
    curYCol2 = curYCol1 + halfWidth
    curYFull = self.posY + halfWidth
    
    self:UpdateButton( self.titleButton, fullWidth, titleButtonHeight, curYFull, curX )
    curX = curX + titleButtonHeight
    
    self:UpdateButton( self.zombieButton, halfWidth, buttonHeight, curYCol1, curX )
    self:UpdateButton( self.heroButton, halfWidth, buttonHeight, curYCol2, curX )
    curX = curX + buttonHeight
    
    self:UpdateButton( self.kind2Button, halfWidth, buttonHeight, curYCol1, curX )
    self:UpdateButton( self.hero2Button, halfWidth, buttonHeight, curYCol2, curX )
    curX = curX + buttonHeight
    
    self:UpdateButton( self.kind3Button, halfWidth, buttonHeight, curYCol1, curX )
    self:UpdateButton( self.hero3Button, halfWidth, buttonHeight, curYCol2, curX )
    curX = curX + buttonHeight
    
    self:UpdateButton( self.kind4Button, halfWidth, buttonHeight, curYCol1, curX )
    self:UpdateButton( self.hero4Button, halfWidth, buttonHeight, curYCol2, curX )
    curX = curX + buttonHeight
    
    self:UpdateButton( self.kind5Button, halfWidth, buttonHeight, curYCol1, curX )
    self:UpdateButton( self.hero5Button, halfWidth, buttonHeight, curYCol2, curX )
    curX = curX + buttonHeight
    
    self:UpdateButton( self.kind6Button, halfWidth, buttonHeight, curYCol1, curX )
    self:UpdateButton( self.hero6Button, halfWidth, buttonHeight, curYCol2, curX )
    curX = curX + buttonHeight
    
    self:UpdateButton( self.pair3Button, fullWidth, buttonHeight, curYFull, curX )
    curX = curX + buttonHeight
    self:UpdateButton( self.different5Button, fullWidth, buttonHeight, curYFull, curX )
    
end

function Scores:GetGroup()
	return self.group
end

return Scores
