--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]

function math.Between(a,b)
    return b-a
end

--Percent of something
function math.toDecimal(x)
    return ( ( x <= 100 ) && x || 100 ) * 0.01
end

function HexSh:toDecimal(x)
    return math.toDecimal(x)
end

--
function math.colorAlpha(col, a)
    return Color(col["r"], col["g"], col["b"], a)
end


--fresh imported from DarkRP UwU
function HexSh.findPlayer(info)
    if not info or info == "" then return nil end
    local pls = player.GetAll()

    for k = 1, #pls do -- Proven to be faster than pairs loop.
        local v = pls[k]

        if info == v:SteamID64() then
            return v
        end

        if string.find(string.lower(v:Nick()), string.lower(tostring(info)), 1, true) ~= nil then
            return v
        end
    end
    return nil
end