lib.locale()

RegisterNetEvent('yettiLives:client:showWarning', function (livesleft)
    lib.alertDialog({
        header = locale("warning_title"),
        content = string.format(locale("warning_text"), livesleft),
        centered = true,
        cancel = false
    })
end)

RegisterNetEvent('yettiLives:client:lifesleft', function (lifesleft, lifesused)
    lib.alertDialog({
        header = locale("admin_check_title"),
        content = string.format(locale("admin_check_description", lifesused, lifesleft)),
        centered = true,
        cancel = false
    })
end)