// _Hexagon Crytpics_
// Copyright (c) 2023 Hexagon Cryptics, all rights reserved
//---------------------------------------\\
// Script: Shared (base)
// src(id): sh
// Module of: - 
//
// Do not edit this base by yourself, 
// because all functions are needed for
// our script!!!!
//---------------------------------------\\
// AUTHOR: Tameka aka 0v3rSimplified
// CO's: -
// Licensed to: -
//---------------------------------------\\
local black = Color(0,0,0,255)
local white = Color(255,255,255)
 --bg
local bgButton = Color(45,45,45) -- buttonhovere
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
    --    draw.RoundedBoxEx(7.5,0,0,w,h,HexSh.adminUI.Color.bgGray,true,true,true,true)
        draw.SimpleText(text,"HexSh.admin.FieldText", 5, h/2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    return frame
end