--local
local white = Color(255,255,255)
local scrw,scrh = ScrW(), ScrH()

-- Create Basicly a Singe line xD
function HexSh:createCfgSingeLiner(parent, Title, ToolTip)
    local SetTitlee = vgui.Create( "DPanel", parent )
    SetTitlee:Dock(TOP)
    SetTitlee:DockMargin(5,5,5,0)
    SetTitlee:SetTall( scrh*0.05 )
    if (ToolTip) then SetTitlee:SetTooltip( ToolTip ) end
    SetTitlee.Paint = function(self,w,h)
        draw.RoundedBox(0,0,0,2.5,h,white)
        draw.RoundedBox(0,0,scrh*0.049,scrw*0.19,2.5,white)
    end

    local SetTitlee_Info = vgui.Create("DLabel", SetTitlee )
    SetTitlee_Info:Dock( LEFT )
    SetTitlee_Info:DockMargin(0,0,0,0)
    SetTitlee_Info:SetWide( scrw * 0.3)
    SetTitlee_Info:SetText( "" )
    SetTitlee_Info.Paint = function(self,w,h)
        draw.SimpleText(Title, "HexSh.40", 20, self:GetTall() /2, Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end
    return SetTitlee
end