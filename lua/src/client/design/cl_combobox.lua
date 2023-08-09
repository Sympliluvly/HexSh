--DropDown

local PANEL  = {}
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


local PANEL = {}

Derma_Hook( PANEL, "Paint", "Paint", "ComboBox" )

Derma_Install_Convar_Functions( PANEL )

AccessorFunc( PANEL, "m_bDoSort", "SortItems", FORCE_BOOL )

function PANEL:Init()

	self.DropButton = vgui.Create( "DPanel", self )
	self.DropButton.Paint = function( panel, w, h ) derma.SkinHook( "Paint", "ComboDownArrow", panel, w, h ) end
	self.DropButton:SetMouseInputEnabled( false )
	self.DropButton.ComboBox = self

	self:SetTall( 22 )
	self:Clear()

	self:SetContentAlignment( 4 )
	self:SetTextInset( 8, 0 )
	self:SetIsMenu( true )
	self:SetSortItems( true )

end

function PANEL:Clear()

	self:SetText( "" )
    self.ChoiceData = {}
     --[[TableConstruct
        
     id:{
        name: name
        type: any
        icon: imgurID
     }

     ]]
	self.selected = nil

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end

end


function PANEL:PerformLayout()

	self.DropButton:SetSize( 15, 15 )
	self.DropButton:AlignRight( 4 )
	self.DropButton:CenterVertical()

	-- Make sure the text color is updated
	DButton.PerformLayout( self, w, h )

end

function PANEL:ChooseOption( id, title, type, icon )

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end


    if (self.ChoiceData[id] == "space") then return end 

	self:SetText( title )

	-- This should really be the here, but it is too late now and convar changes are handled differently by different child elements
	--self:ConVarChanged( self.Data[ index ] )

	self.selected = id
	self:OnSelect( id, title, type, icon )

end



function PANEL:OnMenuOpened( menu )

	-- For override

end

--[[function PANEL:AddSpacer()

	self.ChoiceData[ #self.ChoiceData + 1 ] = "space"

end]]

function PANEL:AddChoice( title, type, tooltip, icon, select)

    if (!title) then return end 
    if (!type) then return end 

    local id = #self.ChoiceData + 1

    self.ChoiceData[id] = {
        title = title,
        type = type,
        tooltip = tooltip || "",
        icon = icon || ""
    }

    if ( select ) then

		self:ChooseOption( id, title, type, icon)

	end


end

function PANEL:IsMenuOpen() return IsValid( self.Menu ) && self.Menu:IsVisible() end

function PANEL:OpenMenu(pControlOpener)

	if (pControlOpener && pControlOpener == self.TextEntry) then
		return
	end

	if (#self.ChoiceData == 0) then return end
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

	for k, v in pairs(self.ChoiceData) do
		local option = self.Menu:AddOption( v, function() 
            self:ChooseOption(k, v.title, v.type, v.icon) 
        end)

		function option:PerformLayout(w, h)
			self:SetTall(40)
		end

		local this = self
		
        option:SetTooltip(v.tooltip)
		option.Paint = function (self, w, h)
			local col = (self:IsHovered() and HexSh.adminUI.Color.purple) or bgButton
			local dropdownParent = self:GetParent()
			if (dropdownParent.multiple and dropdownParent.selectedItems[v]) then
				col = HexSh.adminUI.Color.purple
			end

			if (k == #this.ChoiceData) then
                draw.RoundedBoxEx(12, 0, 0, w, h, HexSh.adminUI.Color.purple, false, false, true, true)
				draw.RoundedBoxEx(12, 2,0,w-4,h-2, col, false, false, true, true)
           -- elseif (k == 1) then 
				--draw.RoundedBoxEx(12, 0, 0, w, h, col, true, true, false, false)
            else
                surface.SetDrawColor(HexSh.adminUI.Color.purple)
				surface.DrawRect(0,0,w,h)
				surface.SetDrawColor(col)
				surface.DrawRect(2,0,w-4,h)
			end

			draw.SimpleText(v.title, "HexSh.UI.20", w/2, h/2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
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
        draw.RoundedBoxEx( 12, 0, 0, w, h, HexSh.adminUI.Color.purple, false,true,false,true ); 
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

function PANEL:CloseMenu()

	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove()
	end

end

-- This really should use a convar change hook
function PANEL:CheckConVarChanges()

	if ( !self.m_strConVar ) then return end

	local strValue = GetConVarString( self.m_strConVar )
	if ( self.m_strConVarValue == strValue ) then return end

	self.m_strConVarValue = strValue

	self:SetValue( self:GetOptionTextByData( self.m_strConVarValue ) )

end

function PANEL:Think()

	self:CheckConVarChanges()

end

function PANEL:SetValue( strValue )

	self:SetText( strValue )

end

function PANEL:DoClick()

	if ( self:IsMenuOpen() ) then
		return self:CloseMenu()
	end

	self:OpenMenu()

end

function PANEL:Paint(w,h)
    draw.RoundedBox(7.5,0,0,w,h,bgButton)
end


derma.DefineControl( "HexSh.UI.Combobx", "", PANEL, "DButton" )