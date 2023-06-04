
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


net.Receive("HexSh::OpenConfigMenu", function()
    local scrw,scrh = ScrW(), ScrH()

    if (!LocalPlayer().HCS_AdminMenuconfig) then 
        hook.Run("HexSh::GetAdminItems")
        
        LocalPlayer().HCS_AdminMenuconfig = true
    end
    

    local frame = vgui.Create("EditablePanel")
    frame:SetSize(toDecimal(40) * ScrW(), toDecimal(60) * ScrH())
    frame:Center()
    frame:MakePopup()
    frame:SetAlpha(0)
    frame:AlphaTo(255,0.14,0,nil)
    HexSh.ConfigMenu = frame 

    -- Header
    frame.Rotate = false 
    frame.Paint = function(s,w,h)
        draw.RoundedBox(15,0,0,w,h,HexSh.adminUI.Color.bgGray)

        surface.SetDrawColor(white)
        surface.SetMaterial(HexSh:getImgurImage("BmestJw"))
        surface.DrawTexturedRectRotated( toDecimal(3.3) * frame:GetWide(),toDecimal(3.7) * frame:GetTall(),toDecimal(7) * frame:GetWide(), toDecimal(7) * frame:GetTall(), s.Rotate && CurTime() * 200 % 360 || 0  )

        draw.SimpleText("H", "HexSh.Title", toDecimal(5.9) * frame:GetWide(),toDecimal(3) * frame:GetTall(),HexSh.adminUI.Color.purple,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText("exagon", "HexSh.TitleSmall", toDecimal(9.4) * frame:GetWide(),toDecimal(3) * frame:GetTall(),white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText("C", "HexSh.Title", toDecimal(24.5) * frame:GetWide(),toDecimal(3) * frame:GetTall(),HexSh.adminUI.Color.purple,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        draw.SimpleText("ryptics", "HexSh.TitleSmall", toDecimal(27.8) * frame:GetWide(),toDecimal(3) * frame:GetTall(),white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

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
    
    frame.Close = vgui.Create("DButton",frame)
    frame.Close:SetSize( toDecimal(5) * frame:GetWide(), toDecimal(7) * frame:GetTall() )
    frame.Close:SetPos((toDecimal(100) *frame:GetWide()) - frame.Close:GetWide(), (toDecimal(7) * frame:GetTall()) - frame.Close:GetTall() )
    frame.Close:SetText("")
    frame.Close.DoClick = function()
        frame:AlphaTo(0,0.14,0,function()
            frame:Remove()
        end)
    end
    addAnim(frame.Close)
    frame.Close.Paint = function(s,w,h)
        if s.LerpAlpha then s.LerpAlpha:DoLerp() end 

        if (s.LerpAlpha:GetValue() > 0) then 
            draw.RoundedBoxEx(15,0,0,w,h,getAlpha(bgLightGray,s.LerpAlpha:GetValue()),false,true,false,false)
        end
        draw.SimpleText("X", "HexSh.X", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    
    frame.Minimize = vgui.Create("DButton",frame)
    frame.Minimize:SetSize( toDecimal(5) * frame:GetWide(), toDecimal(7) * frame:GetTall() )
    frame.Minimize:SetPos((toDecimal(95.2) *frame:GetWide()) - frame.Minimize:GetWide(), (toDecimal(7) * frame:GetTall()) - frame.Minimize:GetTall() )
    frame.Minimize:SetText("")
    frame.Minimize.DoClick = function()
        frame:AlphaTo(0,0.14,0,function()
            frame:Remove()
       end)
    end
    addAnim(frame.Minimize)
    frame.Minimize.Paint = function(s,w,h)
        if s.LerpAlpha then s.LerpAlpha:DoLerp() end 

        if (s.LerpAlpha:GetValue() > 0) then 
            draw.RoundedBoxEx(15,0,0,w,h,getAlpha(bgLightGray,s.LerpAlpha:GetValue()),false,false,false,false)
        end
        
        draw.SimpleText("-", "HexSh.X", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Footer
    local footer = vgui.Create("DPanel", frame)
    footer:Dock(BOTTOM)
    footer:DockMargin(0,0,0,0)
    footer:SetTall(toDecimal(9)*frame:GetTall())
    footer.Paint = function(s,w,h)
        draw.RoundedBoxEx(15,0,0,w,h,bgLightGray,false,false,true,true)
    end

    -- Body
    local Select = vgui.Create("HexSh.adminUI.BSelect", frame)
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