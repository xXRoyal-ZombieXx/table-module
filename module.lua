local m = {}
--// Variables \\--

--// Functions \\--
m.createKey = function(pid)
	return "main-data-"..pid
end

m.createDirectoryFromTable = function(t, tname, location)
	local dir = Instance.new("Folder",location)
	print(tname)
	dir.Name = tname
	if not typeof(t) == "table" then error("Table not provided, contact a developer") return end
	for i,v in pairs(t) do
		if typeof(v) == "table" then
			m.createDirectoryFromTable(v,i,dir)
		elseif typeof(v) == "number" then
			local value= Instance.new("IntValue",dir)
			value.Name = i
			value.Value = v
		elseif typeof(v) == "boolean" then
			local value= Instance.new("BoolValue",dir)
			value.Name = i
			value.Value = v
		elseif typeof(v) == "string" then
			local value= Instance.new("StringValue",dir)
			value.Name = i
			value.Value = v
		end
	end
end

m.test2 = function(t,tname,location)
	local dir = Instance.new("Folder",location)
	dir.Name = tname
	if not typeof(t) == "table" then error("Table not provided, contact a developer") return end
	for i,v in pairs(t) do
		if typeof(v) == "table" then
			m.createDirectoryFromTable(v,v.name,dir)
		elseif typeof(v) == "number" then
			local value= Instance.new("IntValue",dir)
			value.Name = t.name
			value.Value = v
		elseif typeof(v) == "boolean" then
			local value= Instance.new("BoolValue",dir)
			value.Name = t.name
			value.Value = v
		elseif typeof(v) == "string" then
			local value= Instance.new("StringValue",dir)
			value.Name = t.name
			value.Value = v
		end
	end
end

m.createTableFromDirectory = function(location)
	local result = {}
	for i,v in pairs(location:GetChildren()) do
		if v:IsA("Folder") then
			result[v.Name] = m.createTableFromDirectory(v)
		else
			result[v.Name] = v.Value
		end
	end
	return result
end

m.createDataString = function(t)
	if not typeof(t) == "table" then error("Please provide a table") return end
	local result = "{\n"
	for i,v in pairs(t) do
		if typeof(v) == "table" then
			if typeof(i) == "number" then
				result = result+i.." = \n"..m.createDataString(v)
			else
				result = result.."['"..i.."']".." = \n"..m.createDataString(v)
			end
		elseif typeof(v) == "number" then
			if typeof(i) == "number" then
				result = result+i.." = "..v..",\n"
			else
				result = result.."['"..i.."']".." = "..v..",\n"
			end
		elseif typeof(v) == "boolean" then
			if typeof(i) == "number" then
				if v == true then
					result = result+i.." = true,\n"
				else
					result = result+i.." = false,\n"
				end
			else
				if v == true then
					result = result.."['"..i.."']".." = true,\n"
				else
					result = result.."['"..i.."']".." = false,\n"
				end
			end
		elseif typeof(v) == "string" then
			if typeof(i) == "number" then
				result = result+i.." = '"..v.."',\n"
			else
				result = result.."['"..i.."']".." = '"..v.."',\n"
			end
		end
	end
	result = result.."}"
	return result
end

m.combineTable = function(current,new)
	for i,v in pairs(new) do
		if not current[i] then
			current[i] = v
		else
			if typeof(v) == "table" then
				current[i] = m.combineTable(current[i],v)
			end
		end
	end
	return current
end

m.test = function(current,new)
	for i,v in pairs(new) do
		if typeof(v) == "table" then
			for i,e in pairs(current) do
				if table.find(e,"name") then
					if e.name == v.name then
						m.test(e,v)
					end
				else
					if e.name == v.name then
						m.test(e,v)
					end
				end
			end
			
		else
			if current[i] ~= nil then
				current[i] = v
			end
		end
	end
	for i,v in pairs(current) do
		current[i] = i
	end
	return current
end
return m
