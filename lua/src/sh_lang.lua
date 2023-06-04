--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]

function HexSh:L(srcname, phrase)
    if (HexSh.Lang[srcname][ HexSh.Config.IConfig["src_sh"].Language ][ phrase] == nil) then return tostring(phrase) end;
    return tostring( HexSh.Lang[srcname][HexSh.Config.IConfig["src_sh"].Language ][ phrase] );
end;

function HexSh:FindPlayer(info)
    if not info or info == "" then return nil end
    local pls = player.GetAll()

    for k = 1, #pls do -- Proven to be faster than pairs loop.
        local v = pls[k]
        if tonumber(info) == v:UserID() then
            return v
        end

        if info == v:SteamID() then
            return v
        end

        if string.find(string.lower(v:Nick()), string.lower(tostring(info)), 1, true) ~= nil then
            return v
        end

        if string.find(string.lower(v:SteamName()), string.lower(tostring(info)), 1, true) ~= nil then
            return v
        end
    end
    return nil
end

 
