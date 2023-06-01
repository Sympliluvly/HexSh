--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
if (!HexSh) then return end

HexSh.keyBinds = HexSh.keyBinds or {}

local istr, inu, ifu = isstring, isnumber, isfunction
function HexSh:CreateBind(index,Title,Description,Key,OnPress,AccessCallback)
    if (!index || !istr(index)) then return end
    if (!Title || !istr(Title)) then return end
    if (!Description || !istr(Description)) then return end
    if (!Key || !inu(Key)) then return end
    if (!OnPress || !ifu(OnPress)) then return end
    if (!AccessCallback || !ifu(AccessCallback)) then return end

    local data = {}
    data.index = index
    data.Title = Title
    data.Description = Description
    data.Key = Key
    data.OnPress = OnPress
    data.AccessCallback = AccessCallback

    HexSh.keyBinds[ index ] = data
end