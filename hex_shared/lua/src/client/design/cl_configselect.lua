--


local PANEL = {}

AccessorFunc( PANEL, "ActiveButton", "ActiveButton" )

function PANEL:Init()


    self.NavPanel = vgui.Create( "DPanel", self )
    self.NavPanel:Dock( LEFT )
	self.NavPanel:SetWide( 190 )
	self.NavPanel:DockMargin( 0, 0, 10, 0 )
	self.NavPanel.Paint = function(self, w, h)
--		draw.RoundedBoxEx(0,0,0,w,h,Color(46,46,46),true,true,true,false)
	end

	self.Navigation = vgui.Create( "DScrollPanel", self.NavPanel )
	self.Navigation:Dock( FILL )

	
	self.Search = vgui.Create( "DTextEntry", self.NavPanel ) -- create the form as a child of frame
	self.Search:Dock( TOP )
	self.Search:SetPlaceholderText("search")
	local sbar = self.Navigation:GetVBar()
    sbar:SetSize(5,0)
    sbar:SetHideButtons( true )
    function sbar.btnGrip:Paint(w, h) draw.RoundedBoxEx(14,0,0,w,h,Color(118,48,158),false,false,false,false) end
    function sbar:Paint(w, h) draw.RoundedBoxEx(14,0,0,w,h,Color(46,46,46),false,false,false,false) end
    function sbar.btnUp:Paint(w, h) return end
    function sbar.btnDown:Paint(w, h) return end

    
	self.Content = vgui.Create( "Panel", self )
	self.Content:Dock( FILL )
	self.Content:DockMargin( 0, 0, 10, 0 )

	self.Items = {}

	PANEL.ITEMS = self.Items

	local navi = self.Navigation

	function self.Search:OnChange()
		local search_text = self:GetText():lower()
		if (#search_text == 0) then
			for _,v in pairs(PANEL.ITEMS) do
			--	v.Button:SetVisible(true)
				v.Button:SetTall(80)
			end
		else
			for _,v in pairs(PANEL.ITEMS) do
				if (v.Button:GetText():lower():find(search_text,1,true)) then
					--v.Button:SetVisible(true)
					v.Button:SetTall(80)
				else
				--	v.Button:SetVisible(false)
					v.Button:SetTall(0)
				end
			end
		end
	end

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
    Sheet.Button:SetTall(80)
	Sheet.Button:DockMargin( 0, 5, 5, 0 )
	Sheet.Button:SetColor( Color( 255, 255, 255) )
	Sheet.Button.Col = color or Color(0, 255, 255)

    Sheet.Button.Paint = function(self, w, h)
		draw.RoundedBox(0,0, 0, w, h, Color(22,22,22))
		draw.RoundedBoxEx(0, 0, 0, 5, h, self.Col,true,true,true,true)

		if self:IsHovered() then 
			draw.RoundedBoxEx(0,5,0, w - 5, h, Color(173, 173, 173, 130),false,true,false,true)
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


local start = SysTime()
function PANEL:SetActiveButton( active )

	if ( self.ActiveButton == active ) then return end

	if ( self.ActiveButton && self.ActiveButton.Target ) then
		self.ActiveButton.Target:SetVisible( false )
		self.ActiveButton:SetSelected( false )
		self.ActiveButton:SetToggle( false )
		self.ActiveButton.Paint = function(self, w, h)
			draw.RoundedBox(0,0, 0, w, h, Color(22,22,22))
			draw.RoundedBoxEx(0, 0, 0, 5, h, self.Col,true,true,true,true)
			self:SetTextColor(Color(255,255,255))

			if self:IsHovered() then 
				draw.RoundedBoxEx(0,5,0, w - 5, h, Color(173, 173, 173, 130),false,true,false,true)
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
		draw.RoundedBox(0,0,0,w * barStatus,h,self.Col) --255,193,7,255
		--draw.RoundedBox(5,2,2,w-4,h-4,Color(53,52,52))
	end
	self.Content:InvalidateLayout()

end


derma.DefineControl( "HexSh.UI.ConfigSelect", "", PANEL, "Panel" )