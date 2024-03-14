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

surface.CreateFont( "HexSh.X", {
    font = "MuseoModerno Light", 
    extended = false,
    size = 20,
    weight = 1000, 
} )
surface.CreateFont( "HexSh.Default", {
    font = "MuseoModerno Light", 
    extended = false,
    size = 20,
    weight = 1000,
} )

surface.CreateFont( "HexSh.Title", {
    font = "MuseoModerno Light", 
    extended = false,
    size = 45,
    weight = 1000,
} )
surface.CreateFont( "HexSh.TitleSmall", {
    font = "MuseoModerno Light", 
    extended = false,
    size = 40,
    weight = 1000,
} )

surface.CreateFont( "HexSh.Large", {
    font = "MuseoModerno Light", 
    extended = false,
    size = 50,
    weight = 1000, 
} )  



surface.CreateFont( "HexSh.UI.Title", {
    font = "MuseoModerno Light",
    extended = false,
    size = ScrH() * 0.040,
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )



for i=1, 60 do    
    surface.CreateFont( "HexSh.UI."..tostring(i), {
        font = "MuseoModerno Light", 
        extended = false,
        size = ScrH() * 0.0 + i,
        weight = 1000,
        blursize = 0,
        scanlines = 0, 
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )
end

local fontdatTITLES = {
	font = "MuseoModerno Light",
	size = 40,
	weight = 4000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
}
local fontdatNormals = {
	font = "MuseoModerno Light",
	size = 20,
	weight = 2000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
}


--Titles
surface.CreateFont( "HexUI.TitlesBigest", fontdatTITLES )


fontdatTITLES.size = 50
fontdatTITLES.weight = 5000,
surface.CreateFont( "HexUI.TitlesUltimateBigest", fontdatTITLES )

fontdatTITLES.size = 20
fontdatTITLES.weight = 2000,
surface.CreateFont( "HexUI.TitlesBig", fontdatTITLES )