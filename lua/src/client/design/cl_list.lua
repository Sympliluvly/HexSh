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
 local bgButton2 = Color(27,26,26) -- buttonhovere
 local bgDarkGray = Color(33,31,31)
 local bgLightGray = Color(49,47,50)
 local bghovergray = Color(46,48,52,250)
//---------------------------------------\\

local PANEL = {}

function PANEL:AddLine(...)
    self:SetDirty( true )
	self:InvalidateLayout()

	local Line = vgui.Create( "DListView_Line", self.pnlCanvas )
	local ID = table.insert( self.Lines, Line )

	Line:SetListView( self )
	Line:SetID( ID )
    --Line:SetD

    
	-- This assures that there will be an entry for every column
	for k, v in pairs( self.Columns ) do
		Line:SetColumnText( k, "" )
    
	end
    
	for k, v in pairs( {...} ) do
		Line:SetColumnText( k, v )

	end
    
	-- Make appear at the bottom of the sorted list
	local SortID = table.insert( self.Sorted, Line )
    
	if ( SortID % 2 == 1 ) then
		Line:SetAltLine( true )
	end
    
    Line.Paint = function(s,w,h)
        if s:IsSelected() or s:IsHovered() then
            //draw.RoundedBox(0, 0, 0, w, h, Color(200,200,200,200))
            surface.SetDrawColor(Color(0,73,168))
            surface.DrawOutlinedRect(0,0,w,h,2)
        else
            if s:GetAltLine() then
                draw.RoundedBox(0, 0, 0, w, h, bgLightGray)
            else
                draw.RoundedBox(0, 0, 0, w, h, bgLightGray)
            end
        end
    end
	
    return Line
end





vgui.Register("HexSh.UI.List", PANEL, "DListView")



local PANEL = {
	SetText = function(self,msg)
		self.Title = msg;
	end,
	SetTextPosition = function(self, x,y)
		self.TitleX = x || self.TitleX
		self.TitleY = y || self.Titley
	end,
	ContentTall = function(tall)
		if !isnumber(tall) then 
			return 
		end
		self.ContentTall = tall 
	end
}

function PANEL:Init()
	self.Title = "Here your Title!"
	self.Font = "HexSh.Default"
	self.TitleX = 10
	self.TitleY = 5

	self.ContentTall = 35
	self.List = {}
	
	self.LV = vgui.Create("DPanel", self)
	self.LV:Dock(FILL) 
	self.LV:DockMargin(5,0,5,0)
	function self.LV:Paint(w,h)
		--draw.RoundedBoxEx(16,0,0,w,h,HexSh.adminUI.Color.purple,false,false,true,true) 
		draw.RoundedBoxEx(16,2,2,w-4,h-4,bgDarkGray,false,false,true,true)	
	end
	self.LV.s = vgui.Create("HexSh.UI.Scroll",self.LV)
	self.LV.s:Dock(FILL) 
	self.LV.s:DockMargin(5,5,5,0)

	local searchp = vgui.Create("HexSh.UI.TextEntry",self)        
		searchp:SetVisible(false)  
		searchp:SetBackgroundColor(bgLightGray)
		searchp:SetFont("HexSh.Default")
		searchp:SetPlaceholderText("search...")
		function searchp:OnEnter()
				local search_text = self:GetText():lower()
			if (#search_text == 0) then
					for _,v in pairs(items) do
						v:SetTall(37)
					end;
			else
				for _,v in pairs(items) do
					if (v.text:lower():find(search_text,1,true)) then
						v:SetTall(37)
					else
						v:SetTall(0)
					end
				end
			end
		end
		self.searchp = searchp
	--> 
	local searching = vgui.Create("DButton", self)
		searching:SetText("")
		searching.OnClick = false
		function searching:Paint(w,h)
			surface.SetDrawColor(white)
			surface.SetMaterial(HexSh:getImgurImage("dwo0dXG"))
			if (self.OnClick) then 
				surface.DrawTexturedRect(10,0,20,20)
			else
				surface.DrawTexturedRect(5,0,25,25)
			end
		end
		function searching:OnDepressed()
			searching.OnClick = true 
		end
		function searching:OnReleased()
			searching.OnClick = false
		end
		function searching:DoClick()
			if searchp:IsVisible() then 
				searchp:SetVisible(false)
			else
				searchp:SetVisible(true)
			end
		end
		self.searching = searching
	-->   
end
local function aPanel(self)
	local a = vgui.Create("DButton", self.LV.s)
	a:Dock(TOP)
	a:SetTall(self.ContentTall)
	a:DockMargin(0,5,5,0)
	a.fL = HexSh:Lerp(5,5,0.3)
	function a:Paint(w,h)
		if self.fL then self.fL:DoLerp() end 

		draw.RoundedBoxEx(7.5,0,0,w-10,h,HexSh.adminUI.Color.purple,true,true,true,true)
		draw.RoundedBoxEx(7.5,self.fL:GetValue(),0,w-self.fL:GetValue(),h,bgLightGray,true,true,true,true)
	end
	function a:OnCursorEntered()
		a.fL = HexSh:Lerp(5,50,0.3)
	end
	function a:OnCursorExited()
		a.fL = HexSh:Lerp(50,5,0.3)
	end
	return a
end
function PANEL:AddLine(name,tabl,uid)
	if !uid then uid = false end 

	local a = aPanel(self)
end

function PANEL:PerformLayout(w,h)
	self.LV:DockMargin(9,40,9,10)

	self.searching:SetSize(34,25)
	self.searching:SetPos(w-self.searching:GetWide() - 4,5)

	self.searchp:SetSize(90,25)

	self.searchp:SetPos(w-self.searching:GetWide()-self.searchp:GetWide() - 4,5)
end

function PANEL:Paint(w,h)
	draw.RoundedBox(16,0,0,w,h,HexSh.adminUI.Color.purple) 
	draw.RoundedBox(16,2,2,w-4,h-4,bgDarkGray)
		
	draw.SimpleText(self.Title, self.Font, self.TitleX, self.TitleY, white)
end

vgui.Register("HexSh.UI.CList", PANEL, "DPanel")


local PANEL = {}


function PANEL:Init()
		
	local ScrollBar = self:GetVBar();

	ScrollBar:SetHideButtons( true );
	ScrollBar:SetSize(5,0)

	function ScrollBar.btnGrip:Paint( w, h )  
		draw.RoundedBoxEx( 12, 0, 0, w, h, HexSh.adminUI.Color.purple, false,true,false,true ); 
	end;

	function ScrollBar.btnUp:Paint( w, h )       
		return; 
	end;

	function ScrollBar.btnDown:Paint( w, h )       
		return;
	end;
end

function PANEL:Paint( w, h )       
	--draw.RoundedBoxEx( 12, 0, 0, w, h, Color(77,14,95),false,true,false,true ); 
end;

vgui.Register("HexSh.UI.Scroll", PANEL, "DScrollPanel")