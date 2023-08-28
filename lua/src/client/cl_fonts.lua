--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]

surface.CreateFont( "HexSh.X", {
    font = "Montserrat", 
    extended = false,
    size = 20,
    weight = 1000,
} )
surface.CreateFont( "HexSh.Title", {
    font = "Montserrat", 
    extended = false,
    size = 45,
    weight = 1000,
} )
surface.CreateFont( "HexSh.TitleSmall", {
    font = "Montserrat", 
    extended = false,
    size = 40,
    weight = 1000,
} )
surface.CreateFont( "HexSh.UI.Title", {
    font = "Arial",
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
        font = "Arial", 
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
	font = "MuseoModerno Medium",
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
	font = "Korataki",
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