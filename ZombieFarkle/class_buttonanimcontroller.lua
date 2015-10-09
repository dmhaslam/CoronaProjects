-----------------------------------------------------------------------------------------
--
-- class_smartbutton.lua
--
-----------------------------------------------------------------------------------------

--------------------------------------------
local proxy = require "proxy"

-- forward declarations and other locals

ButtonAnimController =
{
    buttonObj = nil,
    
    curAlpha = 1.0,
    targetAlpha = 1.0,
    
    curScale = 1.0,
    targetScale = 1.0,
    
    curPulseScale = 1.0,
    
    previousSize = 100,
    
    enabled = true,
    pulseWhenEnabled = false,
    
    position = { 0, 0 },
}

function ButtonAnimController:new (o)
    o=o or {}
    setmetatable(o, self )
    self.__index = self
    return o
end

function ButtonAnimController:Initialize( buttonObj )
    self.buttonObj = buttonObj
end

function ButtonAnimController:Update( fDt )
    
end

function ButtonAnimController:SetPosition( x, y )
    self.buttonObj.x = x
    self.buttonObj.y = y
end

function ButtonAnimController:SetScale( scale, immediate )
    self.targetScale = scale
    if immediate == nil or immediate == true then
        self.curScale = scale       
    end
end

function ButtonAnimController:SetSizeInPixels( size )

end

function ButtonAnimController:SetSizePercentWidth( percent, lockAspectRatio )
    
end

function ButtonAnimController:SetSizePercentHeight( percent, lockAspectRatio )
    
end

function ButtonAnimController:FadeIn( transitionTime, immediate )
    if immediate == nil or immediate == true then
        self.buttonObj.alpha = 1
    else
        self.buttonObj.alpha = 0
        transition.to (self.buttonObj, {time=transitionTime*1000, alpha=1})
    end
end

function ButtonAnimController:FadeOut( transitionTime, immediate )
    if immediate == nil or immediate == true then
        self.buttonObj.alpha = 0
    else
        self.buttonObj.alpha = 1
        transition.to (self.buttonObj, {time=transitionTime*1000, alpha=0})
    end
end

function ButtonAnimController:Enabled( enabled )
    self.enabled = enabled
end

function ButtonAnimController:GetButton()
    return self.buttonObj
end

return ButtonAnimController
