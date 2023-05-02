--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]

--[[----------------------------------------]]
             local _I_, _L_, _J_ = 1103
--[[----------------------------------------]]

HexSh = HexSh or {}
HexSh.DL = "github"
HexSh.Config = HexSh.Config or {}
HexSh.Config.IConfig = HexSh.Config.IConfig or {}
HexSh.Lang = HexSh.Lang or {}
HexSh.UI =  HexSh.UI or {}
HexSh.UI.Configs = HexSh.UI.Configs or {}
HexSh.Srcs = HexSh.Srcs or  {}
HexSh.CachedImgurImage = HexSh.CachedImgurImage or {}
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
    --[[ CLIENT2 ]]--
    local files, folder = file.Find( "src/client/design/*", "LUA" )
    for _, f in pairs( files ) do 
        AddCSLuaFile("src/client/design/"..f)
        if (CLIENT) then include("src/client/design/"..f) end
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
    hook.Run("HexSH.Loaded",nil);
end
local function loaddlc()
    HexSh.Srcs = {}
    local files, folder = file.Find( "hexsh/*", "LUA" )
    for k,v in ipairs( folder ) do
        --[[
            Primary Source Loader!!
            This loader loads Files like corefiles, that means that are the first files
            that the loader loads.

            IMPORTANT!:
                - The folder calls "psrc_***" but you rech this for example
                at the language system with "src_***" 

                e.g "prc_HexMex" => HexSh.Config["src_HexMex"]
                its only a visual distinguisher

        ]]
        if (string.Left(v,5)=="psrc_") then 
            local str = string.Trim(v.."psrc_", "psrc_")
            local rep = "src_"..str
            if (HexSh.Srcs[rep]) then 
                MsgC( Color(183,95,255), "[HexSH] ~ ", Color(250,0,0), "[WARNING] - ", Color(255,255,255), rep .. " does already exist & blocks the PrimarySRC!!!\n" )
                continue 
            end
            if (file.Exists("hexsh/"..v.."/sh_init.lua", "LUA")) then 
                -- Register Tables
                HexSh.Lang[rep] = {}
                HexSh.Config[rep] = {}
                HexSh.Config.IConfig[rep] = {}
                HexSh.Srcs[rep] = {}
                
                -- Load Importants
                if (file.Exists("hexsh/"..v.."/sh_iconfig.lua", "LUA")) then 
                    AddCSLuaFile("hexsh/"..v.."/sh_iconfig.lua")
                    include("hexsh/"..v.."/sh_iconfig.lua")
                end
                if (file.Exists("hexsh/"..v.."/sh_config.lua", "LUA")) then 
                    AddCSLuaFile("hexsh/"..v.."/sh_config.lua")
                    include("hexsh/"..v.."/sh_config.lua")
                end
                if (file.Exists("hexsh/"..v.."/language/eng.lua","LUA")) then 
                    local ffiles, ffolder = file.Find( "hexsh/"..v.."/language/*", "LUA" )
                    for _, f in pairs( ffiles ) do 
                        AddCSLuaFile("hexsh/"..v.."/language//"..f)
                        include("hexsh/"..v.."/language/"..f)
                    end
                end

                -- load Script
                AddCSLuaFile("hexsh/"..v.."/sh_init.lua")
                include("hexsh/"..v.."/sh_init.lua")
                MsgC( Color(183,95,255), "[HexSH] ~ Primary -", Color(255,255,255), v .. " loaded...\n" )
                hook.Run("HexSH.SrcLoaded",v)

                -- load Script submodules
                local _, SubModule = file.Find("hexsh/"..v.."/modules/*", "LUA")
                for _, f in pairs(SubModule) do 
                    if file.Exists("hexsh/"..v.."/modules/sh_init.lua", "LUA") then 
                        AddCSLuaFile("hexsh/"..v.."/modules/sh_init.lua")
                        include("hexsh/"..v.."/modules/sh_init.lua")
                        MsgC( Color(183,95,255), "[HexSH] ~ "..v.." -", Color(255,255,255), "SubModule: "..v.." loaded...\n" )
                        hook.Run("HexSH.SrcLoaded",v)
                    end
                end
            end
        end

        if ( string.Left(v, 4 ) == "src_" ) then
            if (file.Exists("hexsh/"..v.."/sh_init.lua", "LUA")) then 
                if (HexSh.Srcs[v]) then 
                    MsgC( Color(183,95,255), "[HexSH] ~ ", Color(250,0,0), "[WARNING] - ", Color(255,255,255), v .. " does already exist!!\n" )
                    continue 
                end
                HexSh.Lang[v] = {}
                HexSh.Config[v] = {}
                HexSh.Config.IConfig[v] = {}
                HexSh.Srcs[v] = {}
                if (file.Exists("hexsh/"..v.."/sh_iconfig.lua", "LUA")) then 
                    AddCSLuaFile("hexsh/"..v.."/sh_iconfig.lua")
                    include("hexsh/"..v.."/sh_iconfig.lua")
                end
                if (file.Exists("hexsh/"..v.."/sh_config.lua", "LUA")) then 
                    AddCSLuaFile("hexsh/"..v.."/sh_config.lua")
                    include("hexsh/"..v.."/sh_config.lua")
                end
                if (file.Exists("hexsh/"..v.."/language/eng.lua","LUA")) then 
                    local ffiles, ffolder = file.Find( "hexsh/"..v.."/language/*", "LUA" )
                    for _, f in pairs( ffiles ) do 
                        print(f)
                        AddCSLuaFile("hexsh/"..v.."/language/"..f)
                        include("hexsh/"..v.."/language/"..f)
                    end
                end
                AddCSLuaFile("hexsh/"..v.."/sh_init.lua")
                include("hexsh/"..v.."/sh_init.lua")
                MsgC( Color(183,95,255), "[HexSH] ~ Primary -", Color(255,255,255), v .. " loaded...\n" )
                hook.Run("HexSH.SrcLoaded",v)
            end
        end
    end 
end

-- LOGO
if (CLIENT) then
    if ( !file.Exists( "hexsh/cache/img/BmestJw.png", "DATA" ) ) then 
        http.Fetch( "https://i.imgur.com/BmestJw.png", function( Body, Len, Headers )     
            file.Write( "hexsh/cache/img/BmestJw.png", Body )
            HexSh.CachedImgurImage[ "BmestJw" ] = Material( "data/hexsh/cache/img/BmestJw.png", "noclamp smooth");
        end)
    else
        HexSh.CachedImgurImage[ "BmestJw" ] = Material( "data/hexsh/cache/img/BmestJw.png", "noclamp smooth" )
    end
end

-- Compressed NetWorks
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

-- Get Configs
function HexSh:getConfig(src)
	return HexSh.Config[src]
end

function HexSh:getIConfig(src)
	return HexSh.Config.IConfig[src] 
end

--AddLanguage
function HexSh:addLanguage(src, langcode, phrases)
    if (!HexSh) then return end 
    if (!isstring(src)) then return end
    if (!HexSh.Srcs[src]) then return end  
    if (!isstring(langcode)) then return end 
    if (!string.len(langcode) == 3) then return end 
    if (!istable(phrases)) then return end 

    HexSh.Lang[src][langcode] = phrases
end


loadbase()
loaddlc()
