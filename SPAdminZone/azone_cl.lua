
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

local blips = {}


function missionTextDisplay(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

local function RGBRainbow( frequency )
	local result = {}
	local curtime = GetGameTimer() / 1000

	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	
	return result
end

function Draw3DText(x,y,z, text,scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString("~a~"..text)
        DrawText(_x,_y)
    end
end

RegisterNetEvent('SP:AdminZoneSet')
AddEventHandler("SP:AdminZoneSet", function(blip, s)
    missionTextDisplay("~r~RP PAUSE ~o~| ~g~MANTAGHE: ADMIN AREA (" .. tonumber(blip.index) ..") ~o~| ~r~ADMIN: " .. GetPlayerName(GetPlayerFromServerId(s)), 4000)
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    ax = x
    ay = y
    az = z
    if s ~= nil then
        src = s
        coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
		coordss = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(-1)))
    else
        coords = blip.coords
    end
    if not blips[blip.index] then
        blips[blip.index] = {}
    end
    if not givenCoords then
        TriggerServerEvent('AdminZone:setCoords', tonumber(blip.index), coords)
    end
    blips[blip.index]["blip"] = AddBlipForCoord(coords.x, coords.y, coords.z)
    blips[blip.index]["radius"] = AddBlipForRadius(coords.x, coords.y, coords.z, blip.radius)
    SetBlipSprite(blips[blip.index].blip, blip.id)
    SetBlipAsShortRange(blips[blip.index].blip, true)
    SetBlipColour(blips[blip.index].blip, blip.color)
    SetBlipScale(blips[blip.index].blip, 1.3)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(blip.name)
    EndTextCommandSetBlipName(blips[blip.index].blip)
    blips[blip.index]["coords"] = coords
    SetBlipAlpha(blips[blip.index]["radius"], 80)
    SetBlipColour(blips[blip.index]["radius"], blip.color)
	blips[blip.index]["active"] = true
	while blips[blip.index]["active"] do
	 Wait(0)
	 local radius = blip.radius
	 local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
     rgb = RGBRainbow(1)
	 DrawMarker(28, blips[blip.index]["coords"], 0.0, 0.0, 0.0, 0, 0.0, 0.0, blip.radius-1.5, blip.radius-1.5, blip.radius-1.5, rgb.r, rgb.g, rgb.b, 150, false, false, 2, false, false, false, false)
        if blips[blip.index]["coords"] ~= nil then
            source = s
			if GetDistanceBetweenCoords(x, y, z, blips[blip.index]["coords"], true) <= radius then
				SetCurrentPedWeapon(GetPlayerPed(-1),GetHashKey("WEAPON_UNARMED"),true)
                SetCurrentPedWeapon(GetPlayerPed(-1),GetHashKey("WEAPON_UNARMED"),true)
				DisableControlAction(0,37,true) 
				DisableControlAction(0,24,true) 
				DisableControlAction(0,205,true) 
				DisableControlAction(0,200,true) 
				DisableControlAction(0,170,true) 
				DisableControlAction(0,44,true) 
				DisableControlAction(0,25,true) 
				Draw3DText(x,y,z, "~b~[~w~RP PAUSE ~g~(" .. tonumber(blip.index) ..  ")~b~]", 0.7)
		    end
        end
    end
end)

RegisterNetEvent('SP:AdminZoneClear')
AddEventHandler("SP:AdminZoneClear", function(blipID)
    if blips[blipID] then
	    blips[blipID]["active"] = false
		RemoveBlip(blips[blipID].blip)
        RemoveBlip(blips[blipID].radius)
        blips[blipID] = nil
		missionTextDisplay("~p~RP UNPAUSE ~o~| ~g~MANTAGHE: ADMIN AREA (" .. blipID .. ") ~o~| ~p~MANTAGHE AZAD SHOD", 4000) 
    else
        print("There was a issue with removing blip: " .. tostring(blipID))
    end
end)