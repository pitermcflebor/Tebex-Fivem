if requests == nil then
	local f, err = load(LoadResourceFile('tebex', 'lib/requests.lua'))
	assert(f, err)
	f()
end

_G.Tebex = setmetatable({
	__purchases = {},
	__secret = GetConvar('sv_tebexSecret', 'none'),
	__endpoint = 'https://plugin.tebex.io/%s',
}, {
	__index = {
		new = function(self, data, _r)
			local o = setmetatable({
				__transaction = data.transaction,
				__server = data.server,
				__price = tonumber(data.price),
				__currency = data.currency,
				__time = data.time,
				__date = data.date,
				__email = data.email,
				__ip = data.ip,
				__packageId = tonumber(data.packageId),
				__packagePrice = tonumber(data.packagePrice),
				__packageExpiry = data.packageExpiry,
				__packageName = data.packageName,
				__purchaserName = data.purchaserName,
				__purchaserUuid = data.purchaserUuid,
				__purchaseQuantity = data.purchaseQuantity,
				Params = data.Params
			}, {
				__tostring = function(self)
					return ("<Tebex:Purchase %s>"):format(self.__packageId)
				end,
			})
			o.Transaction = {
				Id = o.__transaction,
				Server = o.__server,
				Price = o.__price,
				Currency = o.__currency,
				FullPrice = ("%s %s"):format(o.__price, o.__currency),
				Date = ("%s %s"):format(o.__time, o.__date),
				Quantity = o.__purchaseQuantity,
				Amount = o.__purchaseQuantity,
			}
			o.Package = {
				Id = o.__packageId,
				Price = o.__price,
				Expiry = o.__packageExpiry,
				Name = o.__packageName,
			}
			o.Purchaser = {
				Name = o.__purchaserName,
				UUID = o.__purchaserUuid,
			}
			self.__purchases[o.Transaction.Id] = o
			return o
		end,
		GetPurchaseFromTransaction = function(self, _tid)
			if self.__purchases[_tid] then
				return self.__purchases[_tid]
			else
				local p = promise.new()
				TriggerEvent('__tebex_internal:find:transaction', _tid, function(data)
					p:resolve(data)
				end)
				return self:new(Citizen.Await(p))
			end
		end,
		OnPackageNameBought = function(self, pkName, cb)
			AddEventHandler('__tebex_internal:offline:purchased', function(pkg, data)
				if pkName == pkg then
					cb(self:new(data))
				end
			end)
		end,
		OnPackageIdBought = function(self, pkId, cb)
			AddEventHandler('__tebex_internal:offline:purchased', function(data)
				if data.packageId == pkId then
					cb(self:new(data))
				end
			end)
		end,
		GetAccountInfo = function(self)
			local p = promise.new()
			requests:get({
				url = self.__endpoint:format('information'),
				headers = {
					['X-Tebex-Secret'] = self.__secret,
				},
			}, function(data, raw)
				p:resolve(data)
			end)
			local data = Citizen.Await(p)
			return data
		end,
		GetPackages = function(self)
			local p = promise.new()
			requests:get({
				url = self.__endpoint:format('packages'),
				headers = {
					['X-Tebex-Secret'] = self.__secret
				},
			}, function(data)
				p:resolve(data)
			end)
			local data = Citizen.Await(p)
			return setmetatable({
				__packages = data
			}, {
				__index = {
					GetPackageByName = function(self, pkName)
						for _, package in pairs(self.__packages) do
							if package.name == pkName then
								return package
							end
						end
					end,
					GetPackageById = function(self, pkId)
						for _, category in pairs(self.__packages) do
							if package.id == pkId then
								return package
							end
						end
					end,
				}
			})
		end,
		DoesPlayerBoughtPackage = function(self, playerSrc, pkg)
			if not IsPlayerCommerceInfoLoadedExt(tostring(playerSrc)) then
				LoadPlayerCommerceDataExt(tostring(playerSrc))
				while not IsPlayerCommerceInfoLoadedExt(tostring(playerSrc)) do Wait(50) end
			end
			if type(pkg) == 'string' then
				local pak = self:GetPackages():GetPackageByName(pkg)
				if pak ~= nil then
					return DoesPlayerOwnSku(tostring(playerSrc), pak.id) == 1
				end
			elseif type(pkg) == 'number' then
				local pak = self:GetPackages():GetPackageById(pkg)
				if pak ~= nil then
					return DoesPlayerOwnSku(tostring(playerSrc), tonumber(pkg)) == 1
				end
			end
		end,
		GetPaymentInfo = function(self, transId)
			assert(type(transId) == 'string', 'invalid Lua type')
			local p = promise.new()
			requests:get({
				url = self.__endpoint:format('payments/'..transId),
				headers = {
					['X-Tebex-Secret'] = self.__secret,
				}
			}, function(data, raw)
				p:resolve(data)
			end)
			return Citizen.Await(p)
		end,
	}
})
