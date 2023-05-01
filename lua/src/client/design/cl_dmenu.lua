--Dmenu

local PANEL = {}
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
   --self:GetCanvas():GetChildren() 
end

function PANEL:Paint(w,h)
    draw.RoundedBox(7.5,0,0,w,h,bgLightGray)
end

vgui.Register("HexSH.UI.Menu", PANEL, "DMenu")