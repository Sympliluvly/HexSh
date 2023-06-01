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
    HexSh.adminUI:AddNMenu("modules", HexSh:L("src_sh", "Modules"), HexSh:getImgurImage("RzhmHQH"), function(parent)

        parent.PaintOver = function(s,w,h)
            draw.SimpleText(HexSh:L("src_sh", "Modules"), "HexSh.EditLayerTitle", w/2, 20, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)        
        end

        local scroll = vgui.Create("DScrollPanel", parent)
        scroll:Dock(FILL)
        scroll:DockMargin(0,toDecimal(10)*parent:GetTall(),2,10)
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
            frame:DockMargin(4.5,4.5,4.5,4.5)
            frame:SetTall(50)
            frame.Paint = function(s,w,h)
                draw.RoundedBoxEx(7.5,0,0,w,h,HexSh.adminUI.Color.bgGray,true,true,true,true)
                draw.SimpleText(k,"HexSh.admin.FieldText", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end)

    HexSh.adminUI:AddNMenu("baseconfig", HexSh:L("src_sh", "BCfg"), HexSh:getImgurImage("G24BSo5"), function(parent)
        local field = function(title, tooltip)
            local p = vgui.Create("DPanel",parent)
            p:Dock(TOP)
            p:DockMargin(5,2,5,3)
            p:SetTall( toDecimal(9) * parent:GetTall() )
            p.Paint = function( self,w,h )
                draw.RoundedBoxEx(7.5,0,0,w,h,HexSh.adminUI.Color.bgGray,true,true,true,true)
            end

            local t = vgui.Create("DLabel",p)
            t:SetText(title)
            t:SetTooltip("")
            t:SetFont("DermaLarge")
            t:SetTextColor( white )
            t:Dock(LEFT)
            t:DockMargin(5,0,0,0)
            t:SizeToContents()

            return p 
        end
        local write = function()
            net.Start("HexSH::WriteConfig")
              HexSh:WriteCompressedTable(HexSh.Config.IConfig)
            net.SendToServer()
        end
        local cfg = HexSh.Config.IConfig["src_sh"]


        local ChangeLang = field(HexSh:L("src_sh","changeLang"),"")
        ChangeLang.Change = vgui.Create("HexSh.UI.DropDown",ChangeLang)
        ChangeLang.Change:Dock(RIGHT)
        ChangeLang.Change:DockMargin(0,5,5,5)
        ChangeLang.Change:SetValue(HexSh.Config.IConfig["src_sh"].Language)
        ChangeLang.Change:SetFont("DermaLarge")
        ChangeLang.Change:SetWide( toDecimal(40) * parent:GetWide() )
        for k,v in pairs(HexSh._Languages) do 
            ChangeLang.Change:AddChoice(k,k)
        end
        ChangeLang.Change.OnSelect = function(self, index, value)
            cfg.Language = value 
            write()
            hook.Run("HexSh::GetAdminItems")
            HexSh.ConfigMenu:Remove()
            net.Start("HexSh::OpenConfigMenu")
            net.SendToServer()
        end

    end)
end)



hook.Run("HexSh::GetAdminItems")
  
