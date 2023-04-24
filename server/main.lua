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

    ESX = nil

    local export, ESX = pcall(function()
        return exports['es_extended']:getSharedObject()
    end)

    CreateThread(function()
        if not export then
            while not ESX do
                TriggerEvent("esx:getSharedObject", function(obj)
                    ESX = obj
                end)
                Wait(500)
            end
        end
    end)

    if GetResourceState('ox_inventory'):find('start') then
        CreateThread(function()
            for k, v in pairs(Config.Stashes) do
                exports.ox_inventory:RegisterStash(k, k, v.slots, v.weight)
            end
        end)
    end

    ESX.RegisterServerCallback("sd-stashes:server:CheckCode", function(source, cb, id, code)
        if Config.Pin[id] and Config.Pin[id] == tonumber(code) then
            cb(true)
        else
            cb(false)
        end
    end)
end