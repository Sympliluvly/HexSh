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
DECLARATION OF SAM INTEGRATION! 
   If your server uses the SAM admin system and you have it configured 
   accordingly, the rank management will automatically be done via SAM!

   SAM Overwrites
        Permission: (HexSh:hasPermission) -> this function will use the Sam
        own permission check

        Vars: e.g "Debug" -> at sam will this permission known as "Hex_Debug"
---------------------------------------------------------------------------]]
 
--[[---------------------------------------------------------------------------
 ** Register Permissions **
---------------------------------------------------------------------------]]
function HexSh:regPermission(identifier,translation)
    if !identifier then return end 
    if !isstring(identifier) then return end

    if SAM and HexSh.Config.IConfig["src_sh"].sam_overtake == true then 
        local sam, command = sam, sam.command
        sam.permissions.add("Hex_"..identifier, "HexPermissions", "admin")
    end

    HexSh.Permissions[identifier] = translation
 
    hook.Run("HexSh:PermissionRegistered",identifier,translation)
    hook.Run("HexSh:ReloadPermissions",identifier,translation)
end

hook.Add("HexSH.Loaded", "HEX_SH_Loaded", function()
    HexSh:regPermission("*","All Rights") 
    HexSh:regPermission("MySQL","MySQL Settings")
    HexSh:regPermission("Debug","Debugging")
    HexSh:regPermission("MenuAccess","Config Access")
    HexSh:regPermission("RankManagement","Manage Ranks")
end)


--[[---------------------------------------------------------------------------
 ** Check Permission **
---------------------------------------------------------------------------]]
local function base(ply,identifier)
    
  --  if SAM and HexSh.Config.IConfig["src_sh"].sam_overtake == true then 
 --      return ply:HasPermission("Hex_"..identifier)
   -- end

    if ply:GetUserGroup() == "superadmin" then return true end
    if !HexSh.Permissions[identifier] then return false end
    if HexSh.Config.IConfig["src_sh"].Permissions[ply:GetUserGroup()] and HexSh.Config.IConfig["src_sh"].Permissions[ply:GetUserGroup()]["*"] then 
        return true 
    end
    if HexSh.Config.IConfig["src_sh"].Permissions[ply:GetUserGroup()] and HexSh.Config.IConfig["src_sh"].Permissions[ply:GetUserGroup()][identifier] then 
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

if CLIENT then
    print(LocalPlayer():HC_hasPermission("Debug"))
end

--[[---------------------------------------------------------------------------
 ** Hook **
---------------------------------------------------------------------------]]
hook.Add("HexSh:ReloadPermissions","",function(idx,src,phrase)
    HexSh.Permissions[idx] = translation || idx
end)

 
--[[--------------------------- ------------------------------------------------
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

