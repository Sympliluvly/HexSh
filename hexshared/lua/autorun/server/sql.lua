--[[For some I am just a rib, but for others the biggest dream, you can easily but often difficult with me, many do not understand my intentions and do not get along with it, what am I?]]

if (!HexSh) then return end

HexSh.SQL = HexSh.SQL or {}

function HexSh.SQL.GetConnection()
	return HexSh.Config.MySQL
end

local ccfg = {
	mysql = HexSh.SQL.GetConnection().use or false,
	host = HexSh.SQL.GetConnection().IP or "",
	username = HexSh.SQL.GetConnection().UserName or "",
	password = HexSh.SQL.GetConnection().Password or "",
	schema = HexSh.SQL.GetConnection().Databasename or "",
	port = HexSh.SQL.GetConnection().Port or 3306
}

function HexSh.SQL.Constructor( self, config )
	local sql = {}
	config = config or {}

	sql.config = ccfg
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

			mysqloo:Connect(ccfg.host, ccfg.username, ccfg.password, ccfg.schema, ccfg.port)
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
	if not ccfg.mysql then return end
	if not pcall( require, "mysqloo" ) then
		error("Couldn't find mysqlOO. Please install https://github.com/FredyH/mysqlOO. Reverting to SQLite")
		ccfg.mysql = false
	end
end

function HexSh.SQL:Connect()
	if ccfg.mysql then
		self.db = mysqloo.connect( ccfg.host, ccfg.username, ccfg.password, ccfg.schema, ccfg.port )

		self.db.onConnectionFailed = function(_, msg)
			timer.Simple(5, function()
				if not self then 	
					return
				end
				self:Connect( ccfg.host, ccfg.username, ccfg.password, ccfg.schema, ccfg.port )
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
	local func = ccfg.mysql and querymysql or querySQLite

	func( self, query, callback, errorCallback )
end

function HexSh.SQL:QueryRow( query, row )
	row = row or 1

	local r = HexSh.SQL:Query( query, function( r )
		if ( r ) then 
			return r[ row ]
		end
 
		return r
	end, function( err )
		print( "Not Work!" )
	end )

	return r
end

function HexSh.SQL:QueryValue( query )
	local r = HexSh.SQL:QueryRow( query )

	if ( r ) then
		for k, v in pairs( r ) do 	
			return v
		end
	end

	return r
end

function HexSh.SQL:UsingMySQL()
	return HexSh.Config.MySQL.use
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
