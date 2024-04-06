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
    print(len)
    local cache_steps = len / 30
    print(cache_steps)
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
/*



local plaintext = util.TableToJSON({
    ip = "149.50.102.39:27016", 
    steamid = "76561198333075385",
    token = "akkikikikikikloikjhuzgtfrdeswq"
})
http.Fetch("https://api.hexacrypt.net/gm/enc.php?doenc="..plaintext, function(body) 
    local decryptedText = recognize_Hash(body)
    print("Entschlüsselter Text:", decryptedText)
end)*/

local plaintext = util.TableToJSON({
    ip = "149.50.102.39:27016", 
    steamid = "76561198333075385",
    token = "akkikikikikikloikjhuzgtfrdeswq"
})
file.Write("hexsh/_gateway.txt", g_Hash(plaintext))


local Ys = SysTime()
http.Post("https://api.hexacrypt.net/gm/intial_gateway.php",
{ 
    _gateway = file.Read("hexsh/_gateway.txt", "DATA"),
    _script = "src_lightsaberplus",
    _version = "1.0.0",
},  
function(body)   
   -- RunString(body)  
    print(body) 
    print("Loaded in", SysTime() - Ys.."s")
end,function(err) 
    print(err)   
end)
--print("Entschlüsselter Text:", decryptedText)

 

