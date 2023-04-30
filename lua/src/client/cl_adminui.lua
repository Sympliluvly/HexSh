--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
HexSh.adminUI = HexSh.adminUI || {}

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
    HexSh.adminUI.Items.S[idx].Btns = {
        [title] = {
            title = title,
            icon = icon,
            f = f
        }
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
local bgGray = Color(38,35,38) --bg
local white = Color(255,255,255)
local purple = Color(188,19,235)


hook.Add("HexChars.admin.GetItems","",function()
    -- For Config
    HexSh.adminUI:AddSubMenu("cfg", HexSh:L("src_sh", "Cfg"), HexSh:getImgurImage("uLS7i9M") )
    HexSh.adminUI:AddMenu("cfg", "testest", HexSh:getImgurImage("uLS7i9M"), function()
        
    end )

    -- For Admin
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
            draw.RoundedBox( 0, 0, 0, w, h, purple ); 
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
                draw.RoundedBoxEx(7.5,0,0,w,h,bgGray,true,true,true,true)
                draw.SimpleText(k,"HexSh.admin.FieldText", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end)
end)

--hooks
hook.Add("InitPostEntity","HexChars.admin::LoadItems", function()
    hook.Run("HexChars.admin.GetItems")
end)   
