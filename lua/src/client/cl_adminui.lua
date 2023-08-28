--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
HexSh.adminUI = HexSh.adminUI || {}

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

function HexSh.adminUI:AddNMenu(idx, title, icon, f )
    HexSh.adminUI.Items[idx] = {
        title = title,
        icon = icon,
        f = f
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
hook.Add("HexSh::GetAdminItems", "", function()
    local l = function(p) return HexSh:L("src_sh", p) end 
    -- For Config
    
    HexSh.adminUI:AddSubMenu("cfg", HexSh:L("src_sh", "Cfg"), HexSh:getImgurImage("uLS7i9M") )

    -- For Adminw
    HexSh.adminUI:AddSubMenu("admin", HexSh:L("src_sh", "Admin"), HexSh:getImgurImage("mqCcBCZ") )

    --Repos
    surface.CreateFont( "HexSh.EditLayerTitle", {
        font = "Montserrat", 
        extended = false,
        size = 50,
        weight = 1000,
    } )

    HexSh.adminUI:AddNMenu("logs", HexSh:L("src_sh", "logs"), HexSh:getImgurImage("EkzBK5Z"), function(parent)
    end)
    
    HexSh.adminUI:AddNMenu("modules", HexSh:L("src_sh", "Modules"), HexSh:getImgurImage("RzhmHQH"), function(parent)

        parent.PaintOver = function(s,w,h)
            draw.SimpleText(HexSh:L("src_sh", "Modules"), "HexSh.EditLayerTitle", w/2, 20, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)        
        end

        local scroll = vgui.Create("DScrollPanel", parent)
        scroll:Dock(FILL)
        scroll:DockMargin(0,50,2,10)
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
                draw.SimpleText(string.upper(string.Split(k,"src_")[2]),"HexSh.X", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end)

    HexSh.adminUI:AddNMenu("baseconfig", HexSh:L("src_sh", "BCfg"), HexSh:getImgurImage("G24BSo5"), function(parent)
        local scroll = vgui.Create("DScrollPanel", parent)
        scroll:Dock(FILL)
        scroll:DockMargin(0,5,2,10)
        local ScrollBar = scroll:GetVBar();

        ScrollBar:SetHideButtons( true );
        ScrollBar:SetSize(2,0)
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

        local field = function(title)
            local p = vgui.Create("DPanel",scroll)
            p:Dock(TOP)
            p:DockMargin(5,2,5,3)
            p:SetTall( 50 )
            p.Paint = function( self,w,h )
                draw.RoundedBoxEx(7.5,0,0,w,h,HexSh.adminUI.Color.bgGray,true,true,true,true)
                draw.SimpleText(title, "HexSh.X", 5, h/2, white, TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER )
            end

            return p 
        end

        local write = function()
            net.Start("HexSH::WriteConfig")
              HexSh:WriteCompressedTable(HexSh.Config.IConfig)
            net.SendToServer()
        end

        local cfg = HexSh.Config.IConfig["src_sh"]

        local ChangeLang = field(HexSh:L("src_sh","changeLang"))
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
                cfg.Language = value 
                write()
                hook.Run("HexSh::GetAdminItems")
                HexSh.adminUI.MainMenu:Remove()
                net.Start("HexSh::OpenConfigMenu")
                net.SendToServer()
            end
        -->


        local Ranks = field("")
            Ranks:SetTall(400)

            local li = vgui.Create("HexSh.UI.List", Ranks)
            li:Dock(RIGHT)
            li:DockMargin(3,3,7,3)
            li:AddColumn(HexSh:L("src_sh","Ranks"),1)

            local function GetRanks(tb) 
                for k,v in pairs(tb) do
                    local a = li:AddLine( k )
                    a.title = k
                end 
            end 
            GetRanks(cfg.Ranks) 
            
            local lilo 
            li.OnRowSelected = function( panel, rowIndex, row )
                lilo = row.title
            end

            local btnp = vgui.Create("DPanel",Ranks)
            btnp.Paint = nil

            btnp.add = vgui.Create("HexSh.UI.Button", btnp)
            btnp.add:Dock(TOP)
            btnp.add:SetTall(60)
            btnp.add:SetText(HexSh:L("src_sh", "AddRank"))
            btnp.add:SetFont("HexSh.X")
            btnp.add.DoClick = function()
                
                Derma_StringRequest(HexSh:L("src_sh", "AddRank"),"","...", function(txt)
                    local a = li:AddLine( txt )
                    a.title = txt

                    cfg.Ranks[txt] = true
                    write()
                end, nil)
            end

            btnp.delete = vgui.Create("HexSh.UI.Button", btnp)
            btnp.delete:Dock(TOP)
            btnp.delete:SetTall(60)
            btnp.delete:DockMargin(0,3,0,0)
            btnp.delete:SetText(HexSh:L("src_sh", "DeleteRank"))
            btnp.delete:SetFont("HexSh.X")
            btnp.delete:SetTooltip(HexSh:L("src_sh", "DeleteRankTootlip"))
            btnp.delete.DoClick = function()
                if (!lilo) then 
                    Derma_Message(HexSh:L("src_sh", "DeleteRankTootlip"),"","->")
                    return 
                end
                if (lilo=="superadmin") then 
                    Derma_Message(HexSh:L("src_sh", "trydeleteSuperadmin"),"","->")
                    return 
                end
                li:Clear()
                cfg.Ranks[lilo] = nil
                write()

                timer.Simple(0.1, function()
                    GetRanks(cfg.Ranks) 
                end)
            end
        -->

        net.Start("HexSh::SQLGET")
        net.SendToServer()
         
        local sqqql = false 
        net.Receive("HexSh::SQLGET", function()
            sqqql = true
            local access = net.ReadBool()
            if (!access) then 
                local MySQL = field(HexSh:L("src_sh", "notMYSQL"))
                MySQL:SetTall(100)
                return 
            end
            local mysql = net.ReadBool()
            local host = net.ReadString()
            local username = net.ReadString()
            local password = net.ReadString()
            local schema = net.ReadString()
            local port = net.ReadUInt(17)



            local MySQL = field(HexSh:L("src_sh", "MYSQL"))
            MySQL:SetTall(430)
            
            local utils = {}
            local function SetDisabledElements(bool)
                for k,v in pairs(utils) do 
                    v.entry:SetDisabled(bool)
                end
            end
            
            local enableMySQL = HexSh.adminUI.AddEditField(MySQL, HexSh:L("src_sh", "MYSQLEnabled"), "switch", mysql, "", false, true, function(s) 
                if (s:GetChecked()==false) then
                    SetDisabledElements(true)
                else
                    SetDisabledElements(false)
                end
            
            end)
            enableMySQL:DockMargin(0,40,0,0)


            local Ip = HexSh.adminUI.AddEditField(MySQL, HexSh:L("src_sh", "MYSQLIP"), "text", host,  HexSh:L("src_sh", "MYSQLIPTool"), true, true, function(s, var, val)  end)
            local Username = HexSh.adminUI.AddEditField(MySQL, HexSh:L("src_sh", "MYSQLDBUser"), "text", username,  HexSh:L("src_sh", "MYSQLDBUserTool"), false, true, function(s, var, val)  end)
            local Password = HexSh.adminUI.AddEditField(MySQL, HexSh:L("src_sh", "MYSQLDBPassword"), "text", password,  HexSh:L("src_sh", "MYSQLDBPasswordTool"), false, true, function(s, var, val)  end)
            local DBName = HexSh.adminUI.AddEditField(MySQL, HexSh:L("src_sh", "MYSQLDatabase"), "text", schema,  HexSh:L("src_sh", "MYSQLDatabaseTool"), false, true, function(s, var, val)  end)
            local Port = HexSh.adminUI.AddEditField(MySQL, HexSh:L("src_sh", "MYSQLPort"), "text", port, HexSh:L("src_sh", "MYSQLPortTool"), true, true, function(s, var, val)  end)
            local Save = vgui.Create("HexSh.UI.Button", MySQL)
                Save:Dock(TOP)
                Save:SetTall(30)
                Save:DockMargin(5,5,5,5)
                Save:SetText(HexSh:L("src_sh", "Save"))
                Save:SetFont("HexSh.X")
                Save.DoClick = function( s )
                    net.Start("HexsSh::SQLWRITE")
                        net.WriteBool(enableMySQL.switch:GetChecked())
                        net.WriteString(Ip.entry:GetValue())
                        net.WriteString(Username.entry:GetValue())
                        net.WriteString(Password.entry:GetValue())
                        net.WriteString(DBName.entry:GetValue())
                        net.WriteUInt(tonumber(Port.entry:GetValue()),17)
                    net.SendToServer()
                
                end

            table.insert(utils,Ip)
            table.insert(utils,Username)
            table.insert(utils,Password)
            table.insert(utils,DBName)
            table.insert(utils,Port)
        
            if (!mysql) then 
                SetDisabledElements(true)
            end 

        end)



        function HexSh.adminUI.MainMenu.Selection.EditLayer:PerformLayout(w,h)
            ChangeLang.Change:SetWide( w/2.3 )
            btnp:SetSize(w/3,200)
            btnp:SetPos(20, 50)
            li:SetWide(w/1.8)
            if (sqqql) then 


            end
        end
        
    end)

end)



hook.Run("HexSh::GetAdminItems")
  
