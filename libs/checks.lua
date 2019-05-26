#!/usr/bin/env tarantool

local function check_plain_type(value, expected_type)
	if type(value) == expected_type then
		return true
	end

	local mt = getmetatable(value)
	local value_metatype = mt and mt.__type
	if value_metatype == expected_type then
		return true
	end

	local checker = _G.checkers[expected_type]
	if type(checker) == 'function' and checker(value) == true then
		return true
	end

	return false
end

local function check_multi_type(value, expected_type)
	local _expected_type = expected_type

	-- 1. Check optional type.
	if expected_type == '?' then
		return true
	elseif expected_type:startswith('?') then
		if value == nil then
			return true
		end
		expected_type = expected_type:sub(2)
	end

	-- 2. Check exact type match
	if check_plain_type(value, expected_type) then
		return true
	end

	-- 3. Check multiple types.
	for typ in expected_type:gmatch('[^|]+') do
		if check_plain_type(value, typ) then
			return true
		end
	end

	-- 4. Nothing works, throw error
	return nil, string.format(
			'bad argument %s to %s (%s expected, got %s)',
	-- argname and function name are formatted by the caller
			'%s', '%s', _expected_type, type(value)
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
	for expected_key, expected_type in pairs(expected_fields) do
		local value = tbl and tbl[expected_key]

		if type(expected_type) == 'string' then
			local ok, efmt = check_multi_type(value, expected_type)
			if not ok then
				return nil, string.format(efmt, '%s'..keyname_fmt(expected_key), '%s')
			end
		elseif type(expected_type) == 'table' then
			local ok, efmt = check_multi_type(value, '?table')
			if not ok then
				return nil, string.format(efmt, '%s'..keyname_fmt(expected_key), '%s')
			end

			local ok, efmt = check_table_type(value, expected_type)
			if not ok then
				return nil, string.format(efmt, '%s'..keyname_fmt(expected_key), '%s')
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
					'%s'..keyname_fmt(key), '%s'
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
			local ok, efmt = check_multi_type(value, expected_type)
			if not ok then
				local info = debug.getinfo(level, 'nl')
				local err = string.format(efmt, '#'..tostring(i), info.name)
				error(err, level)
			end

		elseif type(expected_type) == 'table' then
			local ok, efmt = check_multi_type(value, '?table')
			if not ok then
				local info = debug.getinfo(level, 'nl')
				local err = string.format(efmt, '#'..tostring(i), info.name)
				error(err, level)
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


return checks
