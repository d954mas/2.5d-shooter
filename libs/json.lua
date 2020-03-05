local M = {}

local function clear_null(t)
	if type(t) == "table" then
		for k, v in pairs(t) do
			if v == cjson.null then
				t[k] = nil
			end
			if type(v) == "table" then
				clear_null(v)
			end
		end
	end
	return t
end

function M.decode(str)
	return clear_null(cjson.decode(str))
end

function M.encode(data, pretty)
	local json = cjson.encode(data)
	if pretty then json = M.pretty(json) end
	return json
end

local cat = table.concat
local sub = string.sub
local rep = string.rep

function M.pretty(s, lf, id, ac)
	lf, id, ac = lf or "\n", id or "     ", ac or " "
	local i, j, k, n, r, p, q = 1, 0, 0, #s, {}, nil, nil
	local al = sub(ac, -1) == "\n"
	for x = 1, n do
		local c = sub(s, x, x)
		if not q and (c == "{" or c == "[") then
			r[i] = p == ":" and cat { c, lf } or cat { rep(id, j), c, lf }
			j = j + 1
		elseif not q and (c == "}" or c == "]") then
			j = j - 1
			if p == "{" or p == "[" then
				i = i - 1
				r[i] = cat { rep(id, j), p, c }
			else
				r[i] = cat { lf, rep(id, j), c }
			end
		elseif not q and c == "," then
			r[i] = cat { c, lf }
			k = -1
		elseif not q and c == ":" then
			r[i] = cat { c, ac }
			if al then
				i = i + 1
				r[i] = rep(id, j)
			end
		else
			if c == '"' and p ~= "\\" then
				q = not q and true or nil
			end
			if j ~= k then
				r[i] = rep(id, j)
				i, k = i + 1, j
			end
			r[i] = c
		end
		p, i = c, i + 1
	end
	return cat(r)
end

return M