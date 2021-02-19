_G.tebexSecret = GetConvar('sv_tebexSecret', '')
if tebexSecret == '' then tebexSecret = GetResourceMetadata(GetCurrentResourceName(), 'tebexSecret', 0) or '' end

local function ParseBody(req)
    local p = promise.new()
    req.setDataHandler(function(body)
        p:resolve(json.decode(body))
    end)
    return Citizen.Await(p)
end

local function CheckSignature(signature, data)
    return ( signature == sha256( ("%s%s%s%s"):format(tebexSecret, data['payment']['txn_id'], data['payment']['status'], data['customer']['email']) ) )
end

local function PrettyPackage(package)
    local package = package
    -- get variables
    local variables = {}
    for _, variable in pairs(package.variables) do
        variables[variable.identifier] = variable.option
    end
    -- update prettied variables
    package.variables = variables
    return package
end

SetHttpHandler(function(req, res)
    --[[
    request #1:
        - @method setCancelHandler
        - @method setDataHandler
        - @string address
        - @table headers
        - @string method
        - @string path
    response #2:
        - @method write
        - @method send
        - @method writeHead
    ]]

    if req.method == 'GET' then res.writeHead(404)
    elseif req.method == 'POST' then
        if req.path == '/payments' then
            local signature = req.headers['X-BC-Sig']
            if signature ~= nil then
                local data = ParseBody(req)
                if CheckSignature(signature, data) then -- check signature
                    res.writeHead(200) -- accepted
                    res.send ''
                    -- notify scripts there's a new payment
                    -- payload:
                    -- @string  - package name
                    -- @table   - package data
                    for _, package in pairs(data['packages']) do
                        TriggerEvent('tebex:newPayment', package['name'], PrettyPackage(package))
                    end
                else
                    res.writeHead(401) -- unauthorized
                    res.send ''
                end
            else
                res.writeHead(403) -- forbidden
                res.send ''
            end
        end
    end
end)
