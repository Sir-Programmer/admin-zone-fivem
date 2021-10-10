ESX = nil
local blips = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("AdminZone:setCoords")
AddEventHandler("AdminZone:setCoords", function(id, coords)

    if not coords then return end
    
    if blips[id] then
        blips[id].coords = coords
    else
        print("Exception happened blip id: " .. tostring(id) .. " does not exist")
    end

end)

RegisterCommand('ada', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level > 1 then

        if xPlayer.get('aduty') then
            local radius = tonumber(args[1])
            if radius then radius = radius / 1.0 else radius = 7.0 end
            local index = math.floor(TableLength() + 1)
            local blip = {id = 269, name = "Admin Area(" .. index .. ")", radius = radius, color = 32, index = tostring(index), coords = 0}
            table.insert(blips, blip)
			if radius >= 4 then
            TriggerClientEvent("SP:AdminZoneSet", -1, blip, source)
			else
			 TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Blip ID Bayad Bishtar Az 4 Bashad!")
			end
        else
            TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
        end

    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
    end
end)

RegisterCommand('cada', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
	
    if xPlayer.permission_level > 1 then

        if xPlayer.get('aduty') then

            if args[1] then
                if tonumber(args[1]) then
                    local blipID = tonumber(args[1])
                    if findArea(blipID) then
					
					    
                        TriggerClientEvent("SP:AdminZoneClear", -1, tostring(blipID))
                        SRemoveBlip(blipID)
						
						
                    else
                        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Blip ID vared shode eshtebah ast!")
                    end

                else
                    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID blip faghat mitavanid adad vared konid! Baraye Mesal /clearada 1")
                end
            else
                TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma dar ghesmat ID blip chizi vared nakardid!")
            end
              
        else
              TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
        end

    else
        TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma admin nistid!")
    end
end)

AddEventHandler('esx:playerLoaded', function(source)
    
    if #blips ~= 0 then
        for k,v in pairs(blips) do
            if v.coords ~= 0 then
                TriggerClientEvent("SP:AdminZoneSet", source, v)
            end
        end
    end

end)






function findArea(areaID)
    for k,v in pairs(blips) do
        if k == areaID then
            return true
        end
    end

    return false
end

function SRemoveBlip(areaID)
    blips[areaID] = nil
end

function TableLength()

    if #blips == 0 then
        return 0
    else
        return blips[#blips].index
    end

end