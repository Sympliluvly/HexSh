--

local PANEL = {}
local Color = Color 
local white = Color(255,255,255)
local gray = Color(102,102,102)
local lightgray = Color(236,236,236)
local blue = Color(81,175,242)
local black = Color(0,0,0)
local green = Color(21,139,52,164)
local toDecimal = function( x ) return ( ( x <= 100 ) && x || 100 ) * 0.01 end;
local roll, click = "hexsh/src_chars/roll.mp3", "hexsh/src_chars/inputclick.mp3"
local getAlpha = function( col, a ) return Color( col[ "r" ], col[ "g" ], col[ "b" ], a ) end;
local cfg = HexSh.Config["src_chars"]

local function drawCircle( x, y, radius, seg ) --Credit to wiki
    local cir = {}

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )

    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad( 0 ) -- This is needed for non absolute segment counts
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    surface.DrawPoly( cir )
end;

function PANEL:Init()

    self.minValue = 0
    self.maxValue = 10


    local p = vgui.Create( "DPanel", self );
        p:Dock(FILL)
        p:DockMargin(0,0,0,0)
        p.slideAmount = self.minValue; 

        p.ErrorLerp = HexSh:Lerp( 0, 0, 0.5 );

        p.OnError = function( bool )      
            if ( bool ) then 
                p.ErrorLerp = HexSh:Lerp( 0, 255, 0.5 );
                p.ErrorLerp:DoLerp();
            else
                p.ErrorLerp = HexSh:Lerp( 255, 0, 0.5 );
                p.ErrorLerp:DoLerp();
            end;
        end;


        p.Paint = function(s, w, h)
            s.ErrorLerp:DoLerp();
            local slideAmountPixel = math.Clamp( w / 100 * ( s.slideAmount ) - h / 2, h / 2, w - ( h / 2 ) );

            --Draw background and rounded edges
            draw.RoundedBox( 15, h / 2, h / 2 - 5, w - h, 10, black );
            draw.NoTexture();
            surface.SetDrawColor( black );
            
            --Draw the color section
            draw.RoundedBox( 15, h / 2, h / 2 - 5, slideAmountPixel - ( h / 2 ), 10, white );	
            draw.NoTexture();
            surface.SetDrawColor(s.ErrorLerp:GetValue() > 1 && Color(250,0,0,s.ErrorLerp:GetValue()) || white);

            if ( s.ErrorLerp:GetValue() >= 255 ) then 
                s.OnError( false );
            end;

            --Slider end
            surface.SetDrawColor( s.ErrorLerp:GetValue() > 1 && Color(250,0,0,s.ErrorLerp:GetValue()) || white );
            drawCircle( slideAmountPixel, h / 2, ( h / 3 ), 16 );

            surface.SetDrawColor( s.ErrorLerp:GetValue() > 1 && Color(250,0,0,s.ErrorLerp:GetValue()) || white );
            drawCircle( slideAmountPixel, h / 2, ( h / 3 ), 16 );
        end;
        p.PerformLayout = function( s, w, h)
            s.sliderButton:SetSize( w, h );
        end;
        self.slider = p
    -->

	local sliderButton = vgui.Create( "DButton", p );
        sliderButton:SetText( "" );
        sliderButton.skipFrames = 0; --Skip frames are used becuase gui uses cached results
        sliderButton.Paint = function() end; --Hide button
        sliderButton.OnMousePressed = function( s, keycode )
            if keycode == MOUSE_LEFT then
                s.sliding = true;
                s.skipFrames = 1;
            end;
        end;
        sliderButton.Think = function( s )
            if s.skipFrames > 0 then
                s.skipFrames = s.skipFrames - 1;
            else
                if not input.IsMouseDown( MOUSE_LEFT ) and s.sliding then
                    s.sliding = false;		
                end;
            end; 		
            if s.sliding && input.IsMouseDown( MOUSE_LEFT ) then
                --Work out new slider position
                local x, y = s:ScreenToLocal( gui.MouseX(), gui.MouseY() );

                local newSlidePos = ( 100 / s:GetWide() ) * math.Clamp( x + ( p:GetTall() / 2 ), 0, p:GetWide() ) 

                p.slideAmount = newSlidePos;

                self:OnValueChange( p.slideAmount / 100 * self.maxValue );
                self.NumEntry:SetText(math.Round(p.slideAmount / 100 * self.maxValue,1))
            end;
        end;
        p.sliderButton = sliderButton;
    -->

    self.NumEntry = vgui.Create("HexSh.UI.TextEntry", self)
        self.NumEntry:Dock(LEFT)
        self.NumEntry:SetWide(40)
        self.NumEntry:SetFont("DermaDefault")
        self.NumEntry:SetText(p.slideAmount)
        self.NumEntry:SetNumeric(true)
        function self.NumEntry:OnChange()
            p.slideAmount = self:GetValue()
        end
    -->
end

function PANEL:OnValueChange( val )
    -- Overwrite
end

function PANEL:Paint(w,h)

end


vgui.Register("HexSh.UI.Slider", PANEL, "DPanel")