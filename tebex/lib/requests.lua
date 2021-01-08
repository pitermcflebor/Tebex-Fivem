
_G.requests = setmetatable({
	PHR = assert(PerformHttpRequest),
	decode = json.decode,
	encode = json.encode,
}, {
	__index = {
		Ensure = function(self, o, t, _d)
			assert(type(o) == t, ('invalid Lua type, expected "%s" got "%s"'):format(t, type(o)))
			return true
		end,
		perform = function(self, method, url, payload, headers, cb)
			self:Ensure(url, 'string')
			if payload ~= nil then self:Ensure(payload, 'table') end
			self:Ensure(cb, 'function')
			if headers ~= nil then self:Ensure(headers, 'table') end
			
			local _h = (headers or {})
			local _d = (payload or {})
			_h['Content-Type'] = 'application/json;charset=utf-8';
			self.PHR(url,
			function(_sc, _res, _h)
				if _sc == 200 then
					local res = self.decode(_res)
					cb(res or _res, _res)
				else
					print(("[requests:info]: Performed GET request code: %s\nResponse: "):format(_sc), _res)
				end
			end,
			method,
			self.encode(_d),
			_h)
		end,
		get = function(self, params, cb)
			self:perform('GET', params.url, (params.payload or {}), (params.headers or {}), cb)
		end,
		post = function(self, params, cb)
			self:perform('POST', params.url, (params.payload or {}), (params.headers or {}), cb)
		end,
	}
})
