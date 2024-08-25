local data = {
  health = 0,
  armour = 0,
  position = '',
  heading = 0,
  speed = 0,
}


Citizen.CreateThread(function()
  while true do
    Wait(0)
    local playerPed = PlayerPedId()
    local position = GetEntityCoords(playerPed)
    data.health = GetEntityHealth(playerPed)
    data.armour = GetPedArmour(playerPed)
    data.position = 'x: ' .. (math.floor(position.x * 100) / 100) .. ' y: ' .. (math.floor(position.y * 100) / 100) .. ' z: ' .. (math.floor(position.z * 100) / 100)
    data.heading = math.floor(GetEntityHeading(playerPed))
    data.speed = math.floor(GetEntitySpeed(playerPed) * 100) / 100
    SendNUIMessage({
      type = 'PLAYER-DATA',
      health = data.health,
      armour = data.armour,
      position = data.position,
      heading = data.heading,
      speed = data.speed
    })
  end
end)