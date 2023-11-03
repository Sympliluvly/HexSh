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
local toDecimal = function( x ) return ( ( x <= 100 ) && x || 100 ) * 0.01 end;
local getAlpha = function(col, a)
    return Color(col["r"], col["g"], col["b"], a)
end

  
hook.Add("OnContextMenuOpen", "HexShareds::ContextMenuModeOpen", function()
    if (HC_Mode == "context" && IsValid(HexSh.adminUI.MainMenu)) then 
        HexSh.adminUI.MainMenu:SetVisible(true)
    end
end)


hook.Add("OnContextMenuClose", "HexShareds::ContextMenuModeClose", function()
    if (HC_Mode == "context" && IsValid(HexSh.adminUI.MainMenu)) then 
        HexSh.adminUI.MainMenu:SetVisible(false)
    end
end)


net.Receive("HexSh::OpenConfigMenu", function()
    local mode = net.ReadString()
    local scrw,scrh = ScrW(), ScrH()

    HC_Mode = mode  

    --[[if (!LocalPlayer().HCS_AdminMenuconfig) then 
        hook.Run("HexSh::GetAdminItems")
        
        LocalPlayer().HCS_AdminMenuconfig = true
    end]]


    if HexSh.adminUI.Minimized then 
        HexSh.adminUI.MainMenu:SetVisible(true)
        HexSh.adminUI.Minimized = false
        return
    end

    HexSh.adminUI.Minimized = false
    local Frame = vgui.Create("DFrame")
        Frame:SetSize(620,390)
        Frame:SetMinHeight(390)
        Frame:SetMinWidth(620)
        Frame:Center()
        Frame:MakePopup()
        Frame:SetDraggable(true)
        Frame:SetSizable(true)
        Frame:ShowCloseButton(false)
        Frame:SetTitle("")
        function Frame:Paint(w,h)
            draw.RoundedBox(16,0,0,w,h,bgDarkGray)
            
            surface.SetDrawColor(white)
            surface.SetMaterial(HexSh:getImgurImage("BmestJw"))
            surface.DrawTexturedRect(0,0,36,30)

            draw.SimpleText("Hexagon Cryptics", "HexSh.X", 36, 30 / 2 - 10, white )
        end
    -->
    local Selection = vgui.Create("HexSh.adminUI.BSelect",Frame)
    Selection:SetPos(0,50)

    local Close = vgui.Create("DButton",Frame)
        Close:SetSize(36,30)
        Close:SetText("X")
        Close:SetTextColor(white)
        Close.Lerp = HexSh:Lerp(0,0,0.3)
        function Close:DoClick()
            Frame:Remove()
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
    local Minim = vgui.Create("DButton",Frame)
        Minim:SetSize(36,30)
        Minim:SetText("-")
        Minim:SetTextColor(white)
        Minim:SetTooltip(HexSh:L("src_datapad", "Minim_ToolTip"))
        Minim.Lerp = HexSh:Lerp(0,0,0.3)
        function Minim:DoClick()
            HexSh.adminUI.Minimized = true
            Frame:SetVisible(false)
        end
        function Minim:OnCursorEntered()
            self.Lerp = HexSh:Lerp(0,255,0.3)
            self.Lerp:DoLerp()
        end
        function Minim:OnCursorExited()
            self.Lerp = HexSh:Lerp(255,0,0.3)
            self.Lerp:DoLerp()
        end
        function Minim:Paint(w,h)
            if (self.Lerp) then self.Lerp:DoLerp() end
            if (self.Lerp:GetValue() > 1) then      
                draw.RoundedBoxEx(16,0,0,w,h,getAlpha(bghovergray,self.Lerp:GetValue()),false,false,false,false)
            end
        end
    -->

    function Frame:PerformLayout(w,h)
        Close:SetPos(self:GetWide() - Close:GetWide(), 0 )
        Minim:SetPos(self:GetWide() - Close:GetWide() - Minim:GetWide(), 0)
        if Selection.isBig then 
            Selection:SetSize(190, self:GetTall())
        else
            Selection:SetSize(29, self:GetTall())
        end

        Selection.EditLayer:SetSize(self:GetWide() - Selection:GetWide() -  25, self:GetTall() - 50)
        Selection.EditLayer:SetPos(Selection:GetWide() + 10, 45)
    end

    Frame.Selection = Selection
    -->

    --[[local Minimum = vgui.Create("DButton",Frame)
        Minimum:SetSize(36,30)
        Minimum:SetText("X")
        function Minimum:DoClick()
        end
        function Minimum:Paint(w,h)
            self:SetPos(Frame:GetWide() - self:GetWide() - Close:GetWide(), 0 )         
            draw.RoundedBox(0,0,0,w,h,white)
        end
    -->]]

    HexSh.adminUI.MainMenu = Frame 
    HexSh.adminUI.Selection = Selection
end)

list.Set( "DesktopWindows", "HexConfig", {
	icon = "data/hexsh/cache/img/BmestJw.png",
	title = "HexConfig",
	width = 100,
	height = 100,
	onewindow = false,
	init = function( icon, window )
		window:Close()

        net.Start("HexSh::OpenConfigMenu")
            net.WriteString("context")
        net.SendToServer()
	end

	}
) 

concommand.Add("kdke,", function()
    net.Start("HexArmory::RequestItems")
        net.WriteUInt(0,64)
    net.SendToServer()
end)