local PANEL = {}

function PANEL:AddLine(...)
    self:SetDirty( true )
	self:InvalidateLayout()

	local Line = vgui.Create( "DListView_Line", self.pnlCanvas )
	local ID = table.insert( self.Lines, Line )

	Line:SetListView( self )
	Line:SetID( ID )
    --Line:SetD

    
	-- This assures that there will be an entry for every column
	for k, v in pairs( self.Columns ) do
		Line:SetColumnText( k, "" )
    
	end
    
	for k, v in pairs( {...} ) do
		Line:SetColumnText( k, v )

	end
    
	-- Make appear at the bottom of the sorted list
	local SortID = table.insert( self.Sorted, Line )
    
	if ( SortID % 2 == 1 ) then
		Line:SetAltLine( true )
	end
    
    Line.Paint = function(s,w,h)
        if s:IsSelected() or s:IsHovered() then
            //draw.RoundedBox(0, 0, 0, w, h, Color(200,200,200,200))
            surface.SetDrawColor(Color(0,73,168))
            surface.DrawOutlinedRect(0,0,w,h,2)
        else
            if s:GetAltLine() then
                draw.RoundedBox(0, 0, 0, w, h, Color(35,35,35))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(40,40,40))
            end
        end
    end
	
    return Line
end





vgui.Register("HexSh.UI.List", PANEL, "DListView")




local PANEL = {}


function PANEL:Init()
		
	local ScrollBar = self:GetVBar();

	ScrollBar:SetHideButtons( true );
	ScrollBar:SetSize(5,0)

	function ScrollBar.btnGrip:Paint( w, h )  
		draw.RoundedBoxEx( 12, 0, 0, w, h, HexSh.adminUI.Color.purple, false,true,false,true ); 
	end;

	function ScrollBar.btnUp:Paint( w, h )       
		return; 
	end;

	function ScrollBar.btnDown:Paint( w, h )       
		return;
	end;
end

function PANEL:Paint( w, h )       
	--draw.RoundedBoxEx( 12, 0, 0, w, h, Color(77,14,95),false,true,false,true ); 
end;

vgui.Register("HexSh.UI.Scroll", PANEL, "DScrollPanel")