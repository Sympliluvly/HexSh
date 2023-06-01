--Dmenu

local PANEL = {}
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
   --self:GetCanvas():GetChildren() 
end

function PANEL:Paint(w,h)
    draw.RoundedBox(7.5,0,0,w,h,bgLightGray)
end

vgui.Register("HexSH.UI.Menu", PANEL, "DMenu")