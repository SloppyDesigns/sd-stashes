if Config.Framework == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function InventoryOpen(id, data)
    if data.pin then
        local input, code = exports['sd-stashes']:CreateInput({
            header = 'Enter Code',
            inputs = {
                {
                    text = 'Code'
                }
            }
        })
        if input then
            if tonumber(code) ~= nil then
                if Config.Framework == 'QBCore' then
                    QBCore.Functions.TriggerCallback('sd-stashes:server:CheckCode', function(correct)
                        if correct then
                           Config.InventoryOpen(id, data) 
                        else
                            Config.Notify('Stashes', 'Incorrect Code', 'error')
                        end
                    end, id, code)
                elseif Config.Framework == 'ESX' then
                    ESX.TriggerServerCallback('sd-stashes:server:CheckCode', function(correct)
                        if correct then
                            Config.InventoryOpen(id, data)
                        else
                            Config.Notify('Stashes', 'Incorrect Code', 'error')
                        end
                    end, id, code)
                end
            end
        end
    else
        Config.InventoryOpen(id, data) 
    end
end

CreateThread(function()
    for k, v in pairs(Config.Stashes) do
        local options = {}

        options[#options+1] = {
            type = 'client',
            event = 'sd-stashes:client:OpenPolice',
            icon = Config.PoliceIcon,
            label = Config.PoliceLabel,
            stashname = k,
            stashdata = v,
            job = Config.PoliceJobs,
        }

        options[#options+1] = {
            type = 'client',
            event = 'sd-stashes:client:Open',
            icon = v.icon,
            label = v.label,
            stashname = k,
            stashdata = v,
        }

        if v.job then
            options[#options].job = v.job
        end

        if v.citizenid then
            options[#options].citizenid = v.citizenid
        end

        exports[Config.Target]:AddBoxZone(k, v.coords, v.length, v.width, {
            name = k,
            heading = v.heading,
            debugPoly = Config.Debug, 
            minZ = v.coords.z, 
            maxZ = v.coords.z + v.height,
        }, {
            options = options,
            distance = 2.5,
        })
    end
end)

RegisterNetEvent('sd-stashes:client:Open', function(data)
    InventoryOpen(data.stashname, data.stashdata)
end)

RegisterNetEvent('sd-stashes:client:OpenPolice', function(data)
    if Config.Framework == 'QBCore' then
        local PlayerData = QBCore.Functions.GetPlayerData()
        if Config.PoliceJobs[PlayerData.job.name] and PlayerData.job.grade.level  >= Config.PoliceJobs[PlayerData.job.name] then
            Config.InventoryOpen(data.stashname, data.stashdata)
        end
    elseif Config.Framework == 'ESX' then
        if Config.PoliceJobs[ESX.PlayerData.job.name] and ESX.PlayerData.job.grade >= Config.PoliceJobs[ESX.PlayerData.job.name] then
            Config.InventoryOpen(data.stashname, data.stashdata)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    for k, v in pairs(Config.Stashes) do
        exports[Config.Target]:RemoveZone(k)
    end
end)