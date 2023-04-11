--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]

function HexSh:registerConfig( name, color, vguif )
    HexSh.UI.Configs[name] = {}
    HexSh.UI.Configs[name].name = name 
    HexSh.UI.Configs[name].color = color || Color(26,95,197) 
    HexSh.UI.Configs[name].vguif = vguif
end