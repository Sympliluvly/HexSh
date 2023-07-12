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
    self.Rounding = 8
    self.SetFix = false 
    self.Color = HexSh.adminUI.Color.purple
    self.BackgroundColor = bgLightGray
   -- self.TextAlign = "CENTER"
    --self.Val = ""
    self.Lerp = HexSh:Lerp(0,0,0.3)
end

--[[function PANEL:SetText(txt)
    self.Val = txt
end

function PANEL:SetValue(txt)
    self.Val = txt
end]]

function PANEL:SetColor(tbl)
    if (!IsColor(tbl)) then return end 
    self.Color = tbl
end
function PANEL:SetBackgroundColor(tbl)
    if (!IsColor(tbl)) then return end 
    self.BackgroundColor = tbl
end

function PANEL:OnCursorEntered()
    if (self.SetFix) then return end 
    self.Lerp = HexSh:Lerp(0,255,0.3)
    self.Lerp:DoLerp()
end

function PANEL:SetRounding(num)
    self.Rounding = num
end

function PANEL:SetFixed(bool)
    if (bool == true) then 
        self.Lerp = HexSh:Lerp(0,255,0.3)
        self.Lerp:DoLerp()
    elseif (bool == false) then
        self.Lerp = HexSh:Lerp(255,0,0.3)
        self.Lerp:DoLerp()
    end
    self.SetFix = bool
end

function PANEL:GetFixed()
    return self.SetFix
end
function PANEL:OnCursorExited()
    if (self.SetFix) then return end 
    self.Lerp = HexSh:Lerp(255,0,0.3)
    self.Lerp:DoLerp()
end

function PANEL:Paint(w,h)
    if self.Lerp then self.Lerp:DoLerp() end 
    if (self:GetDisabled() == true) then 
        draw.RoundedBox(self.Rounding,0,0,w,h,self.BackgroundColor)
        draw.RoundedBox(self.Rounding,0,0,w,h,deactivatered)
    else
        draw.RoundedBox(self.Rounding,0,0,w,h,self.BackgroundColor)
    end

    if (self.Lerp:GetValue() > 0 && !self.SetFix && !self:GetDisabled()) then 
        draw.RoundedBox(self.Rounding,0,0,w,h,getAlpha(self.Color,self.Lerp:GetValue()))
    end

    if (self.SetFix == true) then 
        draw.RoundedBox(self.Rounding,0,0,w,h,getAlpha(self.Color,self.Lerp:GetValue()))
    end
end

vgui.Register("HexSh.UI.Button", PANEL, "DButton")