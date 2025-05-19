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

HexSh.adminUI = HexSh.adminUI || {}
include("src/sh_permissions.lua")
include("cl_imgurintegration.lua")
  
HexSh.adminUI.Color = {
    purple = Color(188,19,235),
    black = Color(0,0,0,255),
    white = Color(255,255,255),
    bgGray = Color(38,35,38),
    bgGray2 = Color(30,27,30),
    bgDarkGray = Color(33,31,31),
    bgLightGray = Color(49,47,50),
    bgButton = Color(45,45,45), -- buttonhovere
    bghovergray = Color(46,48,52,250),
}
HEXAGON.Col = HexSh.adminUI.Color
HexSh.Col = HexSh.adminUI.Color
HexSh.Assets = {
    logo = Material("hexsh/logo/hcstudio_large.png", "noclamp smooth"),
}


HexSh.adminUI.Items = {}
HexSh.adminUI.Items.S =  {}

-- For Bselect
function HexSh.adminUI:AddSubMenu(idx, title, icon )
    HexSh.adminUI.Items.S[idx] = {
        title = title,
        icon = icon,
        Btns = {},
    } 
end 

function HexSh.adminUI:AddMenu(idx, title, icon, f )
    HexSh.adminUI.Items.S[idx].Btns[title] = {
        title = title,
        icon = icon, 
        f = f
    }
end

function HexSh.adminUI:AddNMenu(idx, title, icon, f, order, check )
    HexSh.adminUI.Items[idx] = { 
        title = title,
        icon = icon,
        f = f,
        order = order
    }
end 
local toDecimal = function( x ) return ( ( x <= 100 ) && x || 100 ) * 0.01 end;
 --bg 
local white = Color(255,255,255)

function HexSh.adminUI.AddEditField(parent, title, element, var, tooltip, numeric, enabled, savefunction)
    local p = vgui.Create("DPanel",parent)
    p:Dock(TOP)
    p:DockMargin(5,2,5,3)
    p:SetTall( 50 )
    p.Paint = function( self,w,h )
        draw.RoundedBoxEx(7.5,0,0,w,h,HexSh.adminUI.Color.bgGray2,true,true,true,true)
    end

    p.t = vgui.Create("DLabel",p)
    p.t:SetText(title)
    p.t:SetFont("HexSh.X")
    p.t:SetTextColor( white )
    p.t:Dock(LEFT)
    p.t:DockMargin(5,0,0,0)
    p.t:SizeToContents()

    if ( element == "text" ) then 
        p.entry = vgui.Create("HexSh.UI.TextEntry",p)
        p.entry:Dock(RIGHT)
        p.entry:DockMargin(0,5,5,5)
        p.entry:SetText(var)
        p.entry.curVar = var
        p.entry:SetFont("HexSh.X")
        p.entry:SetTooltip(tooltip)
        p.entry:SetWide( 200 )
        if (enabled == false) then p.entry:SetDisabled(true) end
        p.entry:SetNumeric(numeric)

        p.entry.OnEnter = function( self )
            savefunction( self, var, self:GetValue() )
        end
    end
    if (element == "switch") then 
        p.switch = vgui.Create( "HexSh.Switch",p );
        p.switch:Dock( RIGHT );
        p.switch:DockMargin( 9, 15, 10, 0 );
        p.switch:SetText( "dd" );
        p.switch:SetWide( 40 )
        p.switch:SetTooltip(tooltip)
        p.switch:SetChecked( var );
        p.switch.OnChange = function(s)
            savefunction(s)
        end
    end


    return p
end
--hooks
 
local cfg_icon = "uLS7i9M" 
local admin_icon = "mqCcBCZ"
local logs_icon = "EkzBK5Z"
local modules_icon = "RzhmHQH"
local basecfg_icon = "G24BSo5"
local control_icon = "QkjOYTG"
local dasboard_icon = "IDIDFZq"

surface.CreateFont( "HexSh.EditLayerTitle", {
    font = "MuseoModerno Light", 
    extended = false,
    size = 50,
    weight = 1000, 
} )  


hook.Add("HexSh::GetAdminItems", "", function()
    local l = function(p) return HexSh:L("src_sh", p) end 
    -- For Config
    
    
    HexSh.adminUI:AddSubMenu("cfg", HexSh:L("src_sh", "Cfg"), cfg_icon )
   
    HexSh.adminUI:AddMenu("cfg", HexSh:L("src_sh", "BCfg"), basecfg_icon, function(parent)

        local topp = vgui.Create("DPanel",parent)
        topp:Dock(TOP)
        topp:SetTall(50)
        topp.Paint = function(s,w,h)
            draw.RoundedBox(0,0,0,w,40,HexSh.adminUI.Color.purple)
            surface.SetDrawColor(white)
            surface.SetMaterial(HexSh:getImgurImage(basecfg_icon))
            surface.DrawTexturedRect(5,5,32,32)

            draw.SimpleText(HexSh:L("src_sh", "BCfg"), "HexSh.EditLayerTitle", 45, 19, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)      
        end

        local columns = vgui.Create("HexSh.UI.Columnsheet",parent) 
        columns:Dock(FILL)
        columns:DockMargin(0,0,0,0)

        local setup = vgui.Create("HexSh.UI.Scroll", columns)
        setup:Dock(FILL)
        setup:DockMargin(0,0,0,0)
        setup.Paint = nil
        columns:AddButton( HexSh:L("src_sh", "setup.ColumnTitle"),setup,Color(250,0,0))
        
            
        local Pmysql = vgui.Create("HexSh.UI.Scroll", columns)
        Pmysql:Dock(FILL)
        Pmysql:DockMargin(0,0,0,0)
        Pmysql.Paint = nil
        columns:AddButton( HexSh:L("src_sh", "MYSQL.ColumnTitle"),Pmysql,Color(250,0,0))

        local field = function(pa,title)
            local p = vgui.Create("DPanel",pa)
            p:Dock(TOP)
            p:DockMargin(5,2,5,3)
            p:SetTall( 50 )
            p.Paint = function( self,w,h )
                draw.RoundedBoxEx(7.5,0,0,101,h,HexSh.adminUI.Color.purple,true,true,true,true)
                draw.RoundedBoxEx(7.5,5,0,w-5,h,HexSh.adminUI.Color.bgGray,true,true,true,true)
                draw.SimpleText(title, "HexSh.X", 15, h/2, white, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER )
            end

            return p 
        end

        local cfg = HexSh.Config.IConfig["src_sh"]

        local ChangeLang = field(setup,HexSh:L("src_sh","changeLang"))
            ChangeLang.Change = vgui.Create("HexSh.UI.DropDown",ChangeLang)
            ChangeLang.Change:Dock(RIGHT)
            ChangeLang.Change:DockMargin(0,5,5,5)
            ChangeLang.Change:SetValue(HexSh.Config.IConfig["src_sh"].Language)
            ChangeLang.Change:SetFont("HexSh.X") 
            ChangeLang.Change:SetWide( 150 )
            for k,v in pairs(HexSh._Languages) do 
                ChangeLang.Change:AddChoice(k,k)
            end
            ChangeLang.Change.OnSelect = function(self, index, value)
                HexSh.Set("src_sh","Language",value,"MenuAccess")
                hook.Run("HexSh::GetAdminItems")
                HexSh.adminUI.MainMenu:Remove()
                net.Start("HexSh::OpenConfigMenu")
                net.SendToServer()
            end
        -->

        local UseStatistic = field(setup,HexSh:L("src_sh","UseStatistic"))
            UseStatistic.Use = vgui.Create("HexSh.Switch",UseStatistic)
            UseStatistic.Use:Dock(RIGHT)
            UseStatistic.Use:DockMargin(0,15,5,5)
            UseStatistic.Use:SetChecked(HexSh.Config.IConfig["src_sh"].UseStatistics or false)
            UseStatistic.Use:SetText("")
        -->



        net.Start("HexSh::SQLGET")
        net.SendToServer()
            
        local sqqql = false 
        net.Receive("HexSh::SQLGET", function()
            sqqql = true
            local access = net.ReadBool()
            if (!access) then 
                local MySQL = field(Pmysql,HexSh:L("src_sh", "notMYSQL"))
                MySQL:SetTall(100)
                return 
            end
            local mysql = net.ReadBool()
            local host = net.ReadString()
            local username = net.ReadString()
            local password = net.ReadString()
            local schema = net.ReadString()
            local port = net.ReadUInt(17)


            local field = function(type,value,title,tooltip)
                local p = vgui.Create("DPanel",Pmysql)
                p:Dock(TOP)
                p:DockMargin(5,2,5,3)
                p:SetTall( 50 )
                p.Paint = function( self,w,h )
                    draw.RoundedBoxEx(7.5,0,0,101,h,HexSh.adminUI.Color.purple,true,true,true,true)
                    draw.RoundedBoxEx(7.5,5,0,w-5,h,HexSh.adminUI.Color.bgGray,true,true,true,true)
                    draw.SimpleText(title, "HexSh.ad", 10, h/2, white, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER )
                end

                local function entry(max,value)
                    p.entry = vgui.Create("HexSh.UI.TextEntry",p)
                    p.entry:Dock(RIGHT)
                    p.entry:DockMargin(0,5,5,5)
                    p.entry:SetPlaceholderText(title)
                    p.entry:SetFont("HexSh.X")
                    p.entry:SetWide( 200 )
                    p.entry:SetNumeric(false)
                    p.entry:SetValue(value)
                    if !max then else p.entry:SetMaxLetters(max) end

                    return p.entry
                end


                if (type=="IP") then -- text
                    entry(15,host).OnChange = function(s)
                        host = s:GetValue()
                    end
                end
                if (type=="Username") then -- text
                    entry(false,username).OnChange = function(s)
                        username = s:GetValue()
                    end
                end
                if (type=="Password") then -- text
                    entry(false,password).OnChange = function(s)
                        password = s:GetValue()
                    end
                    p.entry:SetPassword(true)
                end
                if (type=="DB") then -- text
                    entry(false,schema).OnChange = function(s)
                        schema = s:GetValue()
                    end
                end
                if (type=="Port") then -- text
                    entry(false,port).OnChange = function(s)
                        port = s:GetValue()
                    end
                end

                if (type=="enable") then 
                    p.switch = vgui.Create( "HexSh.Switch",p );
                    p.switch:Dock(RIGHT);
                    p.switch:DockMargin( 9, 15, 10, 0 );
                    p.switch:SetText( "dd" );
                    p.switch:SetWide( 40 )
                    p.switch:SetTooltip(tooltip)
                    p.switch:SetChecked( value );
                    p.switch.OnChange = function(s)
                        mysql = s:GetChecked()
                    end
                end


                return p 
            end



            local info = vgui.Create("DPanel",Pmysql)
            info:Dock(TOP)
            info:DockMargin(5,2,5,3)
            info:SetTall( 120 )
            function info:Paint(w,h)
                draw.RoundedBoxEx(7.5,0,0,w,h,HexSh.adminUI.Color.purple,true,true,true,true)
                draw.RoundedBoxEx(7.5,1,1,w-2,h-2,HexSh.adminUI.Color.bgGray,true,true,true,true)
            end

            local enable = field("enable",mysql,HexSh:L("src_sh", "MYSQLEnabled"))

            local Ip = field(
                "IP",
                host,
                HexSh:L("src_sh", "MYSQLIPs"),
                ""
            )
            local DBNames = field("DB",schema,HexSh:L("src_sh", "MYSQLDatabase"))
            local Username = field("Username",username,HexSh:L("src_sh", "MYSQLDBUser"))
            local Password = field("Password",password,HexSh:L("src_sh", "MYSQLDBPassword"))
            local Port = field("Port",port,HexSh:L("src_sh", "MYSQLPort"))


            local save = field(Pmysql,HexSh:L("src_sh", "Save"))
            save.button = vgui.Create("HexSh.UI.Button",save)
            save.button:Dock(RIGHT)
            save.button:DockMargin(0,5,5,5)
            save.button:SetText(HexSh:L("src_sh", "Save"))
            save.button:SetWide( 200 )
            save.button:SetRounding(6)
            function save.button:DoClick()
                net.Start("HexSh::SQLWRITE")
                    net.WriteBool(tobool(mysql))
                    net.WriteString(tostring(host))
                    net.WriteString(tostring(username))
                    net.WriteString(tostring(password))
                    net.WriteString(tostring(schema))
                    net.WriteUInt(tonumber(port),17)
                net.SendToServer()
            end
            
        end)
        


        function HexSh.adminUI.MainMenu.Selection.EditLayer:PerformLayout(w,h)
            --sChangeLang.Change:SetWide( w/2.3 )
            -- btnp:SetSize(w/3,200)
            --btnp:SetPos(20, 50)
            --  li:SetWide(w/1.8)
            if (sqqql) then 


            end
        end
        
    end,3)

    -- For Adminw
    HexSh.adminUI:AddSubMenu("admin", HexSh:L("src_sh", "Manage"), admin_icon )
    
    --Repos 

        HexSh.adminUI:AddNMenu("logs", HexSh:L("src_sh", "logs"),logs_icon, function(parent)
            net.Start("HexSh:ReadDebugLogs")
            net.SendToServer()

            net.Receive("HexSh:ReadDebugLogs",function()
                local debuglogs = HexSh:ReadCompressedTable()
                PrintTable(debuglogs)
                parent.PaintOver = function(s,w,h)
                    draw.SimpleText(HexSh:L("src_sh", "MODULES:Logging"), "HexSh.EditLayerTitle", w/2, 20, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)        
                end

                local printfield = vgui.Create("RichText",parent)
                for i=1, #debuglogs do 
                    local a = debuglogs[i]
                    printfield:InsertColorChange( 36,135,222, 255 )
                    printfield:AppendText(a.Date.." / " .. a.Time .. " | ")

                    printfield:InsertColorChange( 188,19,235,255 )
                    printfield:AppendText(a.src.." ~ ")

                    printfield:InsertColorChange( 255, 255, 255, 255 )
                    printfield:AppendText(a.message.."\n") 
                end


                function HexSh.adminUI.MainMenu.Selection.EditLayer:PerformLayout(w,h)  
                    printfield:SetPos(10,50)
                    printfield:SetSize(w-10,h-50)
                end
            end)
        end,5)

        HexSh.adminUI:AddNMenu("dashboard", HexSh:L("src_sh", "dashboard"), dasboard_icon, function(parent)
        end,1)

        HexSh.adminUI:AddNMenu("modules", HexSh:L("src_sh", "Modules"), modules_icon, function(parent)
            local topp = vgui.Create("DPanel",parent)
            topp:Dock(TOP)
            topp:SetTall(50)
            topp.Paint = function(s,w,h)
                draw.RoundedBox(0,0,0,w,40,HexSh.adminUI.Color.purple)
                surface.SetDrawColor(white)
                surface.SetMaterial(HexSh:getImgurImage(modules_icon))
                surface.DrawTexturedRect(5,5,32,32)

                draw.SimpleText(HexSh:L("src_sh", "Modules"), "HexSh.EditLayerTitle", 45, 19, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)      
            end

            local scroll = vgui.Create("DScrollPanel", parent)
            scroll:Dock(FILL)
            scroll:DockMargin(0,0,2,10)
            local ScrollBar = scroll:GetVBar();
    
            ScrollBar:SetHideButtons( true );
            ScrollBar:SetSize(10,0)
            function ScrollBar.btnGrip:Paint( w, h )  
                draw.RoundedBox( 0, 0, 0, w, h, HexSh.adminUI.Color.purple ); 
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
    
            for k,v in pairs(HexSh.Srcs) do 
                local frame = vgui.Create("DPanel",scroll)
                frame:Dock(TOP)
                frame:DockMargin(7.5,4.5,7.5,4.5)
                frame:SetTall(35)
                frame.Paint = function(s,w,h)
                    draw.RoundedBoxEx(7.5,0,5,w,h-5,HexSh.adminUI.Color.purple,true,true,true,true)
                    draw.RoundedBoxEx(7.5,0,0,w,h-2,HexSh.adminUI.Color.bgGray,true,true,true,true)
                    
                    if HexSh.SrcDetails[k] then  
                        draw.SimpleText(HexSh.SrcDetails[k].Name,"HexSh.X", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    else
                        draw.SimpleText(string.upper(string.Split(k,"src_")[2]),"HexSh.X", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                
                end
            end
        end,4)


    
end)


 
hook.Run("HexSh::GetAdminItems")  
  
