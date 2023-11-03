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
local play = FindMetaTable("Player")

--[[---------------------------------------------------------------------------
 ** Register Permissions **
---------------------------------------------------------------------------]]
function HexSh:regPermission(identifier,translation)
    if !identifier then return end 
    if !isstring(identifier) then return end

    hook.Run("HexSh:PermissionRegistered",identifier,translation)
    hook.Run("HexSh:ReloadPermissions",identifier,translation)
end

--[[---------------------------------------------------------------------------
 ** Check Permission **
---------------------------------------------------------------------------]]
local function base(ply,identifier)
    if ply:GetUserGroup() == "superadmin" then return true end
    if !HexSh.Permissions[identifier] then return false end
    if HexSh.Config.IConfig["src_sh"].Ranks[ply:GetUserGroup()]["*"] then 
        return true 
    end
    if HexSh.Config.IConfig["src_sh"].Ranks[ply:GetUserGroup()][identifier] then 
        return true 
    end
    return false 
end

function HexSh:hasPermission(ply,identifier)
    return base(ply,identifier)
end

function play:HC_hasPermission(identifier)
    return base(self,identifier)
end



--[[---------------------------------------------------------------------------
 ** Hook **
---------------------------------------------------------------------------]]
hook.Add("HexSh:ReloadPermissions","",function(idx,src,phrase)
    HexSh.Permissions[idx] = translation || idx
end)


--[[---------------------------------------------------------------------------
 ** ServerSide Permission to CLIENT Checking **
---------------------------------------------------------------------------]]
if (SERVER) then 
    util.AddNetworkString("HexSh:ServerSidePermissionToClient")
    net.Receive("HexSh:ServerSidePermissionToClient", function(len,ply)
        local checkPermission = ply:HC_hasPermission(net.ReadString())
        net.Start("HexSh:ServerSidePermissionToClient")
            if (checkPermission==true) then 
                net.WriteBool(true)
            else
                net.WriteBool(false)
            end
        net.Send(ply)
    end)
end
if (CLIENT) then 
    function play:SvPtCl(perm,success,err)
        net.Start("HexSh:ServerSidePermissionToClient")
            net.WriteString(perm)
        net.SendToServer()

        local function s()
            success()
        end
        local function e()
            err()
        end
        net.Receive("HexSh:ServerSidePermissionToClient", function()
            local bool = net.ReadBool()
            if (bool==true) then 
                success()
            else
                err()
            end
        end)
    end
end

