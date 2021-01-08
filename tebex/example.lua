
-- event for package bought
-- by name
Tebex:OnPackageNameBought('Some Package Name', function(purchase)
	print(('[Tebex:Payments]: User %s bought the package %s (%s)\nOther: %s'):format(
		purchase.Purchaser.Name,
		purchase.Package.Name,
		purchase.Transaction.FullPrice,
		json.encode(purchase.Params)
	))
end)
-- by id
Tebex:OnPackageIdBought('123456789', function(purchase)
	print(('[Tebex:Payments]: User %s bought the package %s (%s)'):format(
        purchase.Purchaser.Name,
        purchase.Package.Name,
		purchase.Transaction.FullPrice
    ))
end)
-- purchase data structure:
--[[
Transaction {
	Id
	Server
	Price
	Currency
	FullPrice
	Date
	Quantity
	Amount
}
Package {
	Id
	Price
	Expiry
	Name
}
Purchaser {
	Name
	UUID
}
]]


-- getting packages info
local packages = Tebex:GetPackages()							-- get a list of all packages
local package = packages:GetPackageByName('Some Package Name')	-- find a package with the name
local package = packages:GetPackageById(123456789)				-- find a package with the id
-- package data example: https://docs.tebex.io/plugin/endpoints/packages#retrieve-a-package


-- getting Tebex account info
local account = Tebex:GetAccountInfo()
-- account data example: https://docs.tebex.io/plugin/endpoints/information#get-server-information


-- check if player bought the package
if Tebex:DoesPlayerBoughtPackage(source, 'Some Package Name') then
	-- code
end
-- check if player bought the package by id
if Tebex:DoesPlayerBoughtPackage(source, 123456789) then
	-- code
end
