
derma.DefineControl("HexSh.UI.BPanel", nil, {}, "EditablePanel")
  
local PANEL = {}

AccessorFunc(PANEL, "horizontalMargin", "HorizontalMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "verticalMargin", "VerticalMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "columns", "Columns", FORCE_NUMBER)

function PANEL:Init()
	self:SetHorizontalMargin(0)
	self:SetVerticalMargin(0)

	self.Rows = {}
	self.Cells = {}
end

function PANEL:AddCell(pnl)
	local cols = self:GetColumns()
	local idx = math.floor(#self.Cells/cols)+1
	self.Rows[idx] = self.Rows[idx] || self:CreateRow()

	local margin = self:GetHorizontalMargin()
	
	pnl:SetParent(self.Rows[idx])
	pnl:Dock(LEFT)
	pnl:DockMargin(0, 0, #self.Rows[idx].Items+1 < cols && self:GetHorizontalMargin() || 0, 0)
	pnl:SetWide((self:GetWide()-margin*(cols-1))/cols)

	table.insert(self.Rows[idx].Items, pnl)
	table.insert(self.Cells, pnl)
	self:CalculateRowHeight(self.Rows[idx])
end

function PANEL:CreateRow()
	local row = self:Add("DPanel")
	row:Dock(TOP)
	row:DockMargin(0, 0, 0, self:GetVerticalMargin())
	row.Paint = nil
	row.Items = {}
	return row
end

function PANEL:CalculateRowHeight(row)
	local height = 0

	for k, v in pairs(row.Items) do
		height = math.max(height, v:GetTall())
	end

	row:SetTall(height)
end

function PANEL:Skip()
	local cell = vgui.Create("DPanel")
	cell.Paint = nil
	self:AddCell(cell)
end

function PANEL:Clear()
	for _, row in pairs(self.Rows) do
		for _, cell in pairs(row.Items) do
			cell:Remove()
		end
		row:Remove()
	end

	self.Cells, self.Rows = {}, {}
end

PANEL.OnRemove = PANEL.Clear

vgui.Register("ThreeGrid", PANEL, "DScrollPanel")








HexSh.UI.LerpColor = function(from, to, time)
	local interpolation_data = {
		current_color = table.Copy(from),
		from = table.Copy(from),
		to = table.Copy(to),

		ceil_r = to.r > from.r,
		ceil_g = to.g > from.g,
		ceil_b = to.b > from.b,

		curtime = SysTime()
	}

function interpolation_data:DoLerp()
   if (
      self.current_color.r == self.to.r and
      self.current_color.g == self.to.g and
      self.current_color.b == self.to.b
   ) then
      return
   end
   local time_fraction = math.min(math.TimeFraction(self.curtime, self.curtime + time, SysTime()), 1)
   time_fraction = time_fraction ^ (1.0 - ((time_fraction - 0.5)))
   self.current_color.r = Lerp(time_fraction, self.from.r, self.to.r)
   self.current_color.g = Lerp(time_fraction, self.from.g, self.to.g)
   self.current_color.b = Lerp(time_fraction, self.from.b, self.to.b)
   if (self.ceil_r) then
      self.current_color.r = math.ceil(self.current_color.r)
   else
      self.current_color.r = math.floor(self.current_color.r)
   end
   if (self.ceil_g) then
      self.current_color.g = math.ceil(self.current_color.g)
   else
      self.current_color.g = math.floor(self.current_color.g)
   end
   if (self.ceil_b) then
      self.current_color.b = math.ceil(self.current_color.b)
   else
      self.current_color.b = math.floor(self.current_color.b)
   end
end
function interpolation_data:GetColor()
   return self.current_color
end
function interpolation_data:SetColor(col)
   self.current_color = table.Copy(col)
   self.from = table.Copy(col)
   self.to = table.Copy(col)
   self.curtime = SysTime()
end
function interpolation_data:SetTo(to)
   self.curtime = SysTime()
   
   self.from = table.Copy(self.current_color)
   self.to = table.Copy(to)

   self.ceil_r = self.to.r > self.from.r
   self.ceil_g = self.to.g > self.from.g
   self.ceil_b = self.to.b > self.from.b
end
   return interpolation_data

end


HexSh.UI.Lerp = function(from, to, time)
	local interpolation_data = {
		current_val = from,
		from = from,
		to = to,

		ceil = to > from,

		curtime = SysTime(),
	}
	function interpolation_data:DoLerp()
		if (self.current_val == self.to) then return end
		local time_fraction = math.min(math.TimeFraction(self.curtime, self.curtime + time, SysTime()), 1)
		time_fraction = time_fraction ^ (1.0 - ((time_fraction - 0.5)))
		self.current_val = Lerp(time_fraction, self.from, self.to)
		if (self.ceil) then
			self.current_val = math.ceil(self.current_val)
		else
			self.current_val = math.floor(self.current_val)
		end
	end
	function interpolation_data:GetValue()
		return self.current_val
	end
	function interpolation_data:SetValue(val)
		self.current_val = val
		self.to = val
		self.from = val
		self.curtime = SysTime()
	end
	function interpolation_data:SetTo(to)
		self.curtime = SysTime()
		
		self.from = self.current_val
		self.to = to

		self.ceil = self.to > self.from
	end
	return interpolation_data
end












local PANEL = {}

local on_color  = Color(70,168,53)
local off_color = Color(216,75,75)
local switch_width = 40
local switch_height = 20
local label_margin = 7

local function Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	return cir 
end

function PANEL:Init()
	self.LeftCircle = false
	self.RightCircle = false

	self.Active = false
	self.ColorInterpolation = HexSh.UI.LerpColor(off_color, off_color, .25)
	self.SwitchInterpolation = HexSh.UI.Lerp(switch_height / 2, switch_height / 2, .25)

	self.Label = vgui.Create("DLabel", self)
	self.Label:SetContentAlignment(4)
	self.Label:SetFont("HexSh.UI.25")
	self.Label:SetTextColor(Color(255,255,255))
	self:SetText("Switch")

	self.ClickableArea = vgui.Create("DPanel", self)
	self.ClickableArea:SetMouseInputEnabled(true)
	self.ClickableArea:SetCursor("hand")
	function self.ClickableArea.Paint(self,w,h)
		return 		
	end
	function self.ClickableArea:OnMouseReleased(m)
		if (m ~= MOUSE_LEFT) then return end
		local checked = not self:GetParent().Active
		self:GetParent():SetChecked(checked, true)
		--	if (checked) then
		--		surface.PlaySound("UI/buttonclick.wav")
		--	else
		--		surface.PlaySound("UI/buttonclick.wav")

		--	end
		if (self:GetParent().OnChange) then
			self:GetParent():OnChange()
		end
	end
end

function PANEL:PerformLayout()
	self.ClickableArea:SetSize(switch_width + label_margin + self.Label:GetWide() + label_margin, switch_height)
end

function PANEL:SetText(text)
	self.Text = text
 
	self.Label:SetText(text)
	self.Label:SizeToContents()
	self.Label:AlignLeft(switch_width + label_margin)
	self.Label:SizeToContents()

	self:SetSize(switch_width + label_margin + self.Label:GetWide(), switch_height)

	self.Label:CenterVertical()
end
function PANEL:GetText(text)
	return self.Text
end

function PANEL:Paint(w)
	if !self.LeftCircle or !self.RightCircle then
		self.LeftCircle = Circle(switch_height / 2, switch_height / 2, switch_height / 2,20)
		self.RightCircle = Circle(switch_width - switch_height / 2, switch_height / 2, switch_height / 2,20)
	end

	self.ColorInterpolation:DoLerp()
	self.SwitchInterpolation:DoLerp()

	surface.SetDrawColor(self.ColorInterpolation:GetColor())
	draw.NoTexture()
	surface.DrawPoly(self.LeftCircle)
	surface.DrawPoly(self.RightCircle)

	surface.DrawRect(switch_height / 2, 0, switch_width - switch_height, switch_height)

	surface.SetDrawColor(255, 255, 255)
	surface.DrawPoly(Circle(self.SwitchInterpolation:GetValue(), switch_height / 2, switch_height / 2 - 2,20))


	local ww, hh, txtt, clr = 0, 0, "", nil
	if (self:GetChecked()) then 
		ww = switch_height / 2 - 5
		hh = switch_height / 2 -11
		txtt = "✓"
		clr = Color(255,255,255)
	else 
		ww = switch_width / 2 + 3
		hh = switch_height / 2 -11
		txtt = "X"
		clr = Color(255,255,255)
	end

	draw.SimpleText(txtt, "HexSh.UI.20", ww, hh, clr, TEXT_ALIGN_LEFT )

end

function PANEL:SetChecked(active, animate)
	if (self.Disabled) then return end
	self.Active = active
	local from
	local to
	if (active) then
		from = switch_height / 2
		to = switch_width - (switch_height / 2)
	else
		from = switch_width - (switch_height / 2)
		to = switch_height / 2
	end
	if (animate) then
		self.SwitchInterpolation:SetTo(to)
		self.ColorInterpolation:SetTo(active and on_color or off_color)
	else
		self.SwitchInterpolation = HexSh.UI.Lerp(to, to, .25)
		if (active) then
			self.ColorInterpolation = HexSh.UI.LerpColor(on_color, on_color, .25)
		else
			self.ColorInterpolation = HexSh.UI.LerpColor(off_color, off_color, .25)
		end
	end
end
function PANEL:GetChecked()
	return self.Active
end

function PANEL:SetHelpText(text)
	self.HelpLabel = vgui.Create("DLabel", self)
	self.HelpLabel:SetTextColor(Color(200,200,200))
	self.HelpLabel:SetAutoStretchVertical(true)
	self.HelpLabel:SetWrap(true)
	self.HelpLabel:SetFont("HexSh.UI.Text.15")
	self.HelpLabel:AlignTop(switch_height + 10)
	self.HelpLabel:SetText(text)
	function self.HelpLabel:PerformLayout()
		local w = math.min(500, self:GetParent():GetWide())
		if (self:GetWide() ~= w) then
			self:SetWide(w)
		end
		self:GetParent():SetSize(switch_width + label_margin + self:GetParent().Label:GetWide(), switch_height + 10 + self:GetTall())
	end
end

function PANEL:SetDisabled(disabled)
	self.Disabled = disabled
	if (self.Disabled) then
		self.ColorInterpolation:SetColor(Color(165,165,165))
		self.Label:SetTextColor(Color(180,180,180))
		self.ClickableArea:SetCursor("no")
	else
		self.ClickableArea:SetCursor("hand")
		self.Label:SetTextColor(Color(255,255,255))
		if (self:GetChecked()) then
			self.ColorInterpolation:SetColor(on_color)
		else
			self.ColorInterpolation:SetColor(off_color)
		end
	end
end
function PANEL:GetDisabled()
	return self.Disabled
end

derma.DefineControl("HexSh.UI.Switch", nil, PANEL, "DPanel")






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
	self:SetIsMenu( true )
	self:SetSortItems( true )

end

function PANEL:Paint(w,h)
	self:SetFont("HexSh.UI.20")
	self:SetTextColor(Color(255,255,255 ))
	colo = Color(255,255,255)
	if self:IsHovered() then 
		colo = Color(106,33,223)
	end
	draw.RoundedBox(0,0,ScrH()*0.03,w,2.5,colo)
	self:SetTextInset( self:GetWide()/2 - 30, 0 )
end
function PANEL:Clear()

	self:SetText( "" )
	self.Choices = {}
	self.Data = {}
	self.ChoiceIcons = {}
	self.Spacers = {}
	self.selected = nil

	if ( self.Menu ) then
		self.Menu:Remove()
		self.Menu = nil
	end

end

function PANEL:GetOptionText( id )

	return self.Choices[ id ]

end

function PANEL:GetOptionData( id )

	return self.Data[ id ]

end

function PANEL:GetOptionTextByData( data )

	for id, dat in pairs( self.Data ) do
		if ( dat == data ) then
			return self:GetOptionText( id )
		end
	end

	-- Try interpreting it as a number
	for id, dat in pairs( self.Data ) do
		if ( dat == tonumber( data ) ) then
			return self:GetOptionText( id )
		end
	end

	-- In case we fail
	return data

end

function PANEL:PerformLayout()

	self.DropButton:SetSize( 15, 15 )
	self.DropButton:AlignRight( 4 )
	self.DropButton:CenterVertical()

	-- Make sure the text color is updated
	DButton.PerformLayout( self, w, h )

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

function PANEL:ChooseOptionID( index )

	local value = self:GetOptionText( index )
	self:ChooseOption( value, index )

end

function PANEL:GetSelectedID()

	return self.selected

end

function PANEL:GetSelected()

	if ( !self.selected ) then return end

	return self:GetOptionText( self.selected ), self:GetOptionData( self.selected )

end

function PANEL:OnSelect( index, value, data )

	-- For override

end

function PANEL:OnMenuOpened( menu )

	-- For override

end

function PANEL:AddSpacer()

	self.Spacers[ #self.Choices ] = true

end

function PANEL:AddChoice( value, data, select, icon )

	local i = table.insert( self.Choices, value )

	if ( data ) then
		self.Data[ i ] = data
	end
	
	if ( icon ) then
		self.ChoiceIcons[ i ] = icon
	end

	if ( select ) then

		self:ChooseOption( value, i )

	end

	return i

end

function PANEL:IsMenuOpen()

	return IsValid( self.Menu ) && self.Menu:IsVisible()

end

function PANEL:OpenMenu( pControlOpener )

	if ( pControlOpener && pControlOpener == self.TextEntry ) then
		return
	end

	-- Don't do anything if there aren't any options..
	if ( #self.Choices == 0 ) then return end

	-- If the menu still exists and hasn't been deleted
	-- then just close it and don't open a new one.
	if ( IsValid( self.Menu ) ) then
		self.Menu:Remove()
		self.Menu = nil
	end

	-- If we have a modal parent at some level, we gotta parent to that or our menu items are not gonna be selectable
	local parent = self
	while ( IsValid( parent ) && !parent:IsModal() ) do
		parent = parent:GetParent()
	end
	if ( !IsValid( parent ) ) then parent = self end

	self.Menu = DermaMenu( false, parent )
	for k, v in pairs( self.Choices ) do
		local option = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
		if ( self.ChoiceIcons[ k ] ) then
			option:SetIcon( self.ChoiceIcons[ k ] )
		end
		if ( self.Spacers[ k ] ) then
			self.Menu:AddSpacer()
		end

		option.Paint = function(self,w,h)
			self:SetFont("HexSh.UI.20")
			self:SetTextColor(Color(255,255,255 ))
			surface.SetDrawColor(Color(255,255,255))
			draw.RoundedBox(0,0,0,2.5,h,Color(255,255,255))
			draw.RoundedBox(0,0,ScrH()*0.02,w,2.5,Color(255,255,255))
			if self:IsHovered() then 
				draw.RoundedBox(0,0,0,w,h,Color(255,255,255,40))
			end
		end
	end

	local x, y = self:LocalToScreen( 0, self:GetTall() )

	self.Menu:SetMinimumWidth( self:GetWide() )
	self.Menu:Open( x, y, false, self )

	self:OnMenuOpened( self.Menu )

	self.Menu.Paint = nil

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

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:AddChoice( "Some Choice" )
	ctrl:AddChoice( "Another Choice", "myData" )
	ctrl:AddChoice( "Default Choice", "myData2", true )
	ctrl:AddChoice( "Icon Choice", "myData3", false, "icon16/star.png" )
	ctrl:SetWide( 150 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "HexSh.UI.Combobox", "", PANEL, "DButton" )
