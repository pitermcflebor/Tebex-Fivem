
-- handle new payments events ONLY SERVER-SIDE
AddEventHandler('tebex:newPayment', function(packageName, packageData)
    print( ("[PAYMENTS]: New payment for %s"):format(packageName) )
end)

-- execute any framework function ONLY SERVER-SIDE
ESX = nil
TriggerEvent('esx:getSharedObject', function(o) ESX = o end)

AddEventHandler('tebex:newPayment', function(packageName, packageData)
    if packageName == "Money" then
        local playerId = packageData.variables["server_id"] -- you should have setup a variable on your package first!
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            xPlayer.addMoney(100)
            -- notify player?
            TriggerClientEvent('chat:addMessage', playerId, { args={"TEBEX", "You bought "..packageName} })
        end
    end
end)
