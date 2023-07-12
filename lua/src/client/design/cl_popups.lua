-- ( WHITE )
local white = Color(255,255,255)
-- ( FONTS )

function HexSh.UI.DoPopup(title,sveButtonTitle,SaveFunction)
    if (!title) then title = "" end

    local bg = vgui.Create("EditablePanel")
    bg:SetSize(ScrW(),ScrH())
    bg:Center()
    bg:SetAlpha(0)
    bg:AlphaTo(255,0.3,0,nil)
    bg:MakePopup()
    bg.Paint = function(s,w,h)
        HexSh:drawBlurRect( 0, 0, w, h, 3, 6 )
    end
    
    local pop = vgui.Create("DPanel",bg)
    pop:SetSize(350,500)
    pop:Center()
    pop:DoModal()
    pop:SetAlpha(0)
    pop:AlphaTo(255,0.3,0,nil)
    pop.Paint = function(s,w,h)
        draw.RoundedBox(16,0,0,w,h,HEXAGON.Col.purple)
        draw.RoundedBox(16,2,2,w-4,h-4,HEXAGON.Col.bgGray2)

        draw.SimpleText(title, "HexSh.UI.27", HexSh:toDecimal(4) * pop:GetWide(), 10, white)
    end
    local close = vgui.Create("DButton",pop)
    close:SetSize(40,30)
    close:SetPos((HexSh:toDecimal(100)*pop:GetWide())-close:GetWide(),0)
    close:SetText("X")
    close:SetFont("HexSh.UI.27")
    close.Paint = function(s,w,h)
        if (s:IsHovered()) then draw.RoundedBoxEx(15,0,0,w,h,HEXAGON.Col.purple,false,true,false,false) end
    end
    close.DoClick = function(s)
        surface.PlaySound( "buttons/button14.wav" )
        pop:AlphaTo(0,0.3,0,nil)
        bg:AlphaTo(0,0.3,0,function()
            bg:Remove()
            pop:Remove()
        end)
    end
    
    pop.Field = vgui.Create("DScrollPanel", pop)
    pop.Field:Dock(FILL)
    pop.Field:DockMargin(5,HexSh:toDecimal(10)*pop:GetTall(),5,0)


    pop.remove = function() pop:AlphaTo(0,0.3,0,nil) bg:AlphaTo(0,0.3,0,function() bg:Remove() pop:Remove() end) end

    pop.AddField = function(title, tooltip, var, cf, kind )
        local p = vgui.Create("DPanel",pop.Field)
        p:Dock(TOP)
        p:DockMargin(5,2,5,3)
        p:SetTall( math.toDecimal(9) * pop:GetTall() )
        p:SetTooltip(tooltip)
        p.Paint = function( self,w,h )
            draw.RoundedBoxEx(7.5,0,0,w,h,HexSh.adminUI.Color.bgGray,true,true,true,true)
        end

        local t = vgui.Create("DLabel",p)
        t:SetText(title)
        t:SetTooltip("")
        t:SetFont("HexSh.UI.20")
        t:SetTextColor( white )
        t:Dock(LEFT)
        t:DockMargin(5,0,0,0)
        t:SizeToContents()

        if (kind=="text") then 
            local e = vgui.Create("HexSh.UI.TextEntry",p)
            e:Dock(RIGHT)
            e:DockMargin(0,5,5,5)
            e:SetText(var)
            e:SetPlaceholderText(title)
            e:SetFont("HexSh.UI.20")
            e:SetWide( math.toDecimal(40) * pop:GetWide() )
            e.OnEnter = function( self )
                cf = self:GetValue()
            end
        end
        if (kind=="dropdown") then 
            local e = vgui.Create("HexSh.UI.DropDown",p)
            e:Dock(RIGHT)
            e:DockMargin(0,5,5,5)
            e:SetText(var)
            e:SetFont("HexSh.UI.20")
            e:SetWide( math.toDecimal(60) * pop:GetWide() )
            e.OnEnter = function( self )
                cf = self:GetValue()
            end
            p.dropdown = e;
        end
        if (kind=="multitext") then 
            local e = vgui.Create("HexSh.UI.TextEntry",p)
            
            p:SetTall( math.toDecimal(35) * pop:GetTall() )
            t:Dock(TOP)
            t:DockMargin(5,0,0,0)

            e:Dock(FILL)
            e:DockMargin(5,5,5,5)
            e:SetText(var)
            e:SetPlaceholderText(title)
            e:SetFont("HexSh.UI.20")
            e:SetWide( math.toDecimal(50) * pop:GetWide() )
            e:SetMultiline(true)
            e.OnChange = function( self )
                cf = self:GetValue()
            end
        end
        if (kind=="color") then 
            local e = vgui.Create("DColorMixer",p)
            e:Dock(FILL)
            e:DockMargin(5,5,5,5)
            e:SetPalette(false)  			-- Show/hide the palette 				DEF:true
            e:SetAlphaBar(false) 			-- Show/hide the alpha bar 				DEF:true
            e:SetWangs(true) 				-- Show/hide the R G B A indicators 	DEF:true
            e:SetColor(Color(30,100,160)) 	-- Set the default color

            p:SetTall( math.toDecimal(45) * pop:GetTall() )
            t:Dock(TOP)
            t:DockMargin(5,0,0,0)
        end
        if (kind=="imgur") then 

            local e = vgui.Create("HexSh.UI.TextEntry",p)
            e:Dock(RIGHT)
            e:DockMargin(0,5,5,5)
            e:SetText(var)
            e:SetPlaceholderText(title)
            e:SetFont("HexSh.UI.20")
            e:SetWide( math.toDecimal(30) * pop:GetWide() )
            local pic = vgui.Create("DPanel",p)
            local picm = ""

            e.OnEnter = function( self )
                cf = self:GetValue()
                picm = self:GetValue()
            end

            pic:Dock(RIGHT)
            pic:DockMargin(0,5,5,5)
            pic:SetWide( 46 )
            pic.Paint = function(s,w,h)
                surface.SetDrawColor(white)
                surface.SetMaterial(HexSh:getImgurImage(picm))
                surface.DrawTexturedRect(0,0,w,h)
            end
        end
        if (kind=="switch") then 
            local e = vgui.Create("HexSh.Switch",p)
            e:Dock(RIGHT)
            e:DockMargin(0,math.toDecimal(29) * p:GetTall(),5,5)
            e:SetText("")
            e:SetChecked(var)
            e.OnChange = function( self )
                cf = self:GetChecked()
            end
        end
        if (kind=="permissionlines") then 
            local e = vgui.Create("DScrollPanel",p)
            e:Dock(FILL)
            e:DockMargin(5,5,5,5)
            local permissions = {}
            
            if (!cf || !istable(cf) && table.Count(cf) == 0 ) then 
                permissions = {}
            else
                permissions = cf
                for k,v in pairs(permissions) do 
                    p.AddPermission(k,vs)
                end
            end
            
            function p.AddPermission(name,bool)
                permissions[name] = bool
            end

            for k,v in pairs(permissions) do 
                --cf[k] = v 
                local _p = vgui.Create("DPanel",e)
                _p:Dock(TOP)
                _p:DockMargin(5,2,5,3)
                _p:SetTall( math.toDecimal(9) * pop:GetTall() )
                _p:SetTooltip(tooltip)
                _p.Paint = function( self,w,h )
                    draw.RoundedBox(8,0,0,w,h,HEXAGON.Col.purple)
                    draw.RoundedBox(8,2,2,w-4,h-4,HEXAGON.Col.bgGray2)
                end
        
                local _t = vgui.Create("DLabel",_p)
                _t:SetText(k)
                _t:SetTooltip("")
                _t:SetFont("HexSh.UI.20")
                _t:SetTextColor( white )
                _t:Dock(LEFT)
                _t:DockMargin(5,0,0,0)
                _t:SizeToContents()

                local _e = vgui.Create("HexSh.Switch",_p)
                _e:Dock(RIGHT)
                _e:DockMargin(0,math.toDecimal(29) * p:GetTall(),5,5)
                _e:SetText("")
                _e:SetChecked(v)
                _e.OnChange = function( self )
                    cf = self:GetChecked()
                end
        
                
            end


            function p.GetPermissions()
                return permissions
            end
            
            p:SetTall( math.toDecimal(45) * pop:GetTall() )
            t:Dock(TOP)
            t:DockMargin(5,0,0,0)


        end

        return p 
    end

    pop.FinishButton = vgui.Create("DButton",pop)
    pop.FinishButton:Dock(BOTTOM)
    pop.FinishButton:DockMargin(10,10,10,10)
    pop.FinishButton:SetTall(50)
    pop.FinishButton:SetText("SAVE")
    pop.FinishButton:SetFont("HexSh.UI.26")
    pop.FinishButton.Paint = function(s,w,h)
        draw.RoundedBox(8,0,0,w,h,HEXAGON.Col.purple)
        draw.RoundedBox(8,2,2,w-4,h-4,(s:IsHovered() && HEXAGON.Col.purple ) || HEXAGON.Col.bgGray2)
    end
    pop.FinishButton.DoClick = function(s)
        if (SaveFunction) then SaveFunction(pop) end
        surface.PlaySound( "buttons/button14.wav" )
        pop.remove()
    end
    --local FactionName = ""
    --local fac = field(pop, "Name", "", "", FactionName, "text")


    return pop 
end