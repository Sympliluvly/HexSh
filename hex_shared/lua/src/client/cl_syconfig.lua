--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
HexSh.UI =  HexSh.UI or {}
HexSh.UI.Configs = HexSh.UI.Configs or {}

net.Receive("HexSh::LoadConfig", function()
    HexSh.Config = HexSh:ReadCompressedTable()
end)

local toDecimal = function( x ) return ( ( x <= 100 ) && x || 100 ) * 0.01 end;
local black = Color(0,0,0,255)
net.Receive("HexSh::OpenConfigMenu", function()
    HexSh.UI.HexShCfgMenu = vgui.Create("DFrame")
    HexSh.UI.HexShCfgMenu:SetSize(toDecimal(59) * ScrW(), toDecimal(60) * ScrH())
    HexSh.UI.HexShCfgMenu:Center()
    HexSh.UI.HexShCfgMenu:SetTitle("HexSH ~Config")
    HexSh.UI.HexShCfgMenu:MakePopup()


    local sheet = vgui.Create( "DColumnSheet", HexSh.UI.HexShCfgMenu )
    sheet:Dock( FILL )
    
    for k,v in pairs(HexSh.UI.Configs) do 
        
        local pnl = vgui.Create( "DPanel", sheet )
        pnl:Dock( FILL )
        pnl.Paint = function( self, w,  h ) 
            draw.RoundedBox( 4, 0, 0, w, h, v.color ) 
            draw.SimpleText(v.name, "DermaLarge", 12, 16, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
        sheet:AddSheet( v.name, pnl, nil )


    end

end)

hook.Add("OnContextMenuClose", "HexSh::OnlyContexConfigOpen", function()
    if (IsValid(HexSh.UI.HexShCfgMenu)) then 
        HexSh.UI.HexShCfgMenu:SetVisible(false)
    end
end)
hook.Add("OnContextMenuOpen", "HexSh::OnlyContexConfigClose", function()
    if (IsValid(HexSh.UI.HexShCfgMenu)) then 
        HexSh.UI.HexShCfgMenu:SetVisible(true)
    end
end)

list.Set( "DesktopWindows", "HexConfig", {

	icon = "icon16/user_gray.png",
	title = "HexConfig",
	width = 100,
	height = 100,
	onewindow = true,
	init = function( icon, window )
		window:Close()

        net.Start("HexSh::OpenConfigMenu")
        net.SendToServer()
	end

	}
)


function HexSh:registerConfig( name, icon, color, vguif )
    HexSh.UI.Configs[name] = {}
    HexSh.UI.Configs[name].name = name 
    HexSh.UI.Configs[name].color = color || Color(26,95,197) 
    HexSh.UI.Configs[name].vgui = vguif
end

//HexSh:registerConfig( "Communications", nil, nil, function( parent )
    
//end)