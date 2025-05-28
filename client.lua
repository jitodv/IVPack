--(ES) Lista de modelos de vehículos de GTA IV
--(ES) Esta lista incluye vehículos que podrían aparecer en el juego, representando una variedad de tipos y estilos

--(EN) List of GTA IV vehicle models
--(EN) This list includes vehicles that could appear in the game, representing a variety of types and styles

local ivVehicles = {
    "admiral", "angel", "blade2", "bobcat", "bodhi", "boxville6", "brickade2", "buccaneer3", "bus2", "cabby",
    "chavos", "chavos2", "cheetah3", "contender2", "coquette4", "df8", "diabolus", "double2", "emperor5", "esperanto",
    "feltzer", "feroci", "feroci2", "flatbed2", "floater", "fortune", "freeway", "futo2", "fxt", "ghawar",
    "hakuchou3", "hakumai", "hellfury", "huntley2", "interceptor", "jb7002", "lokus", "lycan", "lycan2", "marbelle",
    "merit", "mrtasty", "nightblade2", "noose", "nrg900", "nstockade", "packer2", "perennial", "perennial2", "phoenix2",
    "pinnacle", "pmp600", "police6", "police7", "police8", "polpatriot", "premier2", "pres", "pres2", "pstockade",
    "rancher", "rebla", "reefer", "regina2", "regina3", "revenant", "rom", "sabre", "sabre2", "schafter",
    "schaftergtr", "sentinel5", "smuggler", "solair", "sovereign2", "stanier2", "steed", "stratum2", "stretch2", "stretch3",
    "sultan2", "superd2", "supergt", "taxi2", "taxi3", "tourmav", "turismo", "typhoon", "uranus", "vigero3",
    "vincent", "violator", "voodoo3", "wayfarer", "willard", "wolfsbane2", "yankee", "yankee2"
}

--(ES) Lista de modelos de peds que pueden aparecer en los vehículos
--(ES) Estos modelos son representativos de los NPCs que podrían aparecer en GTA IV

--(EN) List of ped models that can appear in vehicles
--(EN) These models are representative of the NPCs that could appear in GTA IV

local pedModels = {
    "a_m_m_business_01", "a_m_m_eastsa_01", "a_m_m_hillbilly_01", "a_m_m_og_boss_01", "a_m_m_soucent_01",
    "a_m_y_beach_01", "a_m_y_business_01", "a_m_y_epsilon_01", "a_m_y_genstreet_01", "a_m_y_hipster_01",
    "a_m_y_motox_01", "a_m_y_roadcyc_01", "a_f_m_bevhills_01", "a_f_m_bodybuild_01", "a_f_m_fatbla_01",
    "a_f_m_ktown_01", "a_f_y_beach_01", "a_f_y_hipster_01", "a_f_y_soucent_01"
}

--(ES) Clasificación de vehículos especiales
--(EN) Classification of special vehicles

local boats = { smuggler = true, reefer = true, floater = true } 
local aircrafts = { tourmav = true, ghawar = true }


--(ES) Intervalo de tiempo entre apariciones de vehículos (en milisegundos)
--(EN) Time interval between vehicle spawns (in milliseconds)
local spawnInterval = 5000 

-- (ES) Número máximo de vehículos IV que se pueden generar 
--(EN) Maximum number of IV vehicles that can be spawned
local maxIVVehicles = 100 

--(ES) Lista para almacenar vehículos generados
--(EN) List to store spawned vehicles
local spawnedVehicles = {} 


--(ES) Funciones para obtener posiciones aleatorias en el mapa
--(EN) Functions to get random positions on the map

function GetRandomStreetPosition()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local found, outPos, outHeading = GetClosestVehicleNode(
        playerPos.x + math.random(-200,200),
        playerPos.y + math.random(-200,200),
        playerPos.z, 1, 3.0, 0)
    if found then
        return outPos, outHeading
    else
        return nil, nil
    end
end

--(ES) Función para obtener una posición aleatoria en el agua
--(EN) Function to get a random position in the water

function GetRandomWaterPosition()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    for i = 1, 20 do
        local x = playerPos.x + math.random(-500,500)
        local y = playerPos.y + math.random(-500,500)
        local water, z = GetWaterHeight(x, y, playerPos.z)
        if water then
            return vector3(x, y, z + 1.0), 0.0
        end
    end
    return nil, nil
end

--(ES) Función para obtener una posición aleatoria en un aeropuerto
--(EN) Function to get a random position at an airport

function GetRandomAirportPosition()
    local airportSpawns = {
        { pos = vector3(-1336.0, -3044.0, 13.9), heading = 330.0 }, -- LSIA
        { pos = vector3(1750.0, 3250.0, 41.0), heading = 90.0 },    -- Sandy Shores
        { pos = vector3(-940.0, -2955.0, 13.9), heading = 60.0 }    -- LSIA
    }
    local spawn = airportSpawns[math.random(#airportSpawns)]
    return spawn.pos, spawn.heading
end

--(ES) Función para generar un vehículo del script IVPACK
--(EN) Function to spawn a vehicle from the IVPACK script

function SpawnIVVehicle()
    if #spawnedVehicles >= maxIVVehicles then return end

    local modelName
    repeat
        modelName = ivVehicles[math.random(#ivVehicles)]
    until true 

    local modelHash = GetHashKey(modelName)
    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 100 do
        Citizen.Wait(50)
        timeout = timeout + 1
    end
    if not HasModelLoaded(modelHash) then return end

    local pos, heading

    if boats[modelName] then
        pos, heading = GetRandomWaterPosition()
    elseif aircrafts[modelName] then
        pos, heading = GetRandomAirportPosition()
    else
        pos, heading = GetRandomStreetPosition()
    end

    if pos then
        local veh = CreateVehicle(modelHash, pos.x, pos.y, pos.z, heading or 0.0, true, false)
        SetVehicleOnGroundProperly(veh)
        SetEntityAsMissionEntity(veh, true, true)
        SetVehicleHasBeenOwnedByPlayer(veh, false)
        SetVehicleNeedsToBeHotwired(veh, false)
        SetVehicleDoorsLocked(veh, 0)
        SetVehicleIsConsideredByPlayer(veh, false)
        local pedModel = pedModels[math.random(#pedModels)]
        RequestModel(GetHashKey(pedModel))
        while not HasModelLoaded(GetHashKey(pedModel)) do Citizen.Wait(10) end
        local ped = CreatePedInsideVehicle(veh, 4, GetHashKey(pedModel), -1, true, false)
        SetPedRandomComponentVariation(ped, true)
        SetPedRandomProps(ped)
        SetPedCanBeDraggedOut(ped, false)
        SetPedFleeAttributes(ped, 0, false)
        if not boats[modelName] and not aircrafts[modelName] then
            TaskVehicleDriveWander(ped, veh, 30.0, 786603)
        end
        SetPedAsNoLongerNeeded(ped)
        SetEntityAsNoLongerNeeded(veh)
        table.insert(spawnedVehicles, veh)
    end
    SetModelAsNoLongerNeeded(modelHash)
end

-- (ES) Función para limpiar vehículos IV que están demasiado lejos del jugador
-- (EN) Function to clean up IV vehicles that are too far from the player

function CleanupIVVehicles()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    for i = #spawnedVehicles, 1, -1 do
        local veh = spawnedVehicles[i]
        if not DoesEntityExist(veh) or #(GetEntityCoords(veh) - playerPos) > 1000.0 then
            if DoesEntityExist(veh) then
                DeleteEntity(veh)
            end
            table.remove(spawnedVehicles, i)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        SpawnIVVehicle()
        CleanupIVVehicles()
        Citizen.Wait(spawnInterval)
    end
end)

