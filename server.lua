local vehicleData = {}
local playerVehicles = {}

addEventHandler("onResourceStart", resourceRoot,
function ()
	if tonumber (getServerConfigSetting("bullet_sync")) ~= 1 then
		cancelEvent()
		outputDebugString("Please enable bullet_sync in mtaserver.conf - https://wiki.mtasa.com/wiki/Server_mtaserver.conf#bullet_sync", 2)
	end
end)

addEventHandler("onPlayerWeaponFire", root,
	function(weapon, endX, endY, endZ, _, startX, startY, startZ)
		if settings.weapon == "all" or isValueInTable(settings.weapon, weapon) then
			local matrix = Matrix.create(source.position, Vector3(findRotation3D(startX, startY, startZ, endX, endY, endZ)))
			local veh = Vehicle(settings.vehicleIds[math.random(#settings.vehicleIds)], matrix.position + matrix.forward * 4)
			if not veh then return end -- for some unknown reason MTA does not create the vehicle in the first shot
			veh:setColor(math.random(255), math.random(255), math.random(255))
			veh.rotation = Vector3(findRotation3D(startX, startY, startZ, endX, endY, endZ))
			veh:setVelocity(matrix.forward * settings.vehicleSpeed)
			veh.locked = settings.lockVehicle
			--setVehicleTurnVelocity(veh,matrix.forward / 5)
			vehicleData[veh] = {setTimer(destroyElement, settings.destoryAfter, 1, veh), source}

			if not playerVehicles[source] then
				playerVehicles[source] = {}
			end
			table.insert(playerVehicles[source], veh)
			while #playerVehicles[source] > settings.maxVehicles do
				local firstVehicle = playerVehicles[source][1]
				table.remove(playerVehicles[source], 1)
				if isElement(firstVehicle) then
					firstVehicle:destroy()
				end
			end
		end
	end
)

addEventHandler("onPlayerQuit", root,
function()
		if playerVehicles[source] then
			for i, veh in ipairs(playerVehicles) do
				veh:destroy()
			end
			playerVehicles[source] = nil
		end
	end
)

addEventHandler("onElementDestroy", resourceRoot,
function()
		if getElementType(source) == "vehicle" and vehicleData[source] then
			local timer = vehicleData[source][1]
			if isTimer(timer) then
				killTimer(timer)
			end
			local player = vehicleData[source][2]
			if isElement(player) and playerVehicles[player] then
				for i, veh in ipairs(playerVehicles[player]) do
					if source == veh then
						table.remove(playerVehicles[player], i)
						break
					end
				end
			end
			vehicleData[source] = nil
		end
	end
)

addEventHandler("onVehicleStartEnter", resourceRoot,
function()
	if source.locked then
		local vehicleType = source.vehicleType
		if vehicleType == "Bike" or vehicleType == "BMX" or vehicleType == "Quad" or vehicleType == "Boat" then
			cancelEvent()
		end
	end
end)

function findRotation3D(x1, y1, z1, x2, y2, z2)
	local rotx = math.atan2(z2 - z1, getDistanceBetweenPoints2D(x2, y2, x1, y1))
	rotx = math.deg(rotx)
	local rotz = -math.deg(math.atan2(x2 - x1, y2 - y1))
	rotz = rotz < 0 and rotz + 360 or rotz
	return rotx, 0, rotz
end

function isValueInTable(t, v)
	for i = 1, #t do
		if v == tonumber(t[i]) then
			return true
		end
	end
end
