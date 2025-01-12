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
util.AddNetworkString("HexSh:I:Start")
util.AddNetworkString("HexSh:I:GetState")
--------------------------------------------
-- prepared for more!
local stepa = {
    [1] = function(ply,tbl)
        file.CreateDir("hexsh")
        file.CreateDir("hexsh/config")
        file.CreateDir("hexsh/cache")
        file.Write("hexsh/sql.json",util.TableToJSON({
            mysql = false,
            host = HexSh_Encrypt(" "),
            username = HexSh_Encrypt(" "),
            password = HexSh_Encrypt(" "), 
            schema = HexSh_Encrypt(" "),
            port = HexSh_Encrypt("3306"),
        }))

        file.Write("hexsh/config/src_sh.json", util.TableToJSON(HexSh.Config.IConfig["src_sh"],true))

        net.Start("HexSh:I:GetState")
            net.WriteUInt(1,16)
        net.Send(ply)
        
        tbl[2](ply,tbl)
    end,
    [2] = function(ply,tbl)

        cookie.Set("HexSH.IsLIBReady",1)
        HexSh.isLIBready = 1
        net.Start("HexSh:I:GetState")
            net.WriteUInt(2,16)
        net.Send(ply)
    end,
}

--------------------------------------------
net.Receive("HexSh:I:Start",function(l,ply)
    net.Start("HexSh:I:Start")
        net.WriteUInt(#stepa,16)
    net.Send(ply)

    stepa[1](ply,stepa)
end)