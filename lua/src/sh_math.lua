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
