----

local PANEL = {}

AccessorFunc( PANEL, "ActiveButton", "ActiveButton" )

function PANEL:Init()

    self.NavPanel = vgui.Create( "DPanel", self )
    self.NavPanel:Dock( LEFT )
	self.NavPanel:SetWide( 140 )
	self.NavPanel:DockMargin( 0, 0, 0, 0 )
	self.NavPanel.Paint = function(self, w, h)
		--draw.RoundedBoxEx(10,0,0,w,h,Color(0,0,0),false,false,true,false)
	end
	local r = vgui.Create("DLabel", self.NavPanel)
	r:Dock(RIGHT)
	r:SetWide(2)
	r:SetText("")
	r.Paint = function(self,w,h)
		draw.RoundedBoxEx(0,0,0,w,h,Color(255,255,255),false,false,false,false)

	end

	

	self.Navigation = vgui.Create( "DScrollPanel", self.NavPanel )
	self.Navigation:Dock( FILL )

    
	self.Content = vgui.Create( "Panel", self )
	self.Content:Dock( FILL )
	self.Content:DockMargin( 5, 0, 10, 0 )

	local open = true
	local move = vgui.Create("DButton", self.NavPanel)
	move:SetText("")
	move:Dock(BOTTOM)

		if open then 
			move:SetText("<---")
		else
			move:SetText("--->")
		end

	move.DoClick = function()
		if open then 
			open = false
			self.NavPanel:SetWide(40)
			for _, v in pairs(PANEL.ITEMS) do    
				v.Button:SetText(string.Left( v.Button:GetText(), 1 ))
			end
			move:SetText("--->")
		else
			open = true
			self.NavPanel:SetWide(140)
			for _, v in pairs(PANEL.ITEMS) do    
				v.Button:SetText(tostring(v.BasedText))
			end
			move:SetText("<---")
		end
	end

	self.Items = {}

	PANEL.ITEMS = self.Items

end


function PANEL:AddSheet( label, panel, color, material)

	if ( !IsValid( panel ) ) then return end

	local Sheet = {}


    Sheet.Button = vgui.Create( "DButton", self.Navigation )
	

	Sheet.Button:SetImage( material )
	Sheet.Button.Target = panel
	Sheet.Button:Dock( TOP )
	Sheet.Button:SetText( label )
	Sheet.Button:SetFont("HexSh.UI.30")
    Sheet.Button:SetTall(100)
	Sheet.Button:DockMargin( 5, 5, 5, 0 )
	Sheet.Button:SetColor( Color( 255, 255, 255) )
	Sheet.Button.Col = color or Color(0, 255, 255)
	Sheet.BasedText = label

    Sheet.Button.Paint = function(self, w, h)
		draw.RoundedBox(0,0, 0, w, h, Color(0, 0, 0, 255))
	--	draw.RoundedBox(0, 0, 0, 5, h, self.Col)

		if self:IsHovered() then 
			draw.RoundedBox(0,0,0, w, h, Color(173, 173, 173, 130))
		end
	end

	Sheet.Button.DoClick = function()
		self:SetActiveButton( Sheet.Button )
	end

	Sheet.Panel = panel
	Sheet.Panel:SetParent( self.Content )
	Sheet.Panel:SetVisible( false )

	Sheet.IsButton = true
	table.insert( self.Items, Sheet )
	PrintTable(self.Items)

	if ( !IsValid( self.ActiveButton ) ) then
		self:SetActiveButton( Sheet.Button )
	end
	
	return Sheet
end

function PANEL:AddSpacer( label, color)
	local Sheet = {}
    Sheet.Button = vgui.Create( "DPanel", self.Navigation )
	Sheet.Button:Dock( TOP )
    Sheet.Button:SetSize(200, 40)
	Sheet.Button:DockMargin( 0, 0, 0, 0 )
    Sheet.Button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, 200, 40, color)
		draw.SimpleText(label, "DermaDefault", 50, 13, Color(255, 255, 255))
	end
	table.insert( self.Items, Sheet )	
	return Sheet
end

function PANEL:AddSP(size, color)
	local scale = size or 1
	local Sheet = {}
    Sheet.Button = vgui.Create( "DPanel", self.Navigation )
	Sheet.Button:Dock( TOP )
    Sheet.Button:SetSize(200, 40 * scale)
	Sheet.Button:DockMargin( 0, 0, 0, 0 )
    Sheet.Button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, 200, 40 * scale, color or Color(255, 255, 255, 0))
	end
	table.insert( self.Items, Sheet )	
	return Sheet
end
function PANEL:ClearItems()
	self.Items = nil
	self.Items = {}
	self.Navigation:Clear()
	self:CreateSearch()
end


function PANEL:SetActiveButton( active )

	if ( self.ActiveButton == active ) then return end

	if ( self.ActiveButton && self.ActiveButton.Target ) then
		self.ActiveButton.Target:SetVisible( false )
		self.ActiveButton:SetSelected( false )
		self.ActiveButton:SetToggle( false )
		self.ActiveButton.Paint = function(self, w, h)
			draw.RoundedBox(0,0, 0, w, h, Color(0, 0, 0, 255))
			--	draw.RoundedBox(0, 0, 0, 5, h, self.Col)
			self:SetTextColor(Color(255,255,255))
			
			if self:IsHovered() then 
				draw.RoundedBox(0,0,0, w, h, Color(173, 173, 173, 130))
			end
		end

	end

	self.ActiveButton = active
	active.Target:SetVisible( true )
	active:SetSelected( true )
	active:SetToggle( true )
	local speed = 7
	local barStatus = 0  
	active.Paint = function(self, w, h)
		local clr = Color(255, 255, 255)

		if barStatus then 
            barStatus = math.Clamp(barStatus + speed * FrameTime(), 0, 1)
       	else
            barStatus = math.Clamp(barStatus - speed * FrameTime(), 0, 1)
       	end

		--self:SetTextColor(self.Col)
		draw.RoundedBox(7.5,0,0,w,h,self.Col) --255,193,7,255
		--draw.RoundedBox(5,2,2,w-4,h-4,Color(53,52,52))
	end
	self.Content:InvalidateLayout()

end


derma.DefineControl( "HexSh.UI.Select", "", PANEL, "Panel" )