// Script made by Eve Haddox
// discord evehaddox

local PANEL = {}

function PANEL:Init()
    
    self.pos = {
        x = 0,
        y = 0
    }

    self.mousePos = {
        x = 0,
        y = 0
    }

    self.items = {} 
    self.itemsLog = {}
    self.IsDragging = false

    function self:OnMousePressed(code)
        if code == MOUSE_LEFT then
            self.IsDragging = true
            local mouseX, mouseY = self:CursorPos() 
            self.mousePos.x = mouseX
            self.mousePos.y = mouseY
        end
        if code == MOUSE_RIGHT then
            self.pos = {
                x = 0,
                y = 0
            }
            self.mousePos = {
                x = 0,
                y = 0
            }
        
            for k, v in pairs(self.items) do
                v:SetPos(self.itemsLog[k].x, self.itemsLog[k].y)
            end
        end
    end

    function self:OnMouseReleased(code)
        if code == MOUSE_LEFT then
            self.IsDragging = false
        end
        if code == MOUSE_RIGHT then
            self.pos = {
                x = 0,
                y = 0
            }
            self.mousePos = {
                x = 0,
                y = 0
            }
        
            for k, v in pairs(self.items) do
                v:SetPos(self.itemsLog[k].x, self.itemsLog[k].y)
            end
        end
    end

    function self:Think()


        if self.IsDragging then
            if mouseX == self.mousePos.x and mouseY == self.mousePos.y then return end
            local mouseX, mouseY = self:CursorPos()
            self.pos.x = self.pos.x + (mouseX - self.mousePos.x)
            self.pos.y = self.pos.y + (mouseY - self.mousePos.y)
            self.mousePos.x, self.mousePos.y = self:CursorPos()

            for k, v in pairs(self.items) do
                v:SetPos(self.pos.x + self.itemsLog[k].x, self.pos.y + self.itemsLog[k].y)
            end
        end
    end
end

function PANEL:addItem(id, x, y, w, h)
    
    self.itemsLog[id] = {
        x = x,
        y = y,
        w = w,
        h = h
    }

    self.items[id] = self:Add("DButton") // the item getting added to the panel
    self.items[id]:SetPos(self.pos.x + x, self.pos.y + y)
    self.items[id]:SetSize(w, h)

end

function PANEL:PerformLayout(w, h)
    
    self:Dock(FILL)

end

function PANEL:Paint(w, h)

end

vgui.Register("HexSh.InfiniteMenu", PANEL, "DPanel")

hook.Add("OnPlayerChat", "eve.techThreeMenu", function(ply, text, team, dead)

    if ply == LocalPlayer() and text == "!tt" then
        
        local frame = vgui.Create("DFrame")

        frame:SetSize(ScrW() * 0.8, ScrH() * 0.8)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("Eve's Tech Three")

        local main = frame:Add("HexSh.InfiniteMenu")
        main:Dock(FILL)

    end

end)