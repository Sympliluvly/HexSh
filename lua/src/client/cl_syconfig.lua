--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
net.Receive("HexSh::LoadConfig", function()
    HexSh.Config.IConfig = HexSh:ReadCompressedTable()
end)

hook.Add("InitPostEntity", "HEXMENXLoadcfg", function()
    net.Start("HexSh::LoadConfig")
    net.SendToServer()
end)

net.Start("HexSh::LoadConfig")
net.SendToServer()

net.Receive("HexSh::CommunicateLoad", function()
    hook.Run("HexSh::CommunicateLoad",net.ReadTable())    
end)


--command
concommand.Add("hexmenu", function()
    net.Start("HexSh::OpenConfigMenu")
        net.WriteString("context")
    net.SendToServer()
end)