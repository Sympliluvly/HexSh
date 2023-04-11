--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
// Here begins good code!
net.Receive("HexSh::LoadConfig", function()
    HexSh.Config.IConfig = HexSh:ReadCompressedTable()
end)
hook.Add("InitPostEntity", "HEXMENXLoadcfg", function()
    net.Start("HexSh::LoadConfig")
    net.SendToServer()
end)
net.Start("HexSh::LoadConfig")
net.SendToServer()




local toDecimal = function( x ) return ( ( x <= 100 ) && x || 100 ) * 0.01 end;
// here ends good code :&
// NOTE: THATS ONLY IMPORVED CODE FROM THE OLD BASE!! bc ui is boring

surface.CreateFont( "HexSh.UI.Title", {
    font = "Arial",
    extended = false,
    size = ScrH() * 0.040,
    weight = 1000,
    blursize = 0,
    scanlines = 0,
    antialias = true,
    underline = false,
    italic = false,
    strikeout = false,
    symbol = false,
    rotary = false,
    shadow = false,
    additive = false,
    outline = false,
} )

for i=1, 60 do    
    surface.CreateFont( "HexSh.UI."..tostring(i), {
        font = "Arial", 
        extended = false,
        size = ScrH() * 0.0 + i,
        weight = 1000,
        blursize = 0,
        scanlines = 0, 
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )
end

local BaseGray = Color(23,22,22,255)
local BaseGray2 = Color(37,37,37)
local BaselightGray = Color(46,46,46)
local purple = Color(118,48,158)
local black = Color(0,0,0,255)
local white = Color(255,255,255)

net.Receive("HexSh::OpenConfigMenu", function()
    local scrw,scrh = ScrW(), ScrH()
    if HexSh.Config.Ranks[ LocalPlayer():GetUserGroup()] then
        if IsValid(HexSh.UI.MainPanel) then 
            HexSh.UI.MainPanel:Remove() 
        else
            HexSh.UI.MainPanel = vgui.Create("HexSh.UI.BPanel")
            HexSh.UI.MainPanel:SetSize(toDecimal(60)*scrw,toDecimal(70)*scrh)
            HexSh.UI.MainPanel:Center()
            HexSh.UI.MainPanel:MakePopup()
            HexSh.UI.MainPanel:SetAlpha( 0 )
            HexSh.UI.MainPanel:AlphaTo( 255, 0.25, 0 )
            HexSh.UI.MainPanel.Paint = function(self,w,h)
                draw.RoundedBox(15,0,0,w,h,black)
            end

            local Sselect = vgui.Create("HexSh.UI.Select", HexSh.UI.MainPanel)
            Sselect:Dock(FILL)

            Top = vgui.Create("DPanel", HexSh.UI.MainPanel)
            Top:Dock(TOP)
            Top:SetTall(scrh*0.08)
            Top.Paint = function(self,w,h)
                draw.RoundedBoxEx(10,0,0,w,h,black,true,true,false,false)
                draw.RoundedBoxEx(0,0,scrh*0.077,w,3,white,false,false,false,false)
                draw.SimpleText("Hexagon Cryptic Studios", "HexSh.UI.Title", 100 , self:GetTall()/2 - 4, Color(133,88,163), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                surface.SetDrawColor(white)
                surface.SetMaterial(HexSh:getImgurImage( "BmestJw" ))
                surface.DrawTexturedRect(0,1,100,h/2 + 35)
            end
            local close = Top:Add("DButton")
            close:Dock(RIGHT)
            close:DockMargin(0,23,10,23)
            close:SetWide(scrw*0.019) 
            close:SetText("")
            close.DoClick = function()
                HexSh.UI.MainPanel:AlphaTo( 0,0.25, 0, function()  HexSh.UI.MainPanel:Remove() end )
            end
            close.Paint = function(self,w,h)
                draw.RoundedBoxEx(10,0,0,w,h,Color(250,0,0),true,true,true,true)
            end
            local PANEL = vgui.Create( "DPanel", Sselect )
            PANEL:Dock( FILL )
            PANEL.Paint = nil 
            Sselect:AddSheet( "HOME", PANEL, Color(255,0,0) )
        
            local ModulePanel = PANEL:Add("DPanel")
            ModulePanel:Dock(TOP)
            ModulePanel:DockMargin(0,0,0,40)
            ModulePanel:SetTall(scrh*0.7)
            ModulePanel.Paint = function(self,w,h)
            --   draw.RoundedBoxEx(10,0,0,w,h,HCS.UI.Black,true,true,true,true)
            --   surface.SetDrawColor(HCS.UI.White)
            --   surface.DrawOutlinedRect(0,scrh*0.05,w,scrh*0.4,2)
            --  draw.RoundedBoxEx(10,2,2,w-4,h-4,HCS.UI.BaselightGray,true,true,true,true)
            end
        
            local ModuleScroll = ModulePanel:Add("DScrollPanel")
            ModuleScroll:Dock(FILL)
            local sbar = ModuleScroll:GetVBar()
            sbar:SetSize(5,0)
            sbar:SetHideButtons( true )
            function sbar.btnGrip:Paint(w, h) draw.RoundedBoxEx(14,0,0,w,h,purple,false,false,false,false) end
            function sbar:Paint(w, h) draw.RoundedBoxEx(14,0,0,w,h,Color(46,46,46),false,false,false,false) end
            function sbar.btnUp:Paint(w, h) return end
            function sbar.btnDown:Paint(w, h) return end
            
            local ModuleTop = ModulePanel:Add("DPanel")
            ModuleTop:Dock(TOP)
            ModuleTop:SetTall(scrh*0.05)
            ModuleTop.Paint = function(self,w,h)
                --  draw.RoundedBoxEx(10,0,0,w,h,HCS.UI.BaseGray2,true,true,false,false)
                draw.SimpleText("Retrieve Srcs", "HexSh.UI.35", 5, self:GetTall()/2, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                draw.RoundedBox(0,5,scrh*0.04,w-5,2.5,white)
            end

            for k,v in pairs(HexSh.Srcs) do   
                local Df = ModuleScroll:Add("DButton")
                Df:Dock(TOP)
                Df:SetText("")
                Df:DockMargin(10,5,10,5)
                Df:SetTall(scrh*0.1)
                Df.Paint = function(self,w,h)
                    local clr = Color(16,16,16)
                    if self:IsHovered() then clr = Color(118,48,158) else  clr = Color(16,16,16) end
                    draw.RoundedBox(5,0,0,w,h,clr)
                    draw.RoundedBox(5,2,2,w-4,h-4,Color(16,16,16))
                    draw.SimpleText(k, "HexSh.UI.Title", 20, self:GetTall()/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
            end

            local PANEL = vgui.Create( "DPanel", Sselect )
            PANEL:Dock( FILL )
            PANEL.Paint = nil  
            Sselect:AddSheet( "Config", PANEL, Color(0,255,34) )
        
            local CSelect = vgui.Create("HexSh.UI.ConfigSelect", PANEL)
            CSelect:Dock(FILL)
        
        
            for k,v in pairs(HexSh.UI.Configs) do
                local sheet = vgui.Create( "DPanel", CSelect )
                sheet:Dock( FILL )
                sheet.Paint = nil 
                CSelect:AddSheet( v.name, sheet, v.color )
                v.vguif(sheet)
            end
        end
    else
        return
        chat.AddText(Color(225,0,255), "[HexSh.UIBase] ", Color(255,255,255), "you dont have access")
   end
    














   --[[ for k,v in pairs(HexSh.UI.Configs) do 
        
        local pnl = vgui.Create( "EditablePanel", sheet )
        pnl:Dock( FILL )
        pnl.Paint = function( self, w,  h ) 
            draw.RoundedBox( 4, 0, 0, w, h, Color(26,95,197)  ) 
            draw.SimpleText(v.name, "DermaLarge", 12, 16, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end 
        sheet:AddSheet( v.name, pnl, nil )

        v.vguif(pnl)
    
    end]]
end)

list.Set( "DesktopWindows", "HexConfig", {
    
	icon = "data/hexsh/cache/img/BmestJw.png",
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