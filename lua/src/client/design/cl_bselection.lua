-- Selection for HexAdmin UI

local black = Color(0,0,0,255)
local white = Color(255,255,255)

local bgLightGray = Color(49,47,50)
local bgButton = Color(45,45,45) -- buttonhovere
local bghovergray = Color(46,48,52,250)
local getAlpha = function(col, a)
    return Color(col["r"], col["g"], col["b"], a)
end
local toDecimal = function( x ) return ( ( x <= 100 ) && x || 100 ) * 0.01 end;
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
local function AddMat(p,m)
    surface.SetDrawColor(white)
    surface.SetMaterial(m)
    surface.DrawTexturedRect(toDecimal(6.4)*p:GetWide(),(toDecimal(80)*p:GetTall())-25,25,25)
end
local PANEL = {}


function PANEL:Init()
    local parent = self:GetParent()
    self:SetSize(toDecimal(30)*self:GetParent():GetWide(),toDecimal(80)*self:GetParent():GetTall())
    self:SetPos((toDecimal(31) * self:GetParent():GetWide()) - self:GetWide(), (toDecimal(90) * self:GetParent():GetTall()) - self:GetTall())

    function self:addEditLayer()
        if (self.EditLayer) then 
            self.EditLayer:Remove()                
        end
        self.EditLayer = vgui.Create("DPanel", parent)
        self.EditLayer:SetAlpha(0)
        self.EditLayer:SetSize(toDecimal(67)* self:GetParent():GetWide(),toDecimal(80)*self:GetParent():GetTall())
        self.EditLayer:SetPos((toDecimal(99) * self:GetParent():GetWide()) - self.EditLayer:GetWide(), (toDecimal(90) * self:GetParent():GetTall()) - self.EditLayer:GetTall())
        self.EditLayer:AlphaTo(255,0.3,0)
        self.EditLayer.Paint = function(s,w,h)
            draw.RoundedBox(2.5,0,0,w,h,HexSh.adminUI.Color.purple)
            draw.RoundedBox(2.5,1,1,w-3,h-3,bgLightGray)
        end

    end

    self:addEditLayer()
    
    self.EditLayer.PaintOver = function(s,w,h)
        surface.SetDrawColor( white )
        surface.SetMaterial(HexSh:getImgurImage("wkm6FEZ"))
        surface.DrawTexturedRectRotated( toDecimal(50)*s:GetWide(), toDecimal(47)*s:GetTall(), 500, 500, CurTime() * 25 % 360 )
    end

    local ScrollBar = self:GetVBar();

    ScrollBar:SetHideButtons( true );
    ScrollBar:SetSize(10,0)

    function ScrollBar.btnGrip:Paint( w, h )  
        draw.RoundedBox( 80, 0, 0, w, h, HexSh.adminUI.Color.purple ); 
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


    -- buttons
    self:firstButtons()
end

function PANEL:firstButtons()
    for k, v in pairs(HexSh.adminUI.Items.S) do 
        self:AddSubMenu(k,v.title,v.icon)
    end
    for k,v in pairs(HexSh.adminUI.Items) do 
        if k == "S" then continue end 
        self:AddButton(v.title,v.icon,v.f)
    end
end

function PANEL:AddBackButton()
    local btn = vgui.Create("DButton",self)
    btn:Dock(TOP)
    btn:SetTall(40)
    btn:SetText("")
    btn.DoClick = function()
        self:GetCanvas():AlphaTo(0,0.15,0, function()
            self:Clear()
            self:firstButtons()
            self:GetCanvas():AlphaTo(255,0.15,0)
        end)
    end
    addAnim(btn)
    btn.Paint = function(s,w,h)
        if s.LerpAlpha then s.LerpAlpha:DoLerp() end 


        if (s.LerpAlpha:GetValue() > 0) then 
            draw.RoundedBoxEx(7.5,0,0,w,h,getAlpha(bgButton,s.LerpAlpha:GetValue()),true,true,true,true)
            local hh = toDecimal(40)*btn:GetTall()
            local y = (toDecimal(65)*btn:GetTall())-hh
            draw.RoundedBox(100,0,y,6,hh,getAlpha(HexSh.adminUI.Color.purple,s.LerpAlpha:GetValue()))
        end

        local m = HexSh:getImgurImage("ZEJjns5")
        AddMat(s,m)

        draw.SimpleText(HexSh:L("src_sh", "back"), "HexSh.X", (w/2)-25, h/2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

function PANEL:AddButton(t,i,f)
    local btn = vgui.Create("DButton",self)
    btn:Dock(TOP)
    btn:SetTall(40)
    btn:SetText("")
    btn.DoClick = function()
        self:addEditLayer()
        f(self.EditLayer)
    end
    addAnim(btn)
    btn.Paint = function(s,w,h)
        if s.LerpAlpha then s.LerpAlpha:DoLerp() end 

        if (s.LerpAlpha:GetValue() > 0) then 
            draw.RoundedBoxEx(7.5,0,0,w,h,getAlpha(bgButton,s.LerpAlpha:GetValue()),true,true,true,true)
            local hh = toDecimal(40)*btn:GetTall()
            local y = (toDecimal(65)*btn:GetTall())-hh
            draw.RoundedBox(100,0,y,6,hh,getAlpha(HexSh.adminUI.Color.purple,s.LerpAlpha:GetValue()))
        end

        if i then 
            AddMat(s,i)
        end

        draw.SimpleText(t, "HexSh.X", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function PANEL:AddSubMenu(ix,t,i,f)
    local btn = vgui.Create("DButton",self)
    btn:Dock(TOP)
    btn:SetTall(40)
    btn:SetText("")
    btn.DoClick = function()
        self:GetCanvas():AlphaTo(0,0.15,0, function()
            self:Clear()
            self:AddBackButton()
            for k,v in pairs(HexSh.adminUI.Items.S[ix].Btns) do 
                self:AddButton(v.title,v.icon,v.f)
            end
            self:GetCanvas():AlphaTo(255,0.15,0)
        end)
    end
    addAnim(btn)
    btn.Paint = function(s,w,h)
        if s.LerpAlpha then s.LerpAlpha:DoLerp() end 

        if (s.LerpAlpha:GetValue() > 0) then 
            draw.RoundedBoxEx(7.5,0,0,w,h,getAlpha(bgButton,s.LerpAlpha:GetValue()),true,true,true,true)
            local hh = toDecimal(40)*btn:GetTall()
            local y = (toDecimal(65)*btn:GetTall())-hh
            draw.RoundedBox(100,0,y,6,hh,getAlpha(HexSh.adminUI.Color.purple,s.LerpAlpha:GetValue()))
        end

        if i then 
            AddMat(s,i)
        end

        draw.SimpleText(t, "HexSh.X", toDecimal(20)*btn:GetWide()+25, h/2-2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(">", "HexSh.X", toDecimal(90)*btn:GetWide(), h/2, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end
 

vgui.Register("HexSh.adminUI.BSelect", PANEL, "DScrollPanel")




















