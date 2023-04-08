--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
// Too Simple Config
util.AddNetworkString("HexSh::LoadConfig")
util.AddNetworkString("HexSh::WriteConfig")
util.AddNetworkString("HexSh::OpenConfigMenu")

net.Receive("HexSH::WriteConfig", function(len,ply)
    if (!ply:GetUserGroup() == "superadmin") then return end
    local readNewData = HexSh:ReadCompressedTable()

    if (!file.Exists("hexsh/config.json")) then
        file.CreateDir("hexsh")

        local cfgtbl = table.Copy(readNewData)
        cfgtbl["SERVER"] = nil

        file.Write("hexsh/config.json", util.TableToJSON(cfgtbl))
    else
        local cfgtbl = table.Copy(readNewData)
        cfgtbl["SERVER"] = nil

        file.Write("hexsh/config.json", util.TableToJSON(cfgtbl))
    end
    
    local cfgtbl = table.Copy(readNewData)
    cfgtbl["SERVER"] = nil

    net.Start("HexSh::LoadConfig")
        HexSh:WriteCompressedTable(cfgtbl)
    net.Broadcast()
end)

net.Receive("HexSh::LoadConfig", function(len,ply)
    local cfgtbl = table.Copy(HexSh.Config.IConfig)
    cfgtbl["SERVER"] = nil

    net.Start("HexSh::LoadConfig")
        HexSh:WriteCompressedTable(cfgtbl)
    net.Send(ply)
end)

net.Receive("HexSh::OpenConfigMenu", function(len,ply)
    if (!ply:GetUserGroup() == "superadmin") then return end
    net.Start("HexSh::OpenConfigMenu")
    net.Send(ply)
end)

hook.Add("PlayerSpawn","HexSh_ConfigLoad",function(ply)
    if (!ply.hexshinit) then 
        local cfgtbl = table.Copy(HexSh.Config.IConfig)
        cfgtbl["SERVER"] = nil
    
        net.Start("HexSh::LoadConfig")
            HexSh:WriteCompressedTable(cfgtbl)
        net.Send(ply)
    end
    ply.hexshinit = false 
end)
