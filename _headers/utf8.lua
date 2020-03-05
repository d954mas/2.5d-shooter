--https://github.com/starwing/luautf8
utf8 = {}
function utf8.offset() end
function utf8.codes() end
function utf8.codepoint() end

function utf8.len() end
function utf8.sub() end
function utf8.reverse() end
function utf8.lower() end
function utf8.upper() end
function utf8.title() end
function utf8.fold() end
function utf8.byte() end
function utf8.char() end

--[[
escape a str to UTF-8 format string. It support several escape format:
    %ddd - which ddd is a decimal number at any length: change Unicode code point to UTF-8 format.
    %{ddd} - same as %nnn but has bracket around.
    %uddd - same as %ddd, u stands Unicode
    %u{ddd} - same as %{ddd}
    %xhhh - hexadigit version of %ddd
    %x{hhh} same as %xhhh.
    %? - '?' stands for any other character: escape this character.

Examples:
    local u = utf8.escape
    print(u"%123%u123%{123}%u{123}%xABC%x{ABC}")
    print(u"%%123%?%d%%u")--]]
---@return string utf8
function utf8.escape(str) end

function utf8.insert() end
function utf8.remove() end
function utf8.charpos() end
--[[
for pos, code in utf8.next, "utf8-string" do
    ...
end--]]
function utf8.next() end

function utf8.width() end
function utf8.widthindex() end
function utf8.ncasecmp() end
function utf8.find() end
function utf8.gmatch() end
function utf8.gsub() end
function utf8.match() end
