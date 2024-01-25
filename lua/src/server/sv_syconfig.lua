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

util.AddNetworkString("HexSh::LoadConfig")
util.AddNetworkString("HexSh::WriteConfig")
util.AddNetworkString("HexSh::OpenConfigMenu")
util.AddNetworkString("HexSh::CommunicateLoad")

local function FindTableDifferences(table1, table2, prefix)
    prefix = prefix or ""
    local e = {}

    for key, value in pairs(table1) do
        local fullKey = prefix .. '["' .. key .. '"]'
        if type(value) == "table" then
            if type(table2[key]) ~= "table" then
                local a = string.Split(prefix,'"]["')[1]
                local b = string.Split(a,'["')[2]
                table.insert(e,b)
            else
                FindTableDifferences(value, table2[key], fullKey)
            end
        elseif value ~= table2[key] then
            local a = string.Split(prefix,'["')[2]
            local b = string.Split(a,'"]')[1]
            table.insert(e,b)
        end
    end

    return e
end

local function Load(ply)
    local export = {}
       
    if (!file.Exists("hexsh/config.json", "DATA")) then
        file.CreateDir("hexsh")
        export = HexSh.Config.IConfig
    else
        export = util.JSONToTable(file.Read("hexsh/config.json", "DATA"))
        for k,v in pairs(export) do 
            HexSh.Config.IConfig[k] = v
        end 
    end

    net.Start("HexSh::LoadConfig")
        HexSh:WriteCompressedTable(HexSh.Config.IConfig)
    net.Send(ply)
end

net.Receive("HexSH::WriteConfig", function(len,ply)
    local readNewData = HexSh:ReadCompressedTable()
    local customPermission = net.ReadString()
    if (!ply:HC_hasPermission("MenuAccess")) then return end
    if customPermission && isstring(customPermission) && HexSh.Permissions[customPermission] then 
        if (!ply:HC_hasPermission(customPermission)) then return end
    end
    if (!file.Exists("hexsh/config.json", "DATA")) then
        file.CreateDir("hexsh")
        local cfgtbl = table.Copy(readNewData)

        file.Write("hexsh/config.json", util.TableToJSON(cfgtbl,true))
    else
        local cfgtbl = table.Copy(readNewData)
        file.Write("hexsh/config.json", util.TableToJSON(cfgtbl,true))
    end
    
    Load(ply)

    hook.Run("HexSh::CommunicateLoad", readNewData)
    net.Start("HexSh::CommunicateLoad")
        net.WriteTable(readNewData)
    net.Send(ply)
end)

--Msg(Color(250,0,0), "ICONFIG\n")
--PrintTable(HexSh.Config.IConfig)
--Msg(Color(250,0,0), "IngameCONFIG\n")
--PrintTable(util.JSONToTable(file.Read("hexsh/config.json", "DATA")))


net.Receive("HexSh::LoadConfig", function(len,ply)
    Load(ply)
end) 

net.Receive("HexSh::OpenConfigMenu", function(len,ply)
    if !ply:HC_hasPermission("MenuAccess") then 
        HexSh:Notify(ply,"error","You aren't accessed to this!s")
        return 
    end 

    net.Start("HexSh::OpenConfigMenu")
        net.WriteUInt(HexSh.isLIBready,2)
    net.Send(ply)
end)

local is_config_firsttime = false
hook.Add("PlayerSpawn","HexSh_ConfigLoad",function(ply)
    if (!ply.hexshinit) then     
        Load(ply)
        local c = {}
        for k,v in pairs(HexSh.Srcs) do 
            if !HexSh.Config.IConfig[k] then 
                continue 
            else
                table.insert(c,k)
            end
        end
        hook.Run("HexSh::CommunicateLoad", c)
        net.Start("HexSh::CommunicateLoad")
            net.WriteTable(c)
        net.Send(ply)
    end
    ply.hexshinit = false 
end)


