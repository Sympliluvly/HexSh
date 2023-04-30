--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
local purple = Color(188,19,235)
local black = Color(0,0,0,255)
local white = Color(255,255,255)
local bgGray = Color(38,35,38) --bg
local bgGray2 = Color(30,27,30)
local bgButton = Color(45,45,45) -- buttonhovere
local bgDarkGray = Color(33,31,31)
local bgLightGray = Color(49,47,50)
local bghovergray = Color(46,48,52,250)
local toDecimal = function( x ) return ( ( x <= 100 ) && x || 100 ) * 0.01 end;

surface.CreateFont( "HexSh.admin.FieldText", {
    font = "Montserrat", 
    extended = false,
    size = 35,
    weight = 1000,
} )
function HexSh.UI:addCfgArea(parent,tall,text)
    local frame = vgui.Create("EditablePanel",parent)
    frame:Dock(TOP)
    frame:DockMargin(4.5,4.5,4.5,4.5)
    frame:SetTall(tall)
    frame.Paint = function(s,w,h)
        draw.RoundedBoxEx(7.5,0,0,w,h,bgGray,true,true,true,true)
        draw.SimpleText(text,"HexSh.admin.FieldText", 5, h/2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    return frame
end