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

if (!HexSh && HexSh.isLIBready == 0) then return end
HexSh.SQL = HexSh.SQL or {}
local D = HexSh_Decrypt


--Createifnoxexist
local data = util.JSONToTable(file.Read("hexsh/sql.json", "DATA"))
HexSh.SQL.cfg = {}
HexSh.SQL.cfg.mysql = data.mysql
HexSh.SQL.cfg.host = data.host
HexSh.SQL.cfg.username = data.username
HexSh.SQL.cfg.password = data.password
HexSh.SQL.cfg.schema = data.schema
HexSh.SQL.cfg.port = data.port

if HexSh.SQL.cfg.mysql then 
	require("mysqloo")
end


--utils
util.AddNetworkString("HexSh::SQLGET")
util.AddNetworkString("HexSh::SQLWRITE")

net.Receive("HexSh::SQLGET", function(len,ply)
	print(ply:HC_hasPermission("MySQL"))
	if ply:HC_hasPermission("MySQL") == false then 

		net.Start("HexSh::SQLGET")
			net.WriteBool(false)
		net.Send(ply)

		return 
	end

	local data = util.JSONToTable(file.Read("hexsh/sql.json", "DATA"))
	net.Start("HexSh::SQLGET")
		net.WriteBool(true) --access
		net.WriteBool(data.mysql) 
		net.WriteString(HexSh_Decrypt(data.host))
		net.WriteString(HexSh_Decrypt(data.username))
		net.WriteString(HexSh_Decrypt(data.password))
		net.WriteString(HexSh_Decrypt(data.schema))
		net.WriteUInt(tonumber(HexSh_Decrypt(data.port)), 17 )
	net.Send(ply)
end)
net.Receive("HexSh::SQLWRITE", function(len,ply)
	--if (HexSh_blockspam(ply:SteamID64())) then
	--	print("SSTOP")
	--	return 
	--end 
	if (!ply:GetUserGroup() == "superadmin") then return end 

	local mysql = net.ReadBool()
	local host = net.ReadString()
	local username = net.ReadString()
	local password = net.ReadString()
	local dbname = net.ReadString()
	local port = net.ReadUInt( 17 )

	file.Write("hexsh/sql.json",util.TableToJSON({
		mysql = mysql,
		host = HexSh_Encrypt(host),
		username = HexSh_Encrypt(username),
		password = HexSh_Encrypt(password),
		schema = HexSh_Encrypt(dbname),
		port = HexSh_Encrypt(port),
	}))

	HexSh.SQL:Connect()
end)

function HexSh.SQL.Constructor( self, config )
	local sql = {}
	config = config or {} 

	sql.config = HexSh.SQL.cfg
	mysqloo.onConnected = function() end

	sql.cache = {}
	setmetatable(sql, HexSh.SQL)
	sql:RequireModule()

	return sql
end

local function querymysql( self, query, callback, errorCallback )
	if not query or not self.db then return end;
	local q = self.db:query( query )

	function q:onSuccess( data )
		if callback then
			callback( data )	
		end
	end

	function q:onError(_, err)
		if not self.db or self.db:status() == mysqlOO.DATABASE_NOT_CONNECTED then
			table.insert(self.cache, {
				query = query,
				callback = callback,
				errorCallback = errorCallback
			})
			mysqloo:Connect(D(HexSh.SQL.cfg.host), D(HexSh.SQL.cfg.username), D(HexSh.SQL.cfg.password), D(HexSh.SQL.cfg.schema), tonumber(D(HexSh.SQL.cfg.port)))
			return
		end

		if errorCallback then
			errorCallback(err)
		end
	end

	q:start() 
end

local function querySQLite(self, query, callback, errorCallback)
	if not query then return end;

	sql.m_strError = ""
	local lastError = sql.LastError()
	local result = sql.Query(query)

	if sql.LastError() and sql.LastError() != lastError then
        local err = sql.LastError();

        if errorCallback then
            errorCallback(err, query)
        end
        return
	end

	if callback then
		callback( result )
	end
end 

function HexSh.SQL:RequireModule() 
	if not HexSh.SQL.cfg.mysql then return end
	if not pcall( require, "mysqloo" ) then
		error("Couldn't find mysqlOO. Please install https://github.com/FredyH/mysqlOO. Reverting to SQLite")
		HexSh.SQL.cfg.mysql = false
	end
end


function HexSh.SQL:Connect()
	if HexSh.SQL.cfg.mysql then

		self.db = mysqloo.connect( HexSh_Decrypt(HexSh.SQL.cfg.host), HexSh_Decrypt(HexSh.SQL.cfg.username), HexSh_Decrypt(HexSh.SQL.cfg.password), HexSh_Decrypt(HexSh.SQL.cfg.schema), tonumber(HexSh_Decrypt(HexSh.SQL.cfg.port)) )
		self.db.onConnectionFailed = function(_, msg)
			timer.Simple(5, function()
				if not self then 	 
					return
				end
				self:Connect( D(HexSh.SQL.cfg.host), D(HexSh.SQL.cfg.username), D(HexSh.SQL.cfg.password), D(HexSh.SQL.cfg.schema),tonumber(D(HexSh.SQL.cfg.port)) )
			end )

			error("Connection failed! " .. tostring( msg ) ..	"\nTrying again in 5 seconds.")
		end

		mysqloo.onConnected = function()
			for k, v in pairs( self.cache or {} ) do
				self:Query( v.query, v.callback, v.errorCallback )
			end

			self.cache = {};
			mysqloo.onConnected()
		end

		self.db:connect()
	end
end
 
function HexSh.SQL:Disconnect()
	if IsValid( self.db ) then
		self.db:disconnect()
	end
end

function HexSh.SQL:Query( query, callback, errorCallback )
	local func = HexSh.SQL.cfg.mysql and querymysql or querySQLite
	func( self, query, callback, errorCallback )
end

function HexSh.SQL:UsingMySQL()
	return HexSh.SQL.cfg.mysql
end

function HexSh.SQL:Escape(str)
	if self:UsingMySQL() then
		return string.Replace(self.db:escape(tostring(str)), "'", "")
	else
		return string.Replace(sql.SQLStr(str), "'", "")
	end
end

HexSh.SQL.__index = HexSh.SQL

setmetatable(HexSh.SQL, {
	__call = HexSh.SQL.Constructor
})
 
if HexSh.SQL then 
	HexSh.SQL:Disconnect()
end

HexSh.SQL:Connect()

