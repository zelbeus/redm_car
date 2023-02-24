local car = nil 

local function spawnCar(c)
  if not car then 
    local pc = GetEntityCoords(PlayerPedId())
    if c then 
      pc = c
    end
    local model, model2 = GetHashKey("coach4"), GetHashKey("fjordmodeltea")
    RequestModel(model)
    RequestModel(model2)
    while not HasModelLoaded(model) do
        Citizen.Wait(5)
    end
    while not HasModelLoaded(model2) do
      Citizen.Wait(5)
  end
    local vehicle = CreateVehicle( model, pc.x,pc.y,pc.z,1.0, 1, 1, 0)
    SetEntityAlpha(vehicle, 0)
    Wait(100)
    local obj = CreateObject(model2, pc, 1, 1, 1)
    Wait(500)
    AttachEntityToEntity(obj, vehicle, 0, 0.0, -0.22, -0.83, 0.0, 0.0, 90.0, 0, 1, 0, 0, 0, 2)
    local a = {
      vehicle = vehicle, 
      object = obj,
      engine = 0,
    }
    car = a
    SetModelAsNoLongerNeeded(model)
    SetModelAsNoLongerNeeded(model2)
  end
end

RegisterCommand(Config.Command, function(_, args)
  if Config.SpawnCommand then 
    spawnCar()
  end
end)

RegisterCommand(Config.DeleteCommand, function(_, args)
  DeleteEntity(car.vehicle)
  DeleteEntity(car.object)
  car = nil
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(5)
    if Config.CarSpawns then 
      for i,v in pairs(Config.CarSpawns) do 
        local dist = #(GetEntityCoords(PlayerPedId()) - vector3(v.pos[1], v.pos[2], v.pos[3]))
        if dist < 10.0 then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, v.pos[1], v.pos[2], v.pos[3], 0, 0, 0, 0, 0, 0, 0.3, 0.3,0.3, 126, 1, 1, 255, 0, 0, 2, 0, 0, 0, 0)
        end
        if dist < 2.0 then 
          if IsControlPressed(0, Config.Engine) then 
            spawnCar(v.spawn)
            Wait(2000)
          end
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
  Wait(1000)
  while true do
    Citizen.Wait(10)
    if car then 
      if IsPedInVehicle(PlayerPedId(), car.vehicle, 1) then 
        if IsControlPressed(0, Config.Engine) then 
          if not car.engine then 
            print("engine on")
            SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), 1, 1)
          else
            print("engine off")
            SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), 0, 1)
          end
          car.engine = not car.engine
          Wait(1500)
        end
      end
    else
      Wait(1000)
    end 
  end
end)

--------------------------------------------------------
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
    if car then 
      if car.vehicle then 
        DeleteEntity(car.vehicle)
        DeleteEntity(car.object)
      end
    end
end)