local QBCore = exports['qb-core']:GetCoreObject()
lib.locale()

RegisterNetEvent('yettiLives:server:removeLife', function (playerId)
    if source then
        DropPlayer(source, 'Attempted Cheating - removing a life')
    end
    local src = playerId
    local patient = QBCore.Functions.GetPlayer(src)
    local cid = patient.PlayerData.citizenid
    if cid then
        MySQL.insert.await( 'INSERT INTO `player_lives` (citizenid, lives_spent) VALUES (?, ?) ON DUPLICATE KEY UPDATE citizenid = ?', {
            cid, 0, cid
        })

        local data = MySQL.single.await('SELECT `lives_spent` FROM `player_lives` WHERE `citizenid` = ? LIMIT 1', {
            cid
        })

        MySQL.update.await('UPDATE player_lives SET lives_spent = ? WHERE citizenid = ?', {
            data.lives_spent + 1, cid
        })

        TriggerClientEvent('yettiLives:client:showWarning', src, Config.AmountOfLives - data.lives_spent)
        if data.lives_spent >= Config.AmountOfLives then
            DropPlayer(src, locale("character_deleted_message"))
            Wait(2000) -- QBCore backs up player data when players leave, this should bypass that
            MySQL.query('DELETE FROM players WHERE citizenid = ?', { cid })
        end
    end
end)

lib.addCommand('checklifes', {
    help = locale("checklifes_help"),
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = locale("checklifes_help_target"),
        }
    },
    restricted = Config.AdminPerms
}, function(source, args, raw)
    local target = args.target
    local targetPlayer = QBCore.Functions.GetPlayer(target)
    local cid = targetPlayer.PlayerData.citizenid

    local spent
    local data = MySQL.single.await('SELECT `lives_spent` FROM `player_lives` WHERE `citizenid` = ? LIMIT 1', {
        cid
    })

    if data then
        spent = data.lives_spent
    else
        spent = 0
    end

    TriggerClientEvent('yettiLives:client:lifesleft', source, Config.AmountOfLives - spent ,spent)
end)

lib.addCommand('addlife', {
    help = locale("addlife_help"),
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = locale("addlife_help_target"),
        },
        {
            name = 'lifes',
            type = 'lifesAmount',
            help = locale("addlife_help_lifesAmount"),
        },
    },
    restricted = Config.AdminPerms
}, function(source, args, raw)
    local target = args.target
    local targetPlayer = QBCore.Functions.GetPlayer(target)
    local cid = targetPlayer.PlayerData.citizenid

    local spent
    local data = MySQL.single.await('SELECT `lives_spent` FROM `player_lives` WHERE `citizenid` = ? LIMIT 1', {
        cid
    })

    if data then
        spent = data.lives_spent
    else
        spent = 0
    end

    MySQL.update.await('UPDATE player_lives SET lives_spent = ? WHERE citizenid = ?', {
        spent - args.lifes, cid
    })
    TriggerClientEvent('ox_lib:notify', source, { type = 'success', description = string.format(locale("notify_lifechange"), target) })
end)
