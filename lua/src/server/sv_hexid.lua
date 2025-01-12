// This is a System for better Player Management
-- ---------------------------------------------------------------------------]]
--
include("src/server/sql.lua")
// player meta Table
local meta = FindMetaTable("Player")


// Initialize HexID
HexID = HexID or {}
HexID.Player = HexID.Player or {} 

-- initialize SQL preparation
local Query = [[
    CREATE TABLE IF NOT EXISTS hexid (
        steamid64 VARCHAR(17) NOT NULL PRIMARY KEY,
        steamid VARCHAR(255) NOT NULL,
        registration DATE,
        lastlogin DATE,
    );

    CREATE TABLE IF NOT EXISTS hexid_diff (
        steamid64 VARCHAR(17) NOT NULL PRIMARY KEY,
        src_index VARCHAR(255) NOT NULL,
        uniqueID TEXT NOT NULL,
    );
]]

-- Auth Player
local function auth(ply)
    if ply.hexid_isAuth then return end
    ply.hexid_isAuth = false
    print("Authenticating Player: "..ply:Nick())

    local steamid = ply:SteamID()
    local steamid64 = ply:SteamID64()
    local query = [[
        SELECT * FROM hexid WHERE steamid64 = %s;
    ]]
    query = string.format(query, steamid64)

    HexSh.SQL:Query(query,function(result)
        if !result then
            local query = [[
                INSERT INTO hexid (steamid64, steamid, registration, lastlogin) VALUES (%s, %s, %s, %s);
                
            ]]
            local scndQuery = [[
                INSERT INTO hexid_diff (steamid64, src_index, uniqueID) VALUES (%s, %s, %s);
            ]]
            query = string.format(query, steamid64, steamid, os.date("%Y-%m-%d"), os.date("%Y-%m-%d"))
            scndQuery = string.format(scndQuery, steamid64, "src_sh", steamid)
    
            HexSh.SQL:Query(query,function() end,function() end)
            HexSh.SQL:Query(scndQuery,function() end,function() end)
    
        else 
            local query = [[
                UPDATE hexid SET lastlogin = %s WHERE steamid64 = %s;
            ]]
            query = string.format(query, os.date("%Y-%m-%d"), steamid64)
            HexSh.SQL:Query(query,function() end,function() end)
        end
        HEXID.Player[steamid64] = HEXID.Player[steamid64] or {}

        local query = [[
            SELECT * FROM hexid_diff WHERE steamid64 = %s;
        ]]
        HexSh.SQL:Query(string.format(query,steamid64),function(data)
            if !data then return end 
    
            for k,v in pairs(data) do 
                HEXID.Player[steamid64][v.src_index] = v.uniqueID
            end 
        end,function() end)    
    end,function() end)
end
hook.Add("PlayerSpawn", "HEXID:PlayerAuthentication", auth)


-- get methods

// Get Pure SteamID64
-- @return string
-- if FAILS @return nil
function meta:HexID()
    if !HexID then return false end 
    if !HexID.Player then return false end
    if !HexID.Player[self:SteamID64()] then return false end
    if !HexID.Player[self:SteamID64()]["src_sh"] then return false end
    return HEXID.Player[self:SteamID64()]["src_sh"]
end


// Get UniqueID from Source
-- @meta Player
-- @param string src 
-- if FAILS @return nil
function meta:getHexID(src)
    if !HexID then return false end 
    if !HexID.Player then return false end
    if !HexID.Player[self:SteamID64()] then return false end
    if !HexID.Player[self:SteamID64()][src] then return false end
    return HEXID.Player[self:SteamID64()][src]
end 


-- register methods

// Register a new Source
-- @meta Player
-- @param string src
