local PANEL = {}
local white = Color( 255, 255, 255 );
local red = Color( 250, 0, 0, 255 );
local BlueMain = Color( 22, 23, 35, 255 );
local BlueSecond = Color( 22, 23, 41, 255 )
local Purplemain = Color( 63, 15, 164, 255);
local color = Color( Purplemain["r"], Purplemain["g"], Purplemain["b"], 20 );
local Roundcol = Purplemain;

function PANEL:Init()
	self.BadKeys = {};
	self.Disabled = false;
	self:SetSelectedNumber( 0 )
	self:SetSize( 60, 30 )
	self:SetFont( "HexSh.X" )
	self:SetTextColor( white )
end

function PANEL:UpdateText()
	local str = input.GetKeyName( self:GetSelectedNumber() )
	if ( !str ) then str = "NONE" end
	str = language.GetPhrase( str )
	self:SetText( str )
end

function PANEL:DoClick()
	if ( self.Disabled ) then return end;

	ClickX, ClickY = self:CursorPos();

	Rad = 0;

	Alpha = color["a"];

	self:SetText("any key" )
	input.StartKeyTrapping()
	self.Trapping = true
end

function PANEL:DoRightClick()
	if ( self.Disabled ) then return end;

	self:SetText( "NONE" )
	self:SetValue( 0 )
end

function PANEL:SetSelectedNumber( iNum )
	self.m_iSelectedNumber = iNum
	self:ConVarChanged( iNum )
	self:UpdateText()
	self:OnChange( iNum )
end

function PANEL:Think()
	if ( input.IsKeyTrapping() && self.Trapping ) then
		if ( self.Disabled ) then return end;
		local code = input.CheckKeyTrapping()

		if ( code ) then
			if ( self.BadKeys[ code ] ) then 
				self:SetText( "NICHT ERLAUBT" );
				self:SetValue( 0 );
				return;
			end;

			if ( code == KEY_ESCAPE ) then
				self:SetValue( self:GetSelectedNumber() )
			else
				self:SetValue( code )
			end

			self.Trapping = false
		end
	end

	if self.Trapping == true or self:GetValue() == 0 then 
        self:SetFont( "HexSh.X" )
	else
        self:SetFont( "HexSh.X" )
	end

	self:ConVarNumberThink()
end

function PANEL:SetValue( iNumValue )
	self:SetSelectedNumber( iNumValue )
end

function PANEL:SetBadKey( key )
	// local code = input.CheckKeyTrapping()?

	self.BadKeys[ key ] = true;
end

function PANEL:GetValue()
	return self:GetSelectedNumber()
end

function PANEL:OnChange()
end

function PANEL:SetDisabled( bool )
	self.Disabled = bool;
end;


function PANEL:Paint( w, h )
	
	draw.RoundedBox( 4, 0, 0, w, h, HexSh.adminUI.Color.bgLightGray );

	if ( self.Disabled ) then 
		draw.RoundedBox( 4, 2, 2, w, h, Color( red[ "a" ], red[ "g" ], red[ "b" ], 90 ) );
	end;
end;

vgui.Register( "HexSh.UI.Binder", PANEL, "DBinder" )