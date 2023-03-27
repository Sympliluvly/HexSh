--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]

--[[----------------------------------------]]
             local I, L, J = 1103
--[[----------------------------------------]]

HexSh = HexSh or {}
HexSh.Config = HexSh.Config or {}

if ( SERVER ) then include("autorun/server/sv_config.lua") end


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