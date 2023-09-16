--HexSh UI TextEntry

local PANEL = {}
local deactivatered = Color(250,0,0,130)

local black = Color(0,0,0,255)
local white = Color(255,255,255)
 --bg
local bgButton = Color(45,45,45) -- buttonhovere
local bgLightGray = Color(49,47,50)
local bghovergray = Color(46,48,52,250)
local getAlpha = function(col, a)
    return Color(col["r"], col["g"], col["b"], a)
end
--Fonts
surface.CreateFont( "HexSh.Entry.Text", {
    font = "Montserrat", 
    extended = false,
    size = 20,
    weight = 1000,
} )


--ELEMEN
function PANEL:Init()
    self:SetPaintBackground( false )
    self:SetFont("HexSh.Entry.Text")

    self.Lerp = HexSh:Lerp(0,0,0.3)
    self.bg = bgLightGray
    self.ErrorLerp = HexSh:Lerp( 0, 0, 0.5 );
end

function PANEL:SetMaxLetters(num)
    self.GetMaxLetters = num    
end

function PANEL:SetBackgroundColor(clr)
    self.bg = clr
end

function PANEL:OnGetFocus()
    if (self.AreFocus) then return end
    self.AreFocus = true 
    self.Lerp = HexSh:Lerp(0,self:GetWide(),0.3)
    self.Lerp:DoLerp()
end
function PANEL:OnLoseFocus()
    self.AreFocus = false
    self.Lerp = HexSh:Lerp(self:GetWide(),0,0.3)
    self.Lerp:DoLerp()
end

function PANEL:DoError(bool)
    if (!isbool(bool)) then end

    if ( bool ) then 
        self.ErrorLerp = HexSh:Lerp( 0, 255, 0.5 );
        self.ErrorLerp:DoLerp();
    else
        self.ErrorLerp = HexSh:Lerp( 255, 0, 0.5 );
        self.ErrorLerp:DoLerp();
    end;
end

function PANEL:OnChange()
    if (self.GetMaxLetters) then 
        local count = string.len(self:GetText())
        if (count >= self.GetMaxLetters) then 
            self:DoError(true)
            self:SetText(string.Left(self:GetText(), self.GetMaxLetters))
        end
    end
end

function PANEL:Paint(w,h)
    if (self.ErrorLerp) then self.ErrorLerp:DoLerp(); end

    if ( self.ErrorLerp:GetValue() >= 255 ) then 
        self:DoError( false );
    end;

    if ( self.ErrorLerp:GetValue() > 1 ) then             
        self:SetEditable( false )
    else
        self:SetEditable( true )
    end;

    if (self:GetDisabled() == true) then 
        draw.RoundedBox(7.5,0,0,w,h,self.bg)
        draw.RoundedBox(7.5,0,0,w,h,deactivatered)
    else 
        draw.RoundedBox(7.5,0,0,w,h,self.ErrorLerp:GetValue() > 1 && getAlpha(deactivatered, self.ErrorLerp:GetValue()) ||self.bg)
    end
    self:DrawTextEntryText(Color(255,255,255), Color(255, 30, 255),Color(255, 30, 255) );
    self:SetTextColor(white)

    if (self:GetText()=="") then 
        draw.SimpleText(self:GetPlaceholderText() || "", self:GetFont(), 3, h/2, Color(205,205,205), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    end

    if (self.Lerp) then self.Lerp:DoLerp() end

    local bar = self.Lerp:GetValue()
    if bar > 0 && !self:GetDisabled() then
        draw.RoundedBoxEx(20,(w / 2) - (bar / 2), h-2,bar,3,HexSh.adminUI.Color.purple,false,false,true,true)
    end
    
    local extralen = 0
    if (string.len(self:GetText())>=10) then extralen = 10 end
    if (string.len(self:GetText())>=100) then extralen = 12 end
    if (string.len(self:GetText())>=1000) then extralen = 19 end
    

    draw.SimpleText(!self.GetMaxLetters && string.len(self:GetText()).. "/∞" || string.len(self:GetText()).."/"..self.GetMaxLetters, "DermaDefault", self.AreFocus && w-40-extralen || w-22-extralen, h-10, Color(205,205,205), TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)

end

vgui.Register("HexSh.UI.TextEntry", PANEL, "DTextEntry")