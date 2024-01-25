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

local bgLightGray = Color(49,47,50)
local bgButton = Color(45,45,45) -- buttonhovere
local bghovergray = Color(46,48,52,250)
local getAlpha = function(col, a)
    return Color(col["r"], col["g"], col["b"], a)
end
local toDecimal = function( x ) return ( ( x <= 100 ) && x || 100 ) * 0.01 end;
local function addAnim(pnl)
    pnl.LerpAlpha = HexSh:Lerp(0,0,0.3)
    pnl.OnCursorEntered = function(s)
        s.LerpAlpha = HexSh:Lerp(0,255,0.3)
        s.LerpAlpha:DoLerp()
    end
    pnl.OnCursorExited = function(s)
        s.LerpAlpha = HexSh:Lerp(255,0,0.3)
        s.LerpAlpha:DoLerp()
    end
end
local function AddMat(p,m)
    if !isstring(m) then 
        m = m
    else
        m =  HexSh:getImgurImage(m)
    end
    surface.SetDrawColor(white)
    surface.SetMaterial(m)
    surface.DrawTexturedRect(toDecimal(6.4)*p:GetWide(),(toDecimal(80)*p:GetTall())-25,25,25)
end
local PANEL = {}


function PANEL:Init()
    local parent = self:GetParent()
    self.Paint = nil

    self.totalwidth = 186
    local cook = cookie.GetString("HexShareds_MainBig")
    if !cook then 
        print("bneg")
        cookie.Set("HexShareds_MainBig",1) 
    end

    self.isBig = tobool(cookie.GetNumber("HexShareds_MainBig"))
    if self.isBig then 
        self.LerpWidth = HexSh:Lerp(186,186,0.3)
    else
        self.LerpWidth = HexSh:Lerp(28,28,0.3)
    end
    self.StartLerp = false 

    self.Scroll = vgui.Create("DScrollPanel",self)

    self.minimizebar = vgui.Create("DButton",self)
    self.minimizebar:SetText("")
    self.minimizebar.DoClick = function()
        if self.isBig == false then 
            self.LerpWidth = HexSh:Lerp(28,186,0.3)
            self.isBig = true
            self.StartLerp = true
            cookie.Set("HexShareds_MainBig",1) 
        else 
            self.LerpWidth = HexSh:Lerp(186,28,0.3)
            self.isBig = false
            self.StartLerp = true 
            cookie.Set("HexShareds_MainBig",0) 
        end
    end
    addAnim(self.minimizebar)
    self.minimizebar.Paint = function(s,w,h)
        if s.LerpAlpha then s.LerpAlpha:DoLerp() end 

        if (s.LerpAlpha:GetValue() > 0) then 
            draw.RoundedBox(7.5,0,0,w,h,getAlpha(bgButton,s.LerpAlpha:GetValue()))
            local hh = toDecimal(40)*self.minimizebar:GetTall()
            local y = (toDecimal(65)*self.minimizebar:GetTall())-hh
           if self.isBig then  draw.RoundedBox(100,0,y,6,hh,getAlpha(HexSh.adminUI.Color.purple,s.LerpAlpha:GetValue())) end
        end

        if self.isBig then 
            surface.SetDrawColor(white)
            surface.SetMaterial(HexSh:getImgurImage("CbSs5UM"))
            surface.DrawTexturedRect(w/2-15,9,25,25)
        else 
            surface.SetDrawColor(white)
            surface.SetMaterial(HexSh:getImgurImage("HeUJfla"))
            surface.DrawTexturedRect(2,9,22,25)
        end
    end


    function self:addEditLayer()
        if (self.EditLayer) then 
            self.EditLayer:Remove()                
        end
        self.EditLayer = vgui.Create("DPanel", parent)
        self.EditLayer:SetAlpha(0)
        self.EditLayer:AlphaTo(255,0.3,0)
        self.EditLayer.Paint = function(s,w,h)
            draw.RoundedBox(2.5,0,0,w,h,HexSh.adminUI.Color.purple)
            draw.RoundedBox(2.5,1,1,w-3,h-3,bgLightGray)
        end

    end

    self:addEditLayer()
    
    self.EditLayer.PaintOver = function(s,w,h)
        surface.SetDrawColor( white )
        surface.SetMaterial(HexSh:getImgurImage("wkm6FEZ"))
        surface.DrawTexturedRectRotated( toDecimal(50)*s:GetWide(), toDecimal(47)*s:GetTall(), 300, 300, CurTime() * 25 % 360 )
    end

    local ScrollBar = self.Scroll:GetVBar();

    ScrollBar:SetHideButtons( true );
    ScrollBar:SetSize(10,0)

    function ScrollBar.btnGrip:Paint( w, h )  
        draw.RoundedBox( 80, 0, 0, w, h, HexSh.adminUI.Color.purple ); 
    end;

    function ScrollBar:Paint( w, h )       
        draw.RoundedBox( 0, 0, 0, w, h, Color(77,14,95) ); 
    end;

    function ScrollBar.btnUp:Paint( w, h )       
        return; 
    end;

    function ScrollBar.btnDown:Paint( w, h )       
        return;
    end;


    -- buttons
    self:firstButtons()
end

function PANEL:PerformLayout(w,h)

    self.LerpWidth:DoLerp()
    if self.LerpWidth then 
        if (self.StartLerp && self.isBig && self.LerpWidth:GetValue() != 186) then 
        elseif (self.StartLerp && self.isBig == false && self.LerpWidth:GetValue() != 28) then 
            self.LerpWidth:DoLerp()
        end
        self.totalwidth = self.LerpWidth:GetValue()
    end

    self:SetSize(self.totalwidth,self:GetParent():GetTall())
    self:SetPos((self.totalwidth + 4) - self:GetWide(), self:GetParent():GetTall() - self:GetTall() + 45)

    self.Scroll:SetTall(h-99)
    self.Scroll:SetWide(self.totalwidth)


    self.minimizebar:SetSize(toDecimal(30)*self:GetParent():GetWide(),40)
    self.minimizebar:SetPos(0, h-95)
    
end

function PANEL:SetPage(...)
    local args = {...}
    if table.Count(args) == 2 then 
        local category = args[1]
        local sub = args[2]
        self:addEditLayer()
        HexSh.adminUI.Items.S[category].Btns[sub].f(self.EditLayer)

        self:Clear()
        self:AddBackButton()
        for k,v in pairs(HexSh.adminUI.Items.S[category].Btns) do 
            self:AddButton(v.title,v.icon,v.f)
        end

    elseif  table.Count(args) == 1 then 
        local name = args[1]
        self:addEditLayer()
        HexSh.adminUI.Items[name].f(self.EditLayer)
    else
        return
    end
end

function PANEL:firstButtons()
    for k, v in pairs(HexSh.adminUI.Items.S) do 
        self:AddSubMenu(k,v.title,v.icon)
    end
    
    local new = {}
    for k,v in pairs(HexSh.adminUI.Items) do 
        if k == "S" then continue end 
        new[v.order] = v
    end
    for k,v in SortedPairs(new) do
        self:AddButton(v.title,v.icon,v.f)
    end
end

function PANEL:AddBackButton()
    local btn = vgui.Create("DButton",self.Scroll)
    btn:Dock(TOP)
    btn:SetTall(40)
    btn:SetText("")
    btn.DoClick = function()
        self.Scroll:GetCanvas():AlphaTo(0,0.15,0, function()
            self.Scroll:Clear()
            self:firstButtons()
            self.Scroll:GetCanvas():AlphaTo(255,0.15,0)
        end)
    end
    addAnim(btn)
    btn.Paint = function(s,w,h)
        if s.LerpAlpha then s.LerpAlpha:DoLerp() end 


        if (s.LerpAlpha:GetValue() > 0) then 
            draw.RoundedBoxEx(7.5,0,0,w,h,getAlpha(bgButton,s.LerpAlpha:GetValue()),true,true,true,true)
            local hh = toDecimal(40)*btn:GetTall()
            local y = (toDecimal(65)*btn:GetTall())-hh
            if self.isBig then draw.RoundedBox(100,0,y,6,hh,getAlpha(HexSh.adminUI.Color.purple,s.LerpAlpha:GetValue())) end
        end

        local m = HexSh:getImgurImage("ZEJjns5")
        AddMat(s,m)

        if self.isBig == true  then 
            draw.SimpleText(HexSh:L("src_sh", "back"), "HexSh.X", (w/2)-25, h/2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end

function PANEL:AddButton(t,i,f)
    local btn = vgui.Create("DButton",self.Scroll)
    btn:Dock(TOP)
    btn:SetTall(40)
    btn:SetText("")
    btn.DoClick = function()
        self:addEditLayer()
        f(self.EditLayer)
    end
    addAnim(btn)
    btn.Paint = function(s,w,h)
        if s.LerpAlpha then s.LerpAlpha:DoLerp() end 

        if (s.LerpAlpha:GetValue() > 0) then 
            draw.RoundedBoxEx(7.5,0,0,w,h,getAlpha(bgButton,s.LerpAlpha:GetValue()),true,true,true,true)
            local hh = toDecimal(40)*btn:GetTall()
            local y = (toDecimal(65)*btn:GetTall())-hh
            if self.isBig then draw.RoundedBox(100,0,y,6,hh,getAlpha(HexSh.adminUI.Color.purple,s.LerpAlpha:GetValue())) end
        end

        if i then 
            AddMat(s,i)
        end
        if self.isBig == true  then 
            draw.SimpleText(t, "HexSh.X", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end

function PANEL:AddSubMenu(ix,t,i,f)
    local btn = vgui.Create("DButton",self.Scroll)
    btn:Dock(TOP)
    btn:SetTall(40)
    btn:SetText("")
    btn.DoClick = function()
        self.Scroll:GetCanvas():AlphaTo(0,0.15,0, function()
            self.Scroll:Clear()
            self:AddBackButton()
            for k,v in pairs(HexSh.adminUI.Items.S[ix].Btns) do 
                self:AddButton(v.title,v.icon,v.f)
            end
            self.Scroll:GetCanvas():AlphaTo(255,0.15,0)
        end)
    end
    addAnim(btn)
    btn.Paint = function(s,w,h)
        if s.LerpAlpha then s.LerpAlpha:DoLerp() end 

        if (s.LerpAlpha:GetValue() > 0) then 
            draw.RoundedBoxEx(7.5,0,0,w,h,getAlpha(bgButton,s.LerpAlpha:GetValue()),true,true,true,true)
            local hh = toDecimal(40)*btn:GetTall()
            local y = (toDecimal(65)*btn:GetTall())-hh
            if self.isBig then draw.RoundedBox(100,0,y,6,hh,getAlpha(HexSh.adminUI.Color.purple,s.LerpAlpha:GetValue())) end
        end

        if i then
            AddMat(s,i)
        end
        if self.isBig == true  then 
            draw.SimpleText(t, "HexSh.X", toDecimal(20)*btn:GetWide()+25, h/2-2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(">", "HexSh.X", toDecimal(90)*btn:GetWide(), h/2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end
 

vgui.Register("HexSh.adminUI.BSelect", PANEL, "DPanel")