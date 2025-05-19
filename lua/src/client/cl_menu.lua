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
local bgDarkGray = Color(33,31,31)
local bgLightGray = Color(49,47,50)
local bghovergray = Color(46,48,52,250)
local green = Color(19,102,13) -- buttonhovere
local toDecimal = function( x ) return ( ( x <= 100 ) && x || 100 ) * 0.01 end;
local getAlpha = function(col, a)
    return Color(col["r"], col["g"], col["b"], a)
end

surface.CreateFont("HexSh.ad", {
    font = "MuseoModerno Light",
    size = 20,
    weight = 500,
    antialias = true,
    shadow = false
})




--[[
    # Open Adminmenu 
]]
HexSh.openedMenuVariable = nil 
function HexSh.openAdminmenu(window)
    local scrw,scrh = ScrW(), ScrH()

    Frame = window
        function Frame:Paint(w,h)
            draw.RoundedBox(16,0,0,w,h,bgDarkGray)
            
            surface.SetDrawColor(white)
            surface.SetMaterial(HexSh.Assets.logo)
            surface.DrawTexturedRect(0,0,46,46) 

            draw.SimpleText("HC Studio - " .. HexSh.Version, "HexSh.X", w * 0.038, h*0.015, white )
        end
        local cache_plyrank = LocalPlayer():GetUserGroup()

        function Frame:Think()
            if (cache_plyrank != LocalPlayer():GetUserGroup()) then 
                self:Remove()
                HexSh.openedMenuVariable = nil
            end
        end
    -->

    local Close = vgui.Create("DButton",Frame)
        Close:SetSize(36,30)
        Close:SetText("X")
        Close:SetTextColor(white)
        Close.Lerp = HexSh:Lerp(0,0,0.3)
        function Close:DoClick()
            Frame:Remove()
            HexSh.openedMenuVariable = nil
            surface.PlaySound("data/hdm.wav")
        end
        function Close:OnCursorEntered()
            self.Lerp = HexSh:Lerp(0,255,0.3)
            self.Lerp:DoLerp()
        end
        function Close:OnCursorExited()
            self.Lerp = HexSh:Lerp(255,0,0.3)
            self.Lerp:DoLerp()
        end
        function Close:Paint(w,h)
            if (self.Lerp) then self.Lerp:DoLerp() end
            if (self.Lerp:GetValue() > 1) then      
                draw.RoundedBoxEx(16,0,0,w,h,getAlpha(bghovergray,self.Lerp:GetValue()),false,true,false,false)
            end
        end
    -->


    hook.Run("HexSh::GetAdminItems")


    local Selection = vgui.Create("HexSh.adminUI.BSelect",Frame)
    Selection:SetPos(0,50)

    function Frame:PerformLayout(w,h)
        Close:SetPos(self:GetWide() - Close:GetWide(), 0 )

        if Selection && Selection.isBig then 
            Selection:SetSize(190, self:GetTall())
        else
            Selection:SetSize(29, self:GetTall())
        end

        Selection.EditLayer:SetSize(self:GetWide() - Selection:GetWide() -  25, self:GetTall() - 55)
        Selection.EditLayer:SetPos(Selection:GetWide() + 10, 45)

    end
    Frame.Selection = Selection
    -->

    HexSh.adminUI.MainMenu = Frame 
    HexSh.adminUI.Selection = Selection


    return Frame
end



list.Set( "DesktopWindows", "HexConfig", {
	icon = "hexsh/logo/hcstudio.png",
	title = "HexSh Base",
	width = 100,
	height = 100,
	onewindow = true,
	init = function( icon, window )
        window:SetSize(ScrW()*0.6, ScrH()*0.8)
        window:Center()
        window:ShowCloseButton(false)
        window:SetTitle("")
		HexSh.openAdminmenu(window)
	end

	}
) 