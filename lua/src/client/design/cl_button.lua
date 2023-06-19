--Button

local PANEL  = {}
local deactivatered = Color(250,0,0,130)

local black = Color(0,0,0,255)
local white = Color(255,255,255)
 --bg
local bgButton = Color(45,45,45) -- buttonhovere
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
    if (self:GetDisabled() == true) then 
        draw.RoundedBox(7.5,0,0,w,h,bgLightGray)
        draw.RoundedBox(7.5,0,0,w,h,deactivatered)
    else
        draw.RoundedBox(7.5,0,0,w,h,bgLightGray)
    end

    if (self.Lerp:GetValue() > 0 && !self:GetDisabled()) then 
        draw.RoundedBox(7.5,0,0,w,h,getAlpha(HexSh.adminUI.Color.purple,self.Lerp:GetValue()))
    end
end

vgui.Register("HexSh.UI.Button", PANEL, "DButton")