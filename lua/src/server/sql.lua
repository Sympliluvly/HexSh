--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]
if (!HexSh) then return end
HexSh.SQL = HexSh.SQL or {}

local D = HexSh_Decrypt


--Createifnoxexist
if (!file.Exists("hexsh/sql.json", "DATA")) then
	
	file.CreateDir("hexsh")
	file.Write("hexsh/sql.json",util.TableToJSON({
		mysql = false,
		host = HexSh_Encrypt(" "),
		username = HexSh_Encrypt(" "),
		password = HexSh_Encrypt(" "),
		schema = HexSh_Encrypt(" "),
		port = HexSh_Encrypt("3306"),
	}))

end

local data = util.JSONToTable(file.Read("hexsh/sql.json", "DATA"))
HexSh.SQL.cfg = {}
HexSh.SQL.cfg.mysql = data.mysql
HexSh.SQL.cfg.host = data.host
HexSh.SQL.cfg.username = data.username
HexSh.SQL.cfg.password = data.password
HexSh.SQL.cfg.schema = data.schema
HexSh.SQL.cfg.port = data.port


--utils
util.AddNetworkString("HexSh::SQLGET")
util.AddNetworkString("HexSh::SQLWRITE")

net.Receive("HexSh::SQLGET", function(len,ply)
	local data = util.JSONToTable(file.Read("hexsh/sql.json", "DATA"))
	net.Start("HexSh::SQLGET")
		net.WriteBool(data.mysql) 
		net.WriteString(HexSh_Decrypt(data.host))
		net.WriteString(HexSh_Decrypt(data.username))
		net.WriteString(HexSh_Decrypt(data.passsword))
		net.WriteString(HexSh_Decrypt(data.schema))
		net.WriteUInt(tonumber(HexSh_Decrypt(data.port)), 17 )
	snet.Send(ply)
end)
net.Receive("HexSh::SQLWRITE", function(len,ply)
	
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
		self.db = mysqloo.connect( D(HexSh.SQL.cfg.host), D(HexSh.SQL.cfg.username), D(HexSh.SQL.cfg.password), D(HexSh.SQL.cfg.schema), tonumber(D(HexSh.SQL.cfg.port)) )

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