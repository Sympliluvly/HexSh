--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
if (!HexSh) then return end
file.CreateDir( "hexsh/cache" );
file.CreateDir( "hexsh/cache/img" );
    
if ( !file.Exists( "hexsh/cache/img/zizhogv.png", "DATA" ) ) then 
    http.Fetch( "https://i.imgur.com/zizhogv.png", function( Body, Len, Headers )     
        file.Write( "hexsh/cache/img/zizhogv.png", Body )
        HexSh.CachedImgurImage[ "zizhogv" ] = Material( "data/hexsh/cache/img/zizhogv.png", "noclamp smooth");
    end)
else
    HexSh.CachedImgurImage[ "zizhogv" ] = Material( "data/hexsh/cache/img/zizhogv.png", "noclamp smooth" )
end

function HexSh:getImgurImage( ImgurID )
    if HexSh.CachedImgurImage[ ImgurID ] then
        return HexSh.CachedImgurImage[ ImgurID ]
    elseif file.Exists( "hexsh/cache/img/" .. ImgurID .. ".png", "DATA" ) then
        HexSh.CachedImgurImage[ ImgurID ] = Material( "data/hexsh/cache/img/" .. ImgurID .. ".png", "noclamp smooth" )
    else
        http.Fetch( "https://i.imgur.com/" .. ImgurID .. ".png", function( Body, Len, Headers )     
            file.Write( "hexsh/cache/img/" .. ImgurID .. ".png", Body )
            HexSh.CachedImgurImage[ ImgurID ] = Material( "data/hexsh/cache/img/" .. ImgurID .. ".png", "noclamp smooth");
        end)
    end
    return HexSh.CachedImgurImage[ "zizhogv" ]
end




local blur = Material("pp/blurscreen");

function HexSh:drawBlurRect( x, y, w, h, amount, density )
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(blur)
    for i = 1, density do
		blur:SetFloat( "$blur", ( i / 3 ) * ( amount or 6 ) )
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        render.SetScissorRect( x, y, x + w, y + h, true )
        surface.DrawTexturedRect( 0 * -1, 0 * -1, ScrW(), ScrH() )
        render.SetScissorRect( 0, 0, 0, 0, false )
    end
end

function HexSh:DrawCircle(x, y, r, col)

    local circle = {};

    for i = 1, 360 do

        circle[i] = {};

        circle[i].x = x + math.cos(math.rad(i * 360) / 360) * r;

        circle[i].y = y + math.sin(math.rad(i * 360) / 360) * r;

    end;

    surface.SetDrawColor(col);

    draw.NoTexture();

    surface.DrawPoly(circle);
    
end;

function HexSh:ClickAnimation( trad, speed, speed2, color )

    local data = {};

    local self = data;

    self.Rad, self.Alpha, self.ClickX, self.ClickY = 0, 0, 0, 0;

    function data:Click( me )

        self.ClickX, self.ClickY = me:CursorPos();

        self.Rad = 0;

        self.Alpha = color["a"];

    end;

    function data:Animate()

        if ( self.Alpha >= 1 ) then

            surface.SetDrawColor( Color( color["r"], color["g"], color["b"], 20 ) );

            draw.NoTexture();

            HexSh:DrawCircle( self.ClickX, self.ClickY, self.Rad, color );

            self.Rad = Lerp( FrameTime() * speed, self.Rad, trad || w );

            self.Alpha = Lerp( FrameTime() * speed2, self.Alpha, 0 );

        end;

    end;

    return data;
    
end