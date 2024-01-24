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
util.AddNetworkString("HexSh:ReadDebugLogs")
-------------------------------------------

net.Receive("HexSh:ReadDebugLogs",function(len,ply)
    if !ply:HC_hasPermission("Debug") then return end 

    local file = file.Read("hexsh/debug.json","DATA")
    net.Start("HexSh:ReadDebugLogs")
        HexSh:WriteCompressedTable(util.JSONToTable(file))
    net.Send(ply)
end)

function HexSh:LOG(src,msg)
    local Timestamp = os.time()
    local TimeString = os.date( "%d/%m/%Y-%H:%M:%S", Timestamp )
    if !file.Exists("hexsh/debug.json","DATA") then
        file.Write("hexsh/debug.json", util.TableToJSON({}))
    end
    local debugfile = util.JSONToTable(file.Read("hexsh/debug.json","DATA"))
    table.insert(debugfile,"["..TimeString.."] [".. src .. "] ~" .. msg )

    file.Write("hexsh/debug.json",util.TableToJSON(debugfile,true))
end



















