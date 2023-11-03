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