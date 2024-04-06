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


--[[------------------------------------- 
            (  SQL TABLE )
]]----------------------------------------
local query_sqltie = [[
    CREATE TABLE IF NOT EXISTS HexSh_debug (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        src VARCHAR(100),
        message TEXT,
        Date DATE,
        Time CHAR(8)
    );
]] 

local query_mysql = [[
    CREATE TABLE IF NOT EXISTS HexSh_debug (
        id INTEGER PRIMARY KEY AUTO_INCREMENT,
        src VARCHAR(100),
        message TEXT,
        Date TEXT,
        Time CHAR(8)
    );
]]
HexSh.SQL:Query(HexSh.SQL:UsingMySQL() && query_mysql or query_sqltie,function()end,nil) 

net.Receive("HexSh:ReadDebugLogs",function(len,ply)
    if !ply:HC_hasPermission("Debug") then return end 

    local query = "SELECT * FROM HexSh_debug LIMIT 100"
    HexSh.SQL:Query(query,function(data)
        if !data then data = {} end
        net.Start("HexSh:ReadDebugLogs")
            HexSh:WriteCompressedTable(data)
        net.Send(ply)
    end,nil)
end) 

function HexSh:LOG(src,title,msg)
    local date = os.date("%Y-%m-%d")
    local time = os.date("%H:%M:%S")
    local query = "INSERT INTO HexSh_debug (src,message,Date,Time) VALUES ('"..src.."','"..msg.."','"..date.."','"..time.."')"
    HexSh.SQL:Query(query,function()end,nil)
end
HexSh:LOG("src_sh","Wer ist cool","ich bin coola als justin!")






