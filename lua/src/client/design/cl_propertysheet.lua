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


local function addAnim(pnl,w)
    pnl.LerpAlpha = HexSh:Lerp(0,0,0.3)
    pnl.LerpWide = HexSh:Lerp(0,0,0.4)
    pnl.OnCursorEntered = function(s)
        s.LerpAlpha = HexSh:Lerp(0,255,0.3)
        s.LerpWide = HexSh:Lerp(0,w,0.4)
        s.LerpAlpha:DoLerp()
        s.LerpWide:DoLerp()
    end
    pnl.OnCursorExited = function(s)
        s.LerpAlpha = HexSh:Lerp(255,0,0.3)
        s.LerpWide = HexSh:Lerp(w,0,0.4)
        s.LerpAlpha:DoLerp()
        s.LerpWide:DoLerp()
    end
end

function PANEL:Init()
    local totwide = 110
    local minwide = 40
    self.totalmin = minwide
    self.totalwide = totwide

    self.categorys = {}
    self.buttons = {}
    self.last = nil

    local navhig = 0
    self.isBig = true
    self.LerpNavWidth = HexSh:Lerp(totwide,totwide,0.3)



    self.Navigation = vgui.Create( "DPanel", self )
	self.Navigation:Dock( LEFT )
	self.Navigation:SetWidth( 110 )
	self.Navigation:DockMargin( 0, 0, 0, 0 )
    function self.Navigation:Paint( w,h )
        navhig = h
        draw.RoundedBoxEx(2.5,0,0,w,h,HEXAGON.Col.purple,true,false,true,false)
        draw.RoundedBoxEx(2.5,2,1,w-2,h-2,HEXAGON.Col.bgGray2,true,false,true,false)
    end

    self.ScrollContent = vgui.Create( "HexSh.UI.Scroll", self.Navigation )
	self.ScrollContent:Dock( FILL )

	self.Content = vgui.Create( "Panel", self )
	self.Content:Dock( FILL )
    self.Content.Paint = nil

    self.Minimize = vgui.Create("DButton", self.Navigation)
    self.Minimize:Dock(BOTTOM)
    self.Minimize:DockMargin(1,0,0,1)
    self.Minimize:SetTall(20)
    self.Minimize:SetText("") 
    addAnim(self.Minimize,totwide-1)
    self.Minimize.Paint = function(s,w,h)
        if (s.LerpAlpha) then s.LerpAlpha:DoLerp() end 
        if (s.LerpWide) then s.LerpWide:DoLerp() end 

        draw.RoundedBox(0,0,0,w,h,HEXAGON.Col.bgButton)
        draw.RoundedBox(0,0,0,2+s.LerpWide:GetValue(),h,math.colorAlpha(HEXAGON.Col.purple,255))

        if self.isBig then 
            surface.SetDrawColor(white)
            surface.SetMaterial(HexSh:getImgurImage("CbSs5UM"))
            surface.DrawTexturedRect(w/2-7.5,2.5,15,15)
        else 
            surface.SetDrawColor(white)
            surface.SetMaterial(HexSh:getImgurImage("HeUJfla"))
            surface.DrawTexturedRect(13,2.5,15,15)
        end
    end
    self.Minimize.DoClick = function(s)
        if self.isBig == false then 
            self.LerpNavWidth = HexSh:Lerp(minwide,totwide,0.3)
            self.isBig = true
            self.StartNavWideLerp = true
            self.Navigation:SizeTo(totwide,self:GetTall(),0.3,0,-1,function()
                self.Navigation:SetWidth(totwide)
            end)
        else 
            self.LerpNavWidth = HexSh:Lerp(totwide,minwide,0.3)
            self.isBig = false
            self.StartNavWideLerp = true 
            self.Navigation:SizeTo(minwide,self:GetTall(),0.3,0,-1,function()
                self.Navigation:SetWidth(minwide)
            end)
        end
    end
end

function PANEL:AddButton(title,panel,color)
    if !IsValid(panel) then return end 


    local button = vgui.Create("DButton", self.ScrollContent)
    button:Dock(TOP)
    button:DockMargin(0,0,0,2)
    button:SetTall(30)
    button:SetText("")
    addAnim(button,self.totalwide)
    button.Paint = function(s,w,h)
        if (s.LerpWide) then s.LerpWide:DoLerp() end 

        if s:IsHovered() then 
            draw.RoundedBox(0,0,0,s.LerpWide:GetValue(),h, HexSh.adminUI.Color.purple) 
        end
        
        draw.SimpleText(title, "HexSh.admin.sheet", self.isBig and w/2 or 20, h/2, white, self.isBig and TEXT_ALIGN_CENTER or TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    panel:SetParent(self.Content)
    panel:Dock(FILL)

    if !self.last then  
        self.last = panel
        panel:SetVisible(true)
    else
        panel:SetVisible(false) 
    end


    button.DoClick = function()
        self.last:AlphaTo(0,0.2,0,function()
            self.last:SetVisible(false)
            panel:SetVisible(true)
            panel:SetAlpha(0)
            panel:AlphaTo(255,0.2,0)
            last = panel
        end)
    end
end

function PANEL:Paint(w,h)
    
end
vgui.Register("HexSh.UI.Columnsheet", PANEL, "DPanel")