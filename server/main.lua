local QBCore = exports['qb-core']:GetCoreObject()
local timeOut = false

local cachedPoliceAmount = nil
local flags = {}

-- Callback
local function resetCopCache()
    CreateThread(function()
        while true do
            Wait(60 * 1000)
            cachedPoliceAmount = 0
        end
    end)
end
QBCore.Functions.CreateCallback('qb-jewellery:server:getCops', function(source, cb)
    local amount = 0
    if cachedPoliceAmount ~= nil then
        cb(cachedPoliceAmount)
        return
    end
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if (v.PlayerData.job.name == 'police' or v.PlayerData.job.type == 'leo') and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    cachedPoliceAmount = amount
    resetCopCache()
    cb(amount)
end)

-- Functions

local function exploitBan(id, reason)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            GetPlayerName(id),
            QBCore.Functions.GetIdentifier(id, 'license'),
            QBCore.Functions.GetIdentifier(id, 'discord'),
            QBCore.Functions.GetIdentifier(id, 'ip'),
            reason,
            2147483647,
            'qb-jewelery'
        })
    TriggerEvent('qb-log:server:CreateLog', 'jewelery', 'Player Banned', 'red',
        string.format('%s was banned by %s for %s', GetPlayerName(id), 'qb-jewelery', reason), true)
    DropPlayer(id, 'You were permanently banned by the server for: Exploiting')
end

local function checkDistance(src, location, distance)
    local pedCoords = GetEntityCoords(GetPlayerPed(src))
    local dist = #(pedCoords - vector3(location.x, location.y, location.z))

    if dist <= distance then
        return true
    end
    local Player = QBCore.Functions.GetPlayer(src)
    local Id = Player.PlayerData.citizenid
    if flags[Id] then
        flags[Id] = flags[Id] + 1
        if flags[Id] >= 3 then
            exploitBan(src, 'Failing 3 distance checks in qb-jewelery')
        end
    else
        flags[Id] = 1
    end
    return false
end

local function getRewardBasedOnProbability(table)
    local random, probability = math.random(), 0

    for k, v in pairs(table) do
        probability = probability + v.probability
        if random <= probability then
            return k
        end
    end

    return math.random(#table)
end

-- Events
RegisterNetEvent('qb-jewellery:server:setBusy', function(k)
    local src = source
    if not Locations[k] then return end
    if not checkDistance(src, Locations[k].coords, 5.0) then
        return
    end
    Locations[k].isBusy = not Locations[k].isBusy
    GlobalState.QBJewelery = Locations
end)

local function setTakenStates(index)
    Locations[index].isOpened = true
    Locations[index].isBusy = false
    GlobalState.QBJewelery = Locations
    CreateThread(function()
        Wait(Config.Timeout)
        Locations[index].isOpened = false
        GlobalState.QBJewelery = Locations
    end)
end

RegisterNetEvent('qb-jewellery:server:vitrineReward', function(vitrineIndex)
    local src = source

    if not Config.WhitelistedWeapons[GetCurrentPedWeapon(GetPlayerPed(src))] then
        Locations[vitrineIndex].isBusy = false
        GlobalState.QBJewelery = Locations
        print('[WARNING] Exploit attempt blocked: qb-jewellery:server:vitrineReward - Invalid Weapon SOURCE: ' .. src)
        return
    end

    if Locations[vitrineIndex] == nil or Locations[vitrineIndex].isOpened ~= false then
        print('[WARNING] Exploit attempt blocked: qb-jewellery:server:vitrineReward - Invalid Vitrine SOURCE: ' .. src)
        return
    end

    if cachedPoliceAmount < Config.RequiredCops then
        Locations[vitrineIndex].isBusy = false
        GlobalState.QBJewelery = Locations
        print('[WARNING] Exploit attempt blocked: qb-jewellery:server:vitrineReward - Not enough cops SOURCE: ' .. src)
        return
    end

    if not checkDistance(src, Locations[vitrineIndex].coords, 5.0) then
        Locations[vitrineIndex].isBusy = false
        GlobalState.QBJewelery = Locations
        print('[WARNING] Exploit attempt blocked: qb-jewellery:server:vitrineReward - Invalid Distance SOURCE: ' .. src)
        return
    end
    setTakenStates(vitrineIndex)
    local item = getRewardBasedOnProbability(VitrineRewards)
    local amount = math.random(VitrineRewards[item].amount.min, VitrineRewards[item].amount.max)
    if exports['qb-inventory']:AddItem(src, VitrineRewards[item].item, amount, false, false, 'qb-jewellery:server:vitrineReward') then
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[VitrineRewards[item].item], 'add', amount)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.to_much'), 'error')
    end
end)

