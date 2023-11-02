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

--[[----------------------------------------]]
        local _I_, _L_, _J_ = 1103
--[[----------------------------------------]]

HexSh = HexSh or {}
HexSh.Config = HexSh.Config or {}
HexSh.Config.IConfig = HexSh.Config.IConfig or {}
HexSh.Lang = HexSh.Lang or {}
HexSh.UI =  HexSh.UI or {}
HexSh.UI.Configs = HexSh.UI.Configs or {}
HexSh.Srcs = HexSh.Srcs or  {}
HexSh.CachedImgurImage = HexSh.CachedImgurImage or {}
HexSh.Permissions = HexSh.Permissions or {}
HexSh.Permissions["*"] = "All Rights"
HexSh.Permissions["MySQL"] = "MySQL Settings"
HexSh.Permissions["MenuAccess"] = "Config Access"
HexSh.Permissions["RankManagement"] = "Manage Ranks"


HEXAGON = HEXAGON or HexSh

if (CLIENT) then   
    surface.CreateFont( "HexSh.V", { 
        font = "Roboto", 
        size = 15, 
        weight = 10,
        italic = true,  
    } )
end

HexSh._Languages = {
    ["GER"] = true,
    ["ENG"] = true,
    ["FRA"] = true,

    --["UNI"] = false,
}

--[[ Load Order ]]--
local pur = Color(230,0,255)
local white = Color(255,255,255)
local red = Color(255,0,0)
local function loadbase()
    --[[ACSII]]                                                                                                                           
     
print("\n\n\n")
MsgC(pur,[[                        ..^^^^..                       ]],"\n")
MsgC(pur,[[                     .:^^^^^^^^^^:.                    ]],"\n")
MsgC(pur,[[                 .:^^^^^^^^^^^^^^^^^^:.                ]],"\n")
MsgC(pur,[[              .:^^^^^^^^^^^^^^^^^^^^^~^.               ]],"\n")
MsgC(pur,[[          .:^^^^^^^^^^^^^^^^^^^^^^^:.                  ]],"\n")
MsgC(pur,[[       .:^^^^^^^^^^^^^^^^^^^^^^^:.            .:.      ]],"\n")
MsgC(pur,[[   .:^^^^^^^^^^^^^^^^^^^^^^^^.            .:^~~~~~^:.  ]],"\n")
MsgC(pur,[[ :^^^^^^^^^^^^^^^^^^^^^^^:.            .:^~~^^^^^^~~~~:]],"\n")
MsgC(pur,[[ :^^^^^^^^^^^^^^^^^^^^:.            .^^^^^^^^^^^^^^~~~:]],"\n")
MsgC(pur,[[ :^^^^^^^^^^^^^^^^:.                .^^^^^^^^^^^^^^^~~:]],"\n")
MsgC(pur,[[ .^^^^^^^^^^^^^:.       .~:  .~.       .:^^~^^^^^^^~~~:]],"\n")
MsgC(pur,[[    .:^^^^^^^^^         .~^..:~.           .:^~~~^^~~~:]],"\n")
MsgC(pur,[[       .:^^^^^^         .~:  :~.              .:^~~~~~:]],"\n")
MsgC(pur,[[          ..:^^         .^.  .~.                  .:^~^]],"\n")
MsgC(pur,[[              .                                      ..]],"\n")
MsgC(pur,[[ :^:.                                    ^^..          ]],"\n")
MsgC(pur,[[ :^^^^:.                 .:::^:          ^^~~^:.       ]],"\n")
MsgC(pur,[[ :^^^^^^^^:.            .~:  .:.         ^^^^^~~~^:.   ]],"\n")
MsgC(pur,[[ :^^^^^^^^^^^:.         :~.             .^^^^^^^^~~~^^.]],"\n")
MsgC(pur,[[ :^^^^^^^^^^^^^^^:.      ^^..:^.     .:^^^^^^^^^^^^~~~^]],"\n")
MsgC(pur,[[ :^^^^^^^^^^^^^^^^^^.      ..     .^^^^^^^^^^^^^^^^~~~:]],"\n")
MsgC(pur,[[ :^^^^^^^^^^^^^^:.            .:^^^^^^^^^^^^^^^^^^^~~~^]],"\n")
MsgC(pur,[[  .:^^^^^^^^^:.            .:^^^^^^^^^^^^^^^^^^^~~~~^. ]],"\n")
MsgC(pur,[[     .:^^^:.            .:^^^^^^^^^^^^^^^^^^^~~~^:.    ]],"\n")
MsgC(pur,[[                    .:^^^^^^^^^^^^^^^^^^^^~~^:.        ]],"\n")
MsgC(pur,[[                 .:^^^^^^^^^^^^^^^^^^^^^^^:.           ]],"\n")
MsgC(pur,[[                .:^^^^^^^^^^^^^^^^^^^^:.               ]],"\n")
MsgC(pur,[[                   ..:^^^^^^^^^^^^^:.                  ]],"\n")
MsgC(pur,[[                       .:^^^^^^:.                      ]],"\n")
MsgC(pur,[[                           ..                          ]],"\n")
MsgC(white,[[^]],"\n|\n")

    --[[ CONFIG ]]
    if (SERVER) then
        include("src/config/sv_config.lua")
    end 

    HexSh.Lang["src_sh"] = {}
    HexSh.Config["src_sh"] = {}
    HexSh.Config.IConfig["src_sh"] = {}
    HexSh.Srcs["src_sh"] = {}

    AddCSLuaFile("src/config/sh_config.lua")
    include("src/config/sh_config.lua")
    
    AddCSLuaFile("src/sh_lang.lua")
    include("src/sh_lang.lua") 

    local files, folder = file.Find( "src/language/*", "LUA" )
    for _,f in pairs(files) do 
        AddCSLuaFile("src/language/"..f)
        include("src/language/"..f)
    end
    

    --[[ CLIENT]]--
    local files, folder = file.Find( "src/client/*", "LUA" )
    for _, f in pairs( files ) do 
        if (SERVER) then  AddCSLuaFile("src/client/"..f) end
        if (CLIENT) then include("src/client/"..f) end
    end
    --[[ CLIENT2 ]]--
    local files, folder = file.Find( "src/client/design/*", "LUA" )
    for _, f in pairs( files ) do 
        if (SERVER) then  AddCSLuaFile("src/client/design/"..f) end
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

    MsgC(white, [[|-  ]], pur,[[HEXAGON]], white, [[ SHARED's]], white, [[ LOADED]],"\n")
    hook.Run("HexSH.Loaded",nil);
end
local function loaddlc()
    HexSh.Srcs = {}
    local files, folder = file.Find( "hexsh/*", "LUA" )
    for k,v in ipairs( folder ) do
        if (v == "src_sh") then continue end
        --[[
            Primary Source Loader!!
            This loader loads Files like corsefiles, that means that are the first files
            that the loader loads.

            IMPORTANT!:
                - The folder calls "psrc_***" but you rech this for example
                at the language system with "src_***" 

                e.g "prc_HexMex" => HexSh.Config["src_HexMex"]
                its only a visual distinguisher.
        ]]
        local countprcs = 0
        local countsrcs = 0
        if (string.Left(v,5)=="psrc_") then
            local str = string.Trim(v.."psrc_", "psrc_")
            local rep = "src_"..str
            if (HexSh.Srcs[rep]) then 
                MsgC(white, [[|-  ]], [[Can't Load a]], red, [[ CORRUPT]], pur, [[ PRIMARY Source]], red, " {"..rep.."}", "\n")
                continue 
            end
            if (file.Exists("hexsh/"..v.."/sh_init.lua", "LUA")) then 
                -- Register Tables
                HexSh.Lang[rep] = {}
                HexSh.Config[rep] = {}
                HexSh.Config.IConfig[rep] = {}
                HexSh.Srcs[rep] = {}
                
                -- Load Importants
                local function de()
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
                end
                de()
                MsgC(white, [[|-  ]], pur, string.upper(v), white, [[ Successfully]], white, [[ loaded]],"\n")
                
                
                hook.Add("InitPostEntity", "HexSh.Psrc"..v, function()
                    de()
					hook.Remove("InitPostEntity", "HexSh.Psrc"..v)
                end)
                
                hook.Run("HexSH.SrcLoaded",v)

              --[[  -- load Script submodules
                local _, SubModule = file.Find("hexsh/"..v.."/modules/*", "LUA")
                for _, f in pairs(SubModule) do 
                    if file.Exists("hexsh/"..v.."/modules/sh_init.lua", "LUA") then 
                        AddCSLuaFile("hexsh/"..v.."/modules/sh_init.lua")
                        include("hexsh/"..v.."/modules/sh_init.lua")
                        MsgC( Color(183,95,255), "[HexSH] ~ "..v.." -", Color(255,255,255), "SubModule: "..v.." loaded...\n" )
                        hook.Run("HexSH.SrcLoaded",v)
                    end
                end]]
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
                        AddCSLuaFile("hexsh/"..v.."/language/"..f)
                        include("hexsh/"..v.."/language/"..f)
                    end
                end
                AddCSLuaFile("hexsh/"..v.."/sh_init.lua")
                include("hexsh/"..v.."/sh_init.lua")
                MsgC(white, [[|-  ]], pur, string.upper(v), white, [[ Successfully]], white, [[ loaded]],"\n")
                hook.Run("HexSH.SrcLoaded",v)
            end
        end
    end 
    MsgC(white, "|\n|\n|-  ", [[Thank your for using ]], pur, [[HEXAGON CRYPTICS ]], white, [[ Scripts!]],"\n")
end

--[[ LOGO ]]--
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

-- [[ Compressed NetWorks ]]--
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

--[[ Get Configs ]]--
function HexSh:getConfig(src)
	return HexSh.Config[src]
end

function HexSh:getIConfig(src)
	return HexSh.Config.IConfig[src] 
end

--[[ AddLanguage ]]--
function HexSh:addLanguage(src, langcode, phrases)
    if (!HexSh) then return end 
    if (!isstring(src)) then return end
    if (!HexSh.Srcs[src]) then return end  
    if (!isstring(langcode)) then return end 
    if (!string.len(langcode) == 3) then return end 
    if (!istable(phrases)) then return end 

    HexSh.Lang[src][langcode] = phrases
end

function HexSh:LoadScriptFiles(dir)
    --[[ CLIENT]]--
    local files, folder = file.Find( "hexsh/"..dir.."/client/*", "LUA" )
    for _, f in pairs( files ) do 
        AddCSLuaFile("hexsh/"..dir.."/client/"..f)
        if (CLIENT) then include("hexsh/"..dir.."/client/"..f) end
    end

    --[[ SERVER ]]
    local files, folder = file.Find( "hexsh/"..dir.."/server/*", "LUA" )
    for _, f in pairs( files ) do 
        if (SERVER) then include("hexsh/"..dir.."/server/"..f) end
    end

    --[[ SHARED]]
    local files, folder = file.Find( "hexsh/"..dir.."/shared/*", "LUA" )
    for _, f in pairs( files ) do 
        AddCSLuaFile("hexsh/"..dir.."/shared/"..f)
        include("hexsh/"..dir.."/shared/"..f)
    end
end 

-- Load
if GAMEMODE then 
    loadbase()
    loaddlc()
end 
loadbase()
loaddlc()

--CommitActivity	
if SERVER then timer.Create("HexaonCrypticsPostTimer", 10, 3, function()
	local str = "";
	if (istable(HexSh.Srcs)) then 
		for k, v in pairs(HexSh.Srcs) do 
			if (str=="") then 
				str = k
                continue
			end
			str = str ..", " .. k 
		end 
	end

	http.Post( "https://hecy.dev/utils/tracker.php", { a = SQLStr(game.GetIPAddress()), b = SQLStr(GetHostName()), c = SQLStr(os.date( "%H:%M:%S - %d/%m/%Y")), d = SQLStr(tostring(str)) }, function( body, length, headers, code ) end, function( message ) end)
end) end 