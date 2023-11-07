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

local PANEL = {}

local black = Color(0,0,0,255)
local white = Color(255,255,255)
local bgButton = Color(45,45,45) -- buttonhovere
local bgDarkGray = Color(33,31,31)
local bgLightGray = Color(49,47,50)
local bghovergray = Color(46,48,52,250)
local getAlpha = function(col, a)
    return Color(col["r"], col["g"], col["b"], a)
end

function PANEL:Init()
    self.Items = {}
    self.Cur = nil 

    self.Nav = vgui.Create("DHorizontalScroller",self)
        self.Nav:Dock(TOP)
        self.Nav:SetTall(25)
        self.Nav:DockMargin(0,0,0,0)
        function self.Nav:Paint(w,h)
            draw.RoundedBox(0,0,0,w,h,bgDarkGray)
        end
    -->

    self.Content = vgui.Create("DPanel",self)
    self.Content:Dock(FILL)
    self.Content:DockMargin(0,10,0,0) 
    self.Content.Paint = nil
end

surface.CreateFont( "HexSh.admin.sheet", {
    font = "Montserrat", 
    extended = false,
    size = 19,
    weight = 1000,
} )
function PANEL:AddSheet(title, pnl, icon, tooltip)
    
    local sheet = vgui.Create("HexSh.UI.Button",self.Nav)
    sheet.DoClick = function(s)
        if (self.Cur) then 
            self.Cur:AlphaTo(0,0.15,0, function()
                self.Cur:SetVisible(false)
                self.Cur = s.Panel
                s.Panel:SetVisible(true)
                s.Panel:SetAlpha(0)
                s.Panel:AlphaTo(255,0.15,0)
            end)
        else
            self.Cur = s.Panel
            s.Panel:SetVisible(true)
            s.Panel:SetAlpha(0)
            s.Panel:AlphaTo(255,0.15,0)
        end
    end
    sheet:Dock(LEFT)
    sheet:SetWide(140)
    sheet:DockMargin(0,0,3,0)
    sheet:SetText("")
    sheet.Paint = function(s,w,h)
        if s.Lerp then s.Lerp:DoLerp() end 

        draw.RoundedBox(0, 0, h-2, w, 2, (self.Cur == s.Panel && HexSh.adminUI.Color.purple) || s.Lerp:GetValue() > 1 && math.colorAlpha(HexSh.adminUI.Color.purple, s.Lerp:GetValue()) || HexSh.adminUI.Color.bgGray)
        if s:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, math.colorAlpha(HexSh.adminUI.Color.purple,120)) end
        
        if icon then  
            surface.SetDrawColor(white)
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(math.toDecimal(6.4)*90,5,15,15)
        end
        
        draw.SimpleText(title, "DermaDefault", icon && 25 || w/2, h/2, white, icon && TEXT_ALIGN_LEFT || TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end


    pnl:SetVisible(false)
    pnl:SetParent(self.Content)
    pnl:Dock(FILL)

    sheet.Panel = pnl

    if (#self.Items==0) then 
        sheet.Panel:SetVisible(true)
        sheet.Panel:SetAlpha(0)
        sheet.Panel:AlphaTo(255,0.15,0)
        self.Cur = sheet.Panel
    end

    table.insert(self.Items, sheet)
    return sheet
end

function PANEL:Paint(w,h)
return 
end

vgui.Register("HexSh.adminUI.Propertysheet", PANEL, "DPanel")








------------------->
-- columsheet

local PANEL = {}

AccessorFunc( PANEL, "ActiveButton", "ActiveButton" )

function PANEL:Init()

	self.Navigation = vgui.Create( "DScrollPanel", self )
	self.Navigation:Dock( LEFT )
	self.Navigation:SetWidth( 100 )
	self.Navigation:DockMargin( 10, 10, 10, 0 )

	self.Content = vgui.Create( "Panel", self )
	self.Content:Dock( FILL )

	self.Items = {}

end

function PANEL:UseButtonOnlyStyle()
	self.ButtonOnly = true
end

function PANEL:AddSheet( label, panel, material )

	if ( !IsValid( panel ) ) then return end

	local Sheet = {}

	if ( self.ButtonOnly ) then
		Sheet.Button = vgui.Create( "DImageButton", self.Navigation )
	else
		Sheet.Button = vgui.Create( "HexSh.UI.Button", self.Navigation )
	end

	Sheet.Button:SetImage( material )
	Sheet.Button.Target = panel
	Sheet.Button:Dock( TOP )
	Sheet.Button:SetText( label )
	Sheet.Button:DockMargin( 0, 1, 0, 0 )

	Sheet.Button.DoClick = function()
		self:SetActiveButton( Sheet.Button )
	end

	Sheet.Panel = panel
	Sheet.Panel:SetParent( self.Content )
	Sheet.Panel:SetVisible( false )

	if ( self.ButtonOnly ) then
		Sheet.Button:SizeToContents()
		--Sheet.Button:SetColor( Color( 150, 150, 150, 100 ) )
	end

	table.insert( self.Items, Sheet )

	if ( !IsValid( self.ActiveButton ) ) then
		self:SetActiveButton( Sheet.Button )
	end
	
	return Sheet
end

function PANEL:SetActiveButton( active )

	if ( self.ActiveButton == active ) then return end

	if ( self.ActiveButton && self.ActiveButton.Target ) then
		self.ActiveButton.Target:SetVisible( false )
		self.ActiveButton:SetSelected( false )
		self.ActiveButton:SetToggle( false )
		--self.ActiveButton:SetColor( Color( 150, 150, 150, 100 ) )
	end

	self.ActiveButton = active
	active.Target:SetVisible( true )
	active:SetSelected( true )
	active:SetToggle( true )
	--active:SetColor( color_white )

	self.Content:InvalidateLayout()

end


derma.DefineControl("HexSh.UI.Columnsheet","",PANEL,"Panel")