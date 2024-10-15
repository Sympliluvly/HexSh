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


--[[-----------------------------------------------
    network registers
---------------------------------------------]]--
util.AddNetworkString("HexSh::LoadConfig")
util.AddNetworkString("HexSh::WriteConfig")
util.AddNetworkString("HexSh::OpenConfigMenu")
util.AddNetworkString("HexSh::CommunicateLoad")

util.AddNetworkString("HexSh::Set")
util.AddNetworkString("HexSh::LoadSingleConfig")

--[[-----------------------------------------------
    Config loading functions
---------------------------------------------]]--
local function Load(ply)
    local export = {}
       
    for k,v in pairs( table.GetKeys(HexSh.Config.IConfig)) do 
        if (!file.Exists("hexsh/config/"..v..".json", "DATA")) then
            export[v] = HexSh.Config.IConfig[v]
        else
            export[v] = util.JSONToTable(file.Read("hexsh/config/"..v..".json", "DATA"))
            HexSh.Config.IConfig[v] = export[v]
        end
    end


    net.Start("HexSh::LoadConfig")
        HexSh:WriteCompressedTable(export)
    net.Send(ply)
end

function HexSh.loadConfig()
    local export = {}
       
    for k,v in pairs( table.GetKeys(HexSh.Config.IConfig)) do 
        if (!file.Exists("hexsh/config/"..v..".json", "DATA")) then
            export[v] = HexSh.Config.IConfig[v]
        else
            export[v] = util.JSONToTable(file.Read("hexsh/config/"..v..".json", "DATA"))
            HexSh.Config.IConfig[v] = export[v]
        end
    end

    PrintTable(export)

    net.Start("HexSh::LoadConfig")
        HexSh:WriteCompressedTable(export)
    net.Send(player.GetAll())
end

function HexSh.loadSingleConfig(src)
    --if !HexSh.Srcs[src] then return end 

    local export = {}
       
    if (!file.Exists("hexsh/config/"..src..".json", "DATA")) then
        export = HexSh.Config.IConfig[src]
    else
        export = util.JSONToTable(file.Read("hexsh/config/"..src..".json", "DATA"))
        HexSh.Config.IConfig[src] = export
    end

    net.Start("HexSh::LoadSingleConfig")
        net.WriteString(src)
        HexSh:WriteCompressedTable(export)
    net.Send(player.GetAll())
end


--[[-----------------------------------------------
    Write data into the Config
---------------------------------------------]]--
local runstr = RunString
local strform = string.format

function HexSh.Set(src,path,val)
    if !isstring(src) then return end 
    if !isstring(path) then return end 
    --if !isstring(val) then return end
    --if !HexSh.Srcs[src] then return end 
    
    local trim = path 
    trim = string.Split(trim,"/")
    path = "HexSh.Config.IConfig['"..src.."']"
    for i=1, #trim do 
        path = path .. "['"..trim[i].."']"

       /*if ( runstr( strform([[
            local a = %s
            if a==nil then
                error( "_", 1 )
            end
            
        ]],path), "check"..i, false ) == false ) then 
            error( trim[i].." arent available", 1 )
        end*/
    end

    if (isbool(val)) then 
        runstr(strform([[
            %s = %s
        ]],path,val),"Execute:ConfigSet:"..path,true)    
    elseif (isstring(val)) then
        runstr(strform([[
            %s = %q
        ]],path,val),"Execute:ConfigSet:"..path,true)
    elseif (istable(val)) then 
        val = util.TableToJSON(val)
        runstr(strform([[
            %s = util.JSONToTable(%q)
        ]],path,val),"Execute:ConfigSet:"..path,true)
    elseif (isnumber(val)) then 
        runstr(strform([[
            %s = %s
        ]],path,val),"Execute:ConfigSet:"..path,true)
    end 

    runstr(strform([[
        local a = %q
        print(a)
        file.Write("hexsh/config/"..a..".json",util.TableToJSON(HexSh.Config.IConfig[a],true))
        HexSh.loadSingleConfig(a)
    ]],src),"EXECUTE:SAVECONFIG:"..path)
end
 

--[[-----------------------------------------------
    network recieves
---------------------------------------------]]--
local curT = CurTime
net.Receive("HexSh::LoadConfig", function(len,ply)
    Load(ply)
end) 

local delay = 0
net.Receive("HexSh::Set", function(len,ply)
    if delay < curT() then 
        local permission = net.ReadString()
        if !ply:HC_hasPermission(permission) then 
            return 
        end
        HexSh.Set(net.ReadString(),net.ReadString(),net.ReadType())
    else
        return
    end
    delay = curT() + 0.3
end) 

net.Receive("HexSh::OpenConfigMenu", function(len,ply)
    print("dkkfjkfs")
   -- if !ply:HC_hasPermission("MenuAccess") then 
   --     HexSh:Notify(ply,"error","You aren't accessed to this!s")
   ---     return 
    --end 


    net.Start("HexSh::OpenConfigMenu")
        net.WriteUInt(HexSh.isLIBready,2)
    net.Send(ply)
end)

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
 
--HexSh.SQL:TestConnection("45.65.115.45", "el_neverhit_testa", "Fg7w*0d42", "el_neverhit_test", 3306)
 
--[[----------------------------------s
        ## Get Config Files ##
--]]----------------------------------
util.AddNetworkString("HexSh:getConfigFiles")
 
net.Receive("HexSh:getConfigFiles", function( len, ply )
    -- Permission akss
     
    local files,folder = file.Find("hexsh/config/*", "DATA")
    local export = {}
    for k,v in pairs(files) do
        export[v] = file.Read("hexsh/config/"..v, "DATA")
    end

    net.Start("HexSh:getConfigFiles")
        net.WriteTable(export)
    net.Send(ply)
end)  