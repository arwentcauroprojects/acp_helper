function IsClient()
    return not IsDuplicityVersion()
end

function ShowHelpText(string, loop, beep, duration)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(string)
    DisplayHelpTextFromStringLabel(0, loop and loop or false, beep and beep or false, duration and duration or 5000)
end

function ShowMarker(type, pos, dir, rot, scale, r, g, b, a, jumping, faceCamera, rotate, texture, name, fn)
    if IsClient() then
        -- Need to set up a config file for changing display distance
        -- Default distance: 10
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), pos, true) < 10 then
            DrawMarker(type, pos and pos.x or 0.0, pos and pos.y or 0.0, pos and pos.z or 0.0, dir and dir.x or 0.0,
                dir and dir.y or 0.0, dir and dir.z or 0.0, rot and rot.x or 0.0, rot and rot.y or 0.0,
                rot and rot.z or 0.0, scale and scale.x or 1.0, scale and scale.y or 1.0, scale and scale.z or 1.0,
                r and r or 255, g and g or 255, b and b or 255, a and a or 255, jumping and jumping or false,
                faceCamera and faceCamera or false, 2, rotate and rotate or false, texture and texture.dict or nil,
                texture and texture.name or nil, false)

            if fn then
                -- Need to set up a config file for changing inputable distance
                -- Default distance: 2 (w/o vehicle)
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), pos, true) < 2 then
                    ShowHelpText(string.format("Appuyez sur ~INPUT_CONTEXT~ pour %s.",
                                            name and name or "~h~non trouvé~h~"), false, true, -1)

                    if IsControlJustPressed(0, 51) then
                        fn()
                    end
                end
            end
        end
    end
end

function ShowAdvancedNotification(message, pic, flash, iconType, nameStr, subStr, duration)
    if IsClient() then
        if not HasStreamedTextureDictLoaded(pic) then
            RequestStreamedTextureDict(pic)

            while not HasStreamedTextureDictLoaded(pic) do
                Citizen.Wait(1)
            end
        end

        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(message)
        EndTextCommandThefeedPostMessagetextTu(pic, pic, flash, iconType, nameStr, subStr, duration)

        SetStreamedTextureDictAsNoLongerNeeded(pic)
    end
end

function ShowSubtitle(string, duration)
    BeginTextCommandPrint("STRING")
    EndTextCommandPrint(duration, true)
end

function GetPedHeadshot()
    local _a = RegisterPedheadshot(PlayerPedId())
    while not IsPedheadshotReady(_a) do
        Wait(0)
    end
    local _b = GetPedheadshotTxdString(_a)
    
    Citizen.SetTimeout(10000, function()
        SetStreamedTextureDictAsNoLongerNeeded(_b)
    end)

    return _b
end

function SpawnVehicle(vehicle, pos, heading)
    if IsClient() then
        if not HasModelLoaded(vehicle) then
            RequestModel(vehicle)

            while not HasModelLoaded(vehicle) do
                Citizen.Wait(1)
            end
        end

        local _vehicle = CreateVehicle(vehicle, pos.x, pos.y, pos.z, heading and heading or 0, false, false)
        return _vehicle
    end
end

-- Please keep this watermark.
print("")
print("_____________________________________________________________________")
print("")
print("          _____ _____    _    _ ______ _      _____  ______ _____  ")
print("    /\\   / ____|  __ \\  | |  | |  ____| |    |  __ \\|  ____|  __ \\ ")
print("   /  \\ | |    | |__) | | |__| | |__  | |    | |__) | |__  | |__) |")
print("  / /\\ \\| |    |  ___/  |  __  |  __| | |    |  ___/|  __| |  _  / ")
print(" / ____ \\ |____| |      | |  | | |____| |____| |    | |____| | \\ \\ ")
print("/_/    \\_\\_____|_|      |_|  |_|______|______|_|    |______|_|  \\_\\")
print(" ")
print(string.format("^2%s-side^7 - ^3%s - ^1ESX edition^7", IsDuplicityVersion() and "server" or "client", GetResourceMetadata("acp_helper", "version", 0)))
print(string.format("^3you are running helper on \"%s\" resource.^7", ...))
print("")
print("_____________________________________________________________________")
print("")