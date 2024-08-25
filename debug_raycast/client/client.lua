-- TraceFlags
--   None = 0,
--   IntersectWorld = 1,
--   IntersectVehicles = 2,
--   IntersectPedsSimpleCollision = 4,
--   IntersectPeds = 8,
--   IntersectObjects = 16,
--   IntersectWater = 32,
--   Unknown = 128,
--   IntersectFoliage = 256,
--   IntersectEverything = 4294967295 or -1
local raycastFlag = 4294967295
local raycastLenght = 20
local bitMask = 4

local glm = require 'glm'

local screen = {}

local glm_rad = glm.rad
local glm_quatEuler = glm.quatEulerAngleZYX
local glm_rayPicking = glm.rayPicking

-- Cache direction vectors
local glm_up = glm.up()
local glm_forward = glm.forward()

local function ScreenPositionToCameraRay()
	local pos = GetFinalRenderedCamCoord()
	local rot = glm_rad(GetFinalRenderedCamRot(2))
	local q = glm_quatEuler(rot.z, rot.y, rot.x)
	return pos, glm_rayPicking(
		q * glm_forward,
		q * glm_up,
		glm_rad(screen.fov),
		screen.ratio,
		0.10000, -- GetFinalRenderedCamNearClip(),
		10000.0, -- GetFinalRenderedCamFarClip(),
		0, 0
	)
end

local function DebugCollision(playerCoords, endCoords, markerColor)
  DrawMarker(28, endCoords.x, endCoords.y, endCoords.z, 0, 0, 0, 0.0, 0, 0, 0.1, 0.1, 0.1, markerColor.r, markerColor.g, markerColor.b, markerColor.a, false, true, 2, false, nil, nil, false)
  DrawLine(playerCoords.x, playerCoords.y, playerCoords.z, endCoords.x, endCoords.y, endCoords.z, 255, 255, 255, 100)
end


CreateThread(function()
  screen.ratio = GetAspectRatio(true)
	screen.fov = GetFinalRenderedCamFov()

  local current_entity = nil
  local looking_ped = false
  local color = {r = 255, g = 0, b = 0, a = 100}
  while true do
    Wait(0)
    local playerPed = PlayerPedId()

    local rayPos, rayDir = ScreenPositionToCameraRay()
    local destination = rayPos + raycastLenght * rayDir
    local raycast = StartExpensiveSynchronousShapeTestLosProbe(rayPos.x, rayPos.y, rayPos.z, destination.x, destination.y, destination.z, raycastFlag, playerPed, bitMask)
    local _, hit, endCoords, surface, entityHit = GetShapeTestResult(raycast)
    local entityType = GetEntityType(entityHit)

    local targetCoord = destination

    if hit == 1 then
      color = {r = 0, g = 255, b = 0, a = 100}
      targetCoord = endCoords
      if current_entity ~= entityHit then
        if entityType == 1 then
          SetEntityDrawOutline(current_entity, false)
          looking_ped = true
          SendNUIMessage({
            type = 'ENTITY-DATA',
            visiblity = looking_ped,
            entityModel = entityHit,
            entityHealth = GetEntityHealth(entityHit),
            entityRotation =  math.floor(GetEntityHeading(entityHit)),
          })
        else
          looking_ped = false
          SetEntityDrawOutline(entityHit, true)
          SetEntityDrawOutline(current_entity, false)
          SendNUIMessage({
            type = 'ENTITY-DATA',
            visiblity = looking_ped,
          })
        end
        current_entity = entityHit
      end
    else
      color = {r = 255, g = 0, b = 0, a = 100}
      looking_ped = false
      if current_entity then
        if entityType ~= 1 then
          SetEntityDrawOutline(current_entity, false)
        end
        current_entity = nil
      end
      SendNUIMessage({
        type = 'ENTITY-DATA',
        visiblity = looking_ped,
      })
    end


    local targetCoord = destination
    if endCoords ~= vector3(0.0, 0.0, 0.0) then
      targetCoord = endCoords
    end

    DebugCollision(rayPos, targetCoord, color)


    SendNUIMessage({
      type = 'RAYCAST',
      hit = hit,
      endCoords = string.format("%.2f, %.2f, %.2f", endCoords.x, endCoords.y, endCoords.z),
      surface = string.format("%.2f, %.2f, %.2f", surface.x, surface.y, surface.z),
      entityHit = entityHit,
      entityType = entityType
    })
  end
end)