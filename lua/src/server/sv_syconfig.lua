--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
// Too Simple Config
util.AddNetworkString("HexSh::LoadConfig")
util.AddNetworkString("HexSh::WriteConfig")
util.AddNetworkString("HexSh::OpenConfigMenu")

net.Receive("HexSH::WriteConfig", function(len,ply)
    if (!ply:GetUserGroup() == "superadmin") then return end
    local readNewData = HexSh:ReadCompressedTable()

    if (!file.Exists("hexsh/config.json", "DATA")) then
        file.CreateDir("hexsh")
        local cfgtbl = table.Copy(readNewData)

        file.Write("hexsh/config.json", util.TableToJSON(cfgtbl))
    else
        local cfgtbl = table.Copy(readNewData)
        file.Write("hexsh/config.json", util.TableToJSON(cfgtbl))
    end
    
    net.Start("HexSh::LoadConfig")
        HexSh:WriteCompressedTable(readNewData)
    net.Broadcast()
end)

net.Receive("HexSh::LoadConfig", function(len,ply)
    local export = HexSh.Config.IConfig
       
    if (!file.Exists("hexsh/config.json", "DATA")) then
        file.CreateDir("hexsh")
        export = HexSh.Config.IConfig
    else
        export = util.JSONToTable(file.Read("hexsh/config.json", "DATA"))

        --Check if not saved data in neww Sh
        for k, v in pairs(HexSh.Config.IConfig) do
            if (export[k] && HexSh.Config.IConfig[k]) then 
                if (export[k] != HexSh.Config.IConfig[k]) then 
                    table.Merge(export[k], HexSh.Config.IConfig[k])
                end
            end
        end
    end

    HexSh.Config.IConfig = export

    net.Start("HexSh::LoadConfig")
        HexSh:WriteCompressedTable(export)
    net.Send(ply)
end) 

net.Receive("HexSh::OpenConfigMenu", function(len,ply)
    if (!ply:GetUserGroup() == "superadmin") then return end
    net.Start("HexSh::OpenConfigMenu")
    net.Send(ply)
end)

hook.Add("PlayerSpawn","HexSh_ConfigLoad",function(ply)
    if (!ply.hexshinit) then     
        local export = HexSh.Config.IConfig
       
        if (!file.Exists("hexsh/config.json", "DATA")) then
            file.CreateDir("hexsh")
            export = HexSh.Config.IConfig
        else
            export = util.JSONToTable(file.Read("hexsh/config.json", "DATA"))
    
            --Check if not saved data in neww Sh
            for k, v in pairs(HexSh.Config.IConfig) do
                if (export[k] && HexSh.Config.IConfig[k]) then 
                    if (export[k] != HexSh.Config.IConfig[k]) then 
                        table.Merge(export[k], HexSh.Config.IConfig[k])
                    end
                end
            end
        end
    
        HexSh.Config.IConfig = export
        
        net.Start("HexSh::LoadConfig")
            HexSh:WriteCompressedTable(export)
        net.Send(ply)
    end
    ply.hexshinit = false 
end)
