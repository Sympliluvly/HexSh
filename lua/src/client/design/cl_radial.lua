local soundClick = Sound('rdsrp/ui/click.ogg')
local soundHover = Sound('rdsrp/ui/hover.ogg')

local clrBlack = Color(0, 0, 0, 100)
local clrGray = Color(41, 41, 41, 200)
local clrWhite = Color(176,3,250)
local txtcolor = Color(255,255,255,255)

local function drawCircle(x, y, r, step, cache)
    local positions = {}

    for i = 0, 360, step do
        table.insert(positions, {
            x = x + math.cos(math.rad(i)) * r,
            y = y + math.sin(math.rad(i)) * r
        })
    end

    return (cache and positions) or surface.DrawPoly(positions)
end

local function drawSec(cx,cy,radius,thickness,startang,endang,roughness, cache)
	local triarc = {}
	-- local deg2rad = math.pi / 180
	
	-- Define step
	local roughness = math.max(roughness or 1, 1)
	local step = roughness
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	
	if startang > endang then
		step = math.abs(step) * -1
	end
	
	-- Create the inner circle's points.
	local inner = {}
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = math.rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(math.cos(rad)*r), cy+(-math.sin(rad)*r)
		table.insert(inner, {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end
	
	
	-- Create the outer circle's points.
	local outer = {}
	for deg=startang, endang, step do
		local rad = math.rad(deg)
		-- local rad = deg2rad * deg
		local ox, oy = cx+(math.cos(rad)*radius), cy+(-math.sin(rad)*radius)
		table.insert(outer, {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		})
	end
	
	
	-- Triangulize the points.
	for tri=1,#inner*2 do -- twice as many triangles as there are degrees.
		local p1,p2,p3
		p1 = outer[math.floor(tri/2)+1]
		p3 = inner[math.floor((tri+1)/2)+1]
		if tri%2 == 0 then --if the number is even use outer.
			p2 = outer[math.floor((tri+1)/2)]
		else
			p2 = inner[math.floor((tri+1)/2)]
		end
	
		table.insert(triarc, {p1,p2,p3})
	end
	
    if cache then
        return triarc
    else
        for k,v in pairs(triarc) do 
            surface.DrawPoly(v)
        end
    end
end

function HexSh.UI.RadialMenu(sections)
    local panel = {}
    local w, h = ScrW, ScrH
    local scale = h() / 900
    local calc = 325 * scale
    local rad = calc * 0.65
    local Section_w = 360 / #sections
    local pwa = w() * .5
    local pwh = h() * .5

    if IsValid(panel.panel) then
        panel.panel:Remove() 
    end

    panel.panel = vgui.Create('DButton')
    panel.panel:SetSize(w(), h())
    panel.panel:Center()
    panel.panel:MakePopup()
    panel.panel:SetCursor('hand')
    panel.panel.selectedArea = 0
    panel.panel:SetText('')
    panel.panel.selectedText = ''
    panel.panel:SetAlpha(0)
    panel.panel:AlphaTo(255,0.2,0,nil)

    function panel.panel:Think()
        if not sections[self.selectedArea + 1] then return end
        self.optselected = sections[self.selectedArea + 1]
    end

    function panel.panel:DrawMenu(w, h)
        local cursorAng = 360 - (math.deg(math.atan2(gui.MouseX() - pwa, gui.MouseY() - pwh)) + 180)
        local selectedArea = math.abs(cursorAng + Section_w * .5) / Section_w
        selectedArea = math.floor(selectedArea)

        if (selectedArea >= #sections) then
            selectedArea = 0
        end
        self.selectedArea = selectedArea
        
        local selectedAng = selectedArea * Section_w
		local outerArcScale = math.Round(4)

        draw.NoTexture()
        surface.SetDrawColor(clrWhite)

        drawSec(pwa, pwh, calc + outerArcScale, outerArcScale, 90 - selectedAng - Section_w * .5, 90 - selectedAng + Section_w * .5, 1, false)

        surface.SetDrawColor(clrBlack)
        drawSec(pwa, pwh, calc, rad, 90 - selectedAng - Section_w * .5, 90 - selectedAng + Section_w * .5, 1, false)

        surface.SetDrawColor(clrGray)
        drawCircle(pwa, pwh, calc - rad, 1, false)

        for i, v in pairs(sections) do
            local ang = (i - 1) * Section_w

            local radians = math.rad(ang)
            local size = (84 * scale)

            if (self.selectedArea and self.selectedArea + 1 == i) then
                size = (89 * scale)
            end

            local r = calc - rad * .45
            local sin = math.sin(radians) * r
            local cos = math.cos(radians) * r
            local x = pwa - size * .5 + sin
            local y = pwh - size * .6 - cos

            surface.SetDrawColor(Color(41, 41, 41, 150))
            draw.NoTexture()
            drawSec(pwa, pwh, calc, rad, 90 - ang - Section_w * .5, 90 - ang + Section_w * .5, 1, false)

            if v.icon != false then 
                surface.SetMaterial(HexSh:getImgurImage(v.icon))
                surface.SetDrawColor(v.col or txtcolor)
                surface.DrawTexturedRect(x, y-10, size, size)
            else
                draw.SimpleText(v.title, 'HexSh.UI.20', x, y, Color(255,255,255))
            end
        end

        draw.NoTexture() 
        surface.SetDrawColor(clrWhite)

        local innerArcScale = 6
        drawSec(pwa, pwh, calc - rad + innerArcScale * 2, innerArcScale, -cursorAng + 90 - Section_w * .5 - 0, -cursorAng + 90 + Section_w * .5, 1, false)
    end

    local offsetIconGroup = 55
    

    function panel.panel:Paint(w, h)
        panel.panel:DrawMenu(w, h)
        local cursorAng = 360 + (math.deg(math.atan2(gui.MouseX() - pwa, gui.MouseY() - pwh)) + 180)

        surface.SetMaterial(HexSh:getImgurImage("BmestJw"))
        surface.SetDrawColor(white)
        surface.DrawTexturedRectRotated(pwa, pwh, 128, 128,cursorAng)


        draw.SimpleText(self.optselected.title, 'HexSh.UI.29', pwa, pwh + 90, txtcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    function panel.panel:DoClick()
        if sections[self.selectedArea + 1].click then
            sections[self.selectedArea + 1].click(LocalPlayer())
        end 
        panel.panel:AlphaTo(0,0.2,0,function()
            self:Remove() 
        end)
    end

    function panel.panel:DoRightClick()
        panel.panel:AlphaTo(0,0.2,0,function()
            self:Remove() 
        end)
    end
end

HexSh.UI.CreateRadialMenu = {
    New = function(self)
        return setmetatable({options = {}}, {__index = HexSh.UI.CreateRadialMenu})
    end,

    AddOption = function(self, title, description, icon, click)
        local newOption = WheelMenuOption:New()

        newOption:SetTitle(title or '')
        newOption:SetDescription(description or '')
        newOption:SetIcon(icon)
        newOption:SetClick(click or function()
            
        end)

        self.options[#self.options + 1] = newOption

        return newOption
    end,

    Open = function(self)
        if #self.options == 0 then return end
        HexSh.UI.RadialMenu(self.options) 
    end
}

WheelMenuOption = {
    New = function(self)
        return setmetatable({subMenu = nil}, {__index = WheelMenuOption})
    end,
    AddSubOption = function(self, title, description, icon, click) 
        if self.subMenu then
            return self.subMenu:AddOption(title, description, icon, click)
        end

        self.subMenu = HexSh.UI.CreateRadialMenu:New() 

        self.click = function()
            self.subMenu:Open()
        end

        return self.subMenu:AddOption(title, description, icon, click)
    end, 
    SetTitle = function(self, value)
        self.title = value

        return self
    end,
    SetDescription = function(self, value)
        self.description = value

        return self
    end,
    SetIcon = function(self, value)
        
        self.icon = value

        return self
    end ,
    SetClick = function(self, value)
        self.click = value

        return self
    end 
}