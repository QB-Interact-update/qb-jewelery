local QBCore = exports['qb-core']:GetCoreObject()
local firstAlarm = false
local smashing = false

-- Functions

local function loadParticle()
    if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
        RequestNamedPtfxAsset('scr_jewelheist')
    end
    while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
        Wait(0)
    end
    SetPtfxAssetNextCall('scr_jewelheist')
end

local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(3)
    end
end

local function validWeapon()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)
    if not Config.WhitelistedWeapons[pedWeapon] then
        return false
    end
    return true
end

local function smashVitrine(k)
    if not firstAlarm then
        TriggerServerEvent('police:server:policeAlert', 'Suspicious Activity')
        firstAlarm = true
    end

    QBCore.Functions.TriggerCallback('qb-jewellery:server:getCops', function(cops)
        if cops >= Config.RequiredCops then
            local animDict = 'missheist_jewel'
            local animName = 'smash_case'
            local ped = PlayerPedId()
            local plyCoords = GetOffsetFromEntityInWorldCoords(ped, 0, 0.6, 0)
            local pedWeapon = GetSelectedPedWeapon(ped)
            if math.random(1, 100) <= 80 and not QBCore.Functions.IsWearingGloves() then
                TriggerServerEvent('evidence:server:CreateFingerDrop', plyCoords)
            elseif math.random(1, 100) <= 5 and QBCore.Functions.IsWearingGloves() then
                TriggerServerEvent('evidence:server:CreateFingerDrop', plyCoords)
                QBCore.Functions.Notify(Lang:t('error.fingerprints'), 'error')
            end
            smashing = true
            TriggerServerEvent('qb-jewellery:server:setBusy', k)
            QBCore.Functions.Progressbar('smash_vitrine', Lang:t('info.progressbar'), Config.WhitelistedWeapons[pedWeapon]['timeOut'], false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                TriggerServerEvent('qb-jewellery:server:vitrineReward', k)
                TriggerServerEvent('police:server:policeAlert', 'Robbery in progress')
                smashing = false
                TaskPlayAnim(ped, animDict, 'exit', 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            end, function() -- Cancel
                TriggerServerEvent('qb-jewellery:server:setBusy', k)
                smashing = false
                TaskPlayAnim(ped, animDict, 'exit', 3.0, 3.0, -1, 2, 0, 0, 0, 0)
            end)
            SetEntityCoords(ped, GlobalState.QBJewelery[k].animLoc.x, GlobalState.QBJewelery[k].animLoc.y, GlobalState.QBJewelery[k].animLoc.z)
            SetEntityHeading(ped, GlobalState.QBJewelery[k].animLoc.w)
            CreateThread(function()
                while smashing do
                    loadAnimDict(animDict)
                    TaskPlayAnim(ped, animDict, animName, 3.0, 3.0, -1, 2, 0, 0, 0, 0)
                    Wait(500)
                    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'breaking_vitrine_glass', 0.25)
                    loadParticle()
                    StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', GlobalState.QBJewelery[k].coords.x, GlobalState.QBJewelery[k].coords.y, GlobalState.QBJewelery[k].coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
                    Wait(2500)
                end
            end)
        else
            QBCore.Functions.Notify(Lang:t('error.minimum_police', { value = Config.RequiredCops }), 'error')
        end
    end)
end

-- Threads

CreateThread(function()
    local Dealer = AddBlipForCoord(Config.JewelleryLocation.x, Config.JewelleryLocation.y, Config.JewelleryLocation.z)
    SetBlipSprite(Dealer, 617)
    SetBlipDisplay(Dealer, 4)
    SetBlipScale(Dealer, 0.7)
    SetBlipAsShortRange(Dealer, true)
    SetBlipColour(Dealer, 3)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Vangelico Jewelry')
    EndTextCommandSetBlipName(Dealer)
end)


CreateThread(function()
    repeat Wait(10) until GlobalState.QBJewelery ~= nil
    for k, v in pairs(GlobalState.QBJewelery) do
        local options = {
            {
                type = 'client',
                icon = 'fa fa-hand',
                label = Lang:t('general.target_label'),
                action = function()
                    if validWeapon() then
                        smashVitrine(k)
                    else
                        QBCore.Functions.Notify(Lang:t('error.wrong_weapon'), 'error')
                    end
                end,
                canInteract = function()
                    if GlobalState.QBJewelery[k].isOpened or GlobalState.QBJewelery[k].isBusy then
                        return false
                    end
                    return true
                end,
            }
        }
        if Config.UseTarget then
            exports['qb-target']:AddBoxZone('jewelstore' .. k, v.coords, 1, 1, {
                name = 'jewelstore' .. k,
                heading = 40,
                minZ = v.coords.z - 1,
                maxZ = v.coords.z + 1,
                debugPoly = false
            }, {
                options = options,
                distance = 1.5
            })
        else
            exports['qb-interact']:addInteractZone({
                name = 'jewelstore' .. k,
                coords = v.coords,
                length = v.size.length,
                width = v.size.width,
                heading = v.size.rotation,
                options = options,
                debugPoly = false,
            })
        end
    end
end)