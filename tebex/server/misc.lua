
assert(GetConvar('sv_tebexSecret', 'none') ~= 'none', 'Your Tebex secret is not set!')

RegisterCommand('tebex_purchase', function(s, _, rawCommand)
	if s == 0 then
		local args = table.build(rawCommand:split(' '))
		local data = json.decode(args[2])
		data.Params = {}
		for i=3, #args, 1 do
			data.Params[i-2] = args[i]
		end
		local _p = Tebex:new(data)
		TriggerEvent('__tebex_internal:offline:purchased', _p.Package.Name, data)
	end
end, true)


function string:split(pat)
	pat = pat or '%s+'
	local st, g = 1, self:gmatch("()("..pat..")")
	local function getter(segs, seps, sep, cap1, ...)
	st = sep and seps + #sep
	return self:sub(segs, (seps or 0) - 1), cap1 or sep, ...
	end
	return function() if st then return getter(st, g()) end end
end

function table.build(iter)
	if type(iter) ~= 'function' then return nil end
	local t = {}
	for i in iter do table.insert(t, i) end
	return t
end
