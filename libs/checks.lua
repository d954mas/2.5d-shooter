
local _qualifiers_cache = {
	-- ['?type1|type2'] = {
	--     [1] = 'type1',
	--     [2] = 'type2',
	--     optional = true,
	-- },
}

local function is_subclass(t, name)
	if type(t) ~= "table" then return false end
	local class = t.class
	return class and
			(class.name == name or (class.super and
			(class.super.name == name or is_subclass(class.super, name))))
end

local function check_string_type(value, expected_type)
	-- 1. Check any value.
	if expected_type == '?' then
		return true
	end

	-- 2. Parse type qualifier
	local qualifier = _qualifiers_cache[expected_type]
	if qualifier == nil then
		qualifier = { optional = false }

		for typ in expected_type:gmatch('[^|]+') do
			if typ:sub(1,1) == '?' then
				qualifier.optional = true
				typ = typ:sub(2)
			end

			table.insert(qualifier, typ)
		end

		_qualifiers_cache[expected_type] = qualifier
	end

	-- 3. Check optional argument
	if qualifier.optional and value == nil then
		return true
	end

	-- 4. Check types
	for _, typ in ipairs(qualifier) do
		if type(value) == typ then
			return true
		end

		local mt = getmetatable(value)
		local value_metatype = mt and mt.__type
		if value_metatype == typ then
			return true
		end

		--check class
		if (is_subclass(value, typ)) then
			return true
		end

		local checker = _G.checkers[typ]
		if type(checker) == 'function' and checker(value) == true then
			return true
		end
	end

	-- 5. Nothing works, return an error
	return nil, string.format(
			'bad argument %s to %s (%s expected, got %s)',
	-- argname and function name are formatted by the caller
			'%s', '%s', expected_type, type(value) ~="userdata" and value and value.class and value.class.name or type(value)
	)
end

local function keyname_fmt(key)
	if type(key) == 'string' then
		return string.format('.%s', key)
	elseif type(key) == 'number' then
		return string.format('[%s]', key)
	else
		return '[?]'
	end
end

local function check_table_type(tbl, expected_fields)
	if tbl == nil then
		tbl = nil
	end

	for expected_key, expected_type in pairs(expected_fields) do
		local value = tbl and tbl[expected_key]

		if type(expected_type) == 'string' then
			local ok, efmt = check_string_type(value, expected_type)
			if not ok then
				return nil, string.format(efmt, '%s' .. keyname_fmt(expected_key), '%s')
			end
		elseif type(expected_type) == 'table' then
			local ok, efmt = check_string_type(value, '?table')
			if not ok then
				return nil, string.format(efmt, '%s' .. keyname_fmt(expected_key), '%s')
			end

			if _G._checks_v2_compatible and value == nil then
				value = {}
				tbl[expected_key] = value
			end

			local ok, efmt = check_table_type(value, expected_type)
			if not ok then
				return nil, string.format(efmt, '%s' .. keyname_fmt(expected_key), '%s')
			end
		else
			return nil, string.format(
					'checks: type %q is not supported',
					type(expected_type)
			)
		end
	end

	if not tbl then
		return true
	end

	for key, _ in pairs(tbl) do
		if not expected_fields[key] then
			return nil, string.format(
					'unexpected argument %s to %s',
			-- argname and function name
			-- are formatted by the caller
					'%s' .. keyname_fmt(key), '%s'
			)
		end
	end

	return true
end

local function checks(...)
	local skip = 0

	local level = 1
	if type(...) == 'number' then
		level = ...
		skip = 1
	end
	level = level + 1 -- escape the checks level

	for i = 1, select('#', ...) - skip + 1 do
		local expected_type = select(i + skip, ...)
		local argname, value = debug.getlocal(level, i)

		if expected_type == nil and argname == nil then
			break
		elseif expected_type == nil then
			local err = string.format(
					'checks: argument %q is not checked',
					argname
			)
			error(err, level)
		elseif argname == nil then
			local err = 'checks: excess check, absent argument'
			error(err, level)
		elseif type(expected_type) == 'string' then
			local ok, efmt = check_string_type(value, expected_type)
			if not ok then
				local info = debug.getinfo(level, 'nl')
				local err = string.format(efmt, '#' .. tostring(i), info.name)
				error(err, level)
			end

		elseif type(expected_type) == 'table' then
			local ok, efmt = check_string_type(value, '?table')
			if not ok then
				local info = debug.getinfo(level, 'nl')
				local err = string.format(efmt, '#' .. tostring(i), info.name)
				error(err, level)
			end

			if _G._checks_v2_compatible and value == nil then
				value = {}
				debug.setlocal(level, i, value)
			end

			local ok, efmt = check_table_type(value, expected_type)
			if not ok then
				local info = debug.getinfo(level, 'nl')
				local err = string.format(efmt, argname, info.name)
				error(err, level)
			end
		else
			local err = string.format(
					'checks: type %q is not supported',
					type(expected_type)
			)
			error(err, level)
		end
	end
end


_G.checks = checks
_G.checkers = rawget(_G, 'checkers') or {}


function checkers.url(p)
	return type(p) == "userdata" and p.fragment and p.path and p.socket
end

return checks
