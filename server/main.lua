if Config.Framework == 'QBCore' then

    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateCallback("sd-stashes:server:CheckCode", function(source, cb, id, code)
        if Config.Pin[id] and Config.Pin[id] == tonumber(code) then
            cb(true)
        else
            cb(false)
        end
    end)

elseif Config.Framework == 'ESX' then

    -- Check fxmanifest.lua
    CreateThread(function()
        for k, v in pairs(Config.Stashes) do
            exports.ox_inventory:RegisterStash(k, k, v.slots, v.weight)
        end
    end)

    ESX.RegisterServerCallback("sd-stashes:server:CheckCode", function(source, cb, id, code)
        if Config.Pin[id] and Config.Pin[id] == tonumber(code) then
            cb(true)
        else
            cb(false)
        end
    end)
end