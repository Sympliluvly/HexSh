--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]

--[[----------------------------------------]]
             local _I_, _L_, _J_ = 1103
--[[----------------------------------------]]

HexSh = HexSh or {}
HexSh.DL = "github"
HexSh.Config = HexSh.Config or {}
HexSh.Lang = HexSh.Lang or {}
HEXAGON = HEXAGON or HexSh

local supportedlanguages = {
    ["ENG"] = true,
    ["GER"] = true,
    ["JAP"] = true,
    ["SPA"] = true,
};

--[[ Load Order ]]--
local function loadbase()
    --[[ CONFIG ]]
    if (SERVER) then
        include("src/config/sv_config.lua")
    end 

    AddCSLuaFile("src/config/sh_config.lua")
    include("src/config/sh_config.lua") 
    
    --[[ CLIENT]]--
    local files, folder = file.Find( "src/client/*", "LUA" )
    for _, f in pairs( files ) do 
        AddCSLuaFile("src/client/"..f)
        if (CLIENT) then include("src/client/"..f) end
    end
    --[[ SERVER ]]
    local files, folder = file.Find( "src/server/*", "LUA" )
    for _, f in pairs( files ) do 
        if (SERVER) then include("src/server/"..f) end
    end
    --[[ SHARED]]
    local files, folder = file.Find( "src/*", "LUA" )
    for _, f in pairs( files ) do 
        AddCSLuaFile("src/"..f)
        include("src/"..f)
    end
    hook.Call("HexSH.Loaded","",nil);
end
local function loaddlc()
    local files, folder = file.Find( "hexsh/*", "LUA" )
    for k,v in pairs( folder ) do
        if ( string.Left(v, 4 ) == "src_" ) then
            if (file.Exists("hexsh/"..v.."/sh_init.lua", "LUA")) then 
                HexSh.Lang[v] = {}
                HexSh.Config[v] = {}
                AddCSLuaFile("hexsh/"..v.."/sh_init.lua")
                include("hexsh/"..v.."/sh_init.lua")
                hook.Call("HexSH.SrcLoaded","",v)
            end
        end
    end 
end

loadbase()
loaddlc()

// Compressed NetWorks
function HexSh:WriteCompressedTable(table)
    local data = util.TableToJSON(table)
    data = util.Compress(data)
    net.WriteInt(#data, 32)
    net.WriteData(data, #data)
end


function HexSh:ReadCompressedTable()
    local num = net.ReadInt(32)
    local data = net.ReadData(num)
    return util.JSONToTable( util.Decompress(data) )
end
//\\

