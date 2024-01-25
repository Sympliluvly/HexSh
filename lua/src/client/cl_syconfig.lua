// _Hexagon Crytpics_
// Copyright (c) 2023 Hexagon Cryptics, all rights reserved
//---------------------------------------\\
// Script: Shared (base)
// src(id): sh
// Module of: - 
//
// Do not edit this base by yourself, 
// because all functions are needed for
// our script!!!!
//---------------------------------------\\
// AUTHOR: Tameka aka 0v3rSimplified
// CO's: -
// Licensed to: -
//---------------------------------------\\

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


