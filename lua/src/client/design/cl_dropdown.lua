--DropDown

local PANEL  = {}
local deactivatered = Color(250,0,0,130)
local purple = Color(188,19,235)
local black = Color(0,0,0,255)
local white = Color(255,255,255)
local bgGray = Color(38,35,38) --bg
local bgGray2 = Color(30,27,30)
local bgButton = Color(45,45,45) -- buttonhovere
local bgDarkGray = Color(33,31,31)
local bgLightGray = Color(49,47,50)
local bghovergray = Color(46,48,52,250)
local getAlpha = function(col, a)
    return Color(col["r"], col["g"], col["b"], a)
end

function PANEL:Init()
    self.Data = {}
end
function PANEL:OpenMenu(pControlOpener)

	if (pControlOpener && pControlOpener == self.TextEntry) then
		return
	end

	if (#self.Choices == 0) then return end
	if (IsValid(self.Menu)) then
		self.Menu:Remove()
		self.Menu = nil
	end

	local this = self

	self.Menu = DermaMenu(false, self)

	function self.Menu:AddOption(strText, funcFunction)

        local pnl = vgui.Create("DMenuOption", self)
        pnl:SetMenu(self)
        pnl:SetIsCheckable(true)
		if (funcFunction) then pnl.DoClick = funcFunction end


        function pnl:OnMouseReleased(mousecode)
            DButton.OnMouseReleased(self, mousecode)
            if (self.m_MenuClicking && mousecode == MOUSE_LEFT) then
                self.m_MenuClicking = false
            end
        end

        self:AddPanel(pnl)

        return pnl
    end

	for k, v in pairs(self.Choices) do
		local option = self.Menu:AddOption( v, function() self:ChooseOption(v, k) end )

		function option:PerformLayout(w, h)
			self:SetTall(40)
		end

		local this = self
		

		option.Paint = function (self, w, h)
			local col = (self:IsHovered() and purple) or bgButton
			local dropdownParent = self:GetParent()
			if (dropdownParent.multiple and dropdownParent.selectedItems[v]) then
				col = purple
			end

			if (k == #this.Choices) then
				draw.RoundedBoxEx(12, 0, 0, w, h, col, false, false, true, true)
           -- elseif (k == 1) then 
				--draw.RoundedBoxEx(12, 0, 0, w, h, col, true, true, false, false)
            else
				surface.SetDrawColor(col)
				surface.DrawRect(0,0,w,h)
			end

			draw.SimpleText(v, "HexSh.Entry.Text", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			return true
		end
	end

	local x, y = self:LocalToScreen(5, self:GetTall())

	self.Menu:SetMinimumWidth(self:GetWide() - 10)
	self.Menu:Open(x, y, false, self)
	self.Menu.Paint = nil

    local ScrollBar = self.Menu:GetVBar();

    ScrollBar:SetHideButtons( true );
    ScrollBar:SetSize(10,0)

    function ScrollBar.btnGrip:Paint( w, h )  
        draw.RoundedBoxEx( 12, 0, 0, w, h, purple, false,true,false,true ); 
    end;

    function ScrollBar:Paint( w, h )       
        draw.RoundedBoxEx( 12, 0, 0, w, h, Color(77,14,95),false,true,false,true ); 
    end;

    function ScrollBar.btnUp:Paint( w, h )       
        return; 
    end;

    function ScrollBar.btnDown:Paint( w, h )       
        return;
    end;

end

function PANEL:ChooseOption( value, index )

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	self:SetText( value )

	-- This should really be the here, but it is too late now and convar changes are handled differently by different child elements
	--self:ConVarChanged( self.Data[ index ] )

	self.selected = index
	self:OnSelect( index, value, self.Data[ index ] )

end


function PANEL:Paint(w,h)
    draw.RoundedBox(7.5,0,0,w,h,bgButton)
end

vgui.Register("HexSh.UI.DropDown", PANEL, "DComboBox")
