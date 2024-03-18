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
local chars = {
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+", "[", "]", "{", "}", "|", "\\", ":", ";", ",", ".", "<", ">", "?", "/", "~"
}


-- ###X##X#########X########X####
-- 1 => 4
-- 2 = 7
-- 3 = 17
-- 4 = 26


local function createunique(letter)
    local forbidden = letter

    local customChars = table.Copy(chars)
    table.RemoveByValue(customChars, forbidden)


    local uniqueHash = ""
    for i=1, 30 do 
        if i == 4 or i == 7 or i == 17 or i == 26 then 
            uniqueHash = uniqueHash .. forbidden
        else
            local randomnum = math.random(1, #customChars)
            uniqueHash = uniqueHash .. customChars[randomnum] 
        end
    end

    return uniqueHash
end


local function g_Hash(string)
    local exploded = string.Explode("", string)
    local encryptionCode = ""


    for k,v in pairs(exploded) do 
        encryptionCode = encryptionCode .. createunique(v)
    end

    return encryptionCode
end

function recognize_Hash(hash)
    local len = string.len(hash)
    local cache_steps = len / 30
    local decrypted = ""

    for i=1, cache_steps do 
        local start = (i-1) * 30 + 1
        local stop = i * 30

        local cache = string.sub(hash, start, stop)
        local cache_exploded = string.Explode("", cache)
        local cache_entered = false

        for k,v in pairs(cache_exploded) do 
            local p1,p2,p3,p4 = string.sub(cache, 4,4), string.sub(cache, 7,7), string.sub(cache, 17,17), string.sub(cache, 26,26)
            
            if (p1 == p2 and p1 == p3 and p1 == p4) and cache_entered != true then
                decrypted = decrypted .. p1
                cache_entered = true
            end
        end
    end
    return decrypted
end

local txt = [[

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.   
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et
]]