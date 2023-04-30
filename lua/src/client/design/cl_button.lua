--Button

local PANEL  = {}
local deactivatered = Color(250,0,0,130)
local purple = Color(188,19,235)
local black = Color(0,0,0,255)
local white = Color(255,255,255)
local bgGray = Color(38,35,38) --bg
local bgGray2 = Color(30,27,30)
local bgButton = Color(45,45,45) -- buttonhovere
local bgDarkGray = Color(33,31,31)
local bgLightGray = Color(49,47,50)
local bghovergray = Color(46,48,52,250)
local getAlpha = function(col, a)
    return Color(col["r"], col["g"], col["b"], a)
end

function PANEL:Init()    
    self:SetTextColor(white)

    self.Lerp = HexSh:Lerp(0,0,0.3)
end

function PANEL:OnCursorEntered()
    self.Lerp = HexSh:Lerp(0,255,0.3)
    self.Lerp:DoLerp()
end

function PANEL:OnCursorExited()
    self.Lerp = HexSh:Lerp(255,0,0.3)
    self.Lerp:DoLerp()
end

function PANEL:Paint(w,h)
    if self.Lerp then self.Lerp:DoLerp() end 

    draw.RoundedBox(7.5,0,0,w,h,bgLightGray)
    
    if (self.Lerp:GetValue() > 0) then 
        draw.RoundedBox(7.5,0,0,w,h,getAlpha(purple,self.Lerp:GetValue()))
    end
end

vgui.Register("HexSh.UI.Button", PANEL, "DButton")