Config = {}
Config.Debug = false
Config.SDMenuVersion = 'qb' -- nh-context version v1 / v2 / zf / qb
Config.SDInputVersion = 'qb' -- nh-keyboad version v1 / v2 / zf / qb
Config.Target = 'qb-target' -- qb-target / qtarget

-- Police Open Stash
Config.PoliceJobs = { ['police'] = 1 }
Config.PoliceIcon = 'fa-solid fa-building-shield'
Config.PoliceLabel = 'Break Open Stash'


if GetResourceState('es_extended') == 'started' then
    Config.Framework = "ESX"
elseif GetResourceState('qb-core') == 'started' then
    Config.Framework = "QBCore"
end

Config.InventoryOpen = function(id, data)
    if Config.Framework == "QBCore" then
        -- qb-inventory / lj-inventory / aj-inventory
        TriggerServerEvent("inventory:server:OpenInventory", "stash", id, {
            maxweight = data.weight,
            slots = data.slots,
        })
        TriggerEvent("inventory:client:SetCurrentStash", id)
    elseif Config.Framework == "ESX" then
        -- ox_inventory
        exports.ox_inventory:openInventory('stash', { id = id })
    end
end

Config.Notify = function(title, message, type)
    if Config.Framework == "QBCore" then
        QBCore.Functions.Notify({ text = message, caption = title}, type, 5000)
    elseif Config.Framework == "ESX" then
        exports['sd-notify']:Notify(title, message, 5000, type)
    end
end

Config.Stashes = {
    ['YourStashName'] = {
        coords = vector3(-495.47, -250.88, 34.78),
        length = 1.0,
        width = 1.0,
        height = 1.0,
        heading = 25,
        label = 'Open Stash',
        icon = 'fa-solid fa-box-open',
        weight = 4000000,
        slots = 25,
        pin = true,
        -- job = 'police'
        -- citizenid = 'JFD98238'
    }
}

if IsDuplicityVersion() then
    Config.Pin = {
        ['YourStashName'] = 1234, 
    }
end