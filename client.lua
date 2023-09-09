----------------------------MENU----------------------------
MenuData = {}
TriggerEvent(""..Config.menuapi..":getData",function(call)
    MenuData = call
end)
----------------------------END MENU----------------------------
local car = nil 
local menuOpen = false
--------------------------------------------------------------------------------------------------------------------------------------------
local function SetLightIntensityForObject(ob, b)
  Citizen.InvokeNative(0xF49574E2332A8F06, ob, b)
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function GetObjectLightIntensity(ob)
  Citizen.InvokeNative(0x3397CD4E0353DFBA, ob)
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function SetLightsColorForEntity(ob, r,g,b)
  Citizen.InvokeNative(0x6EC2A67962296F49, ob, r,g,b)
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function Horn(cc)
  local counter = 1
  while not Citizen.InvokeNative(0xD9130842D7226045, "Horns_Bugle_Sounds",0) and counter <= 100 do
      counter = counter + 1
      Citizen.Wait(0)
  end
  Citizen.InvokeNative(0xCCE219C922737BFA,"long", cc.x, cc.y, cc.z-1.0, "Horns_Bugle_Sounds", true, 0, true, 0)
  Wait(1000)
  Citizen.InvokeNative(0x531A78D6BF27014B,"Horns_Bugle_Sounds")
end
--------------------------------------------------------------------------------------------------------------------------------------------
function GetRedMCar()
  return car
end
--------------------------------------------------------------------------------------------------------------------------------------------
local function spawnCar(c, md, engine)
  if not car then 
    local pc = GetEntityCoords(PlayerPedId())
    if c then 
      pc = c
    end
    local model, model2 = GetHashKey("coach4"), GetHashKey("fjordmodeltea")
    local attach = {0.0, -0.22, -0.83, 0.0, 0.0, 90.0}
    if md then 
      if md.model then 
        model2 = md.model
      end
      if md.attach then 
        attach = md.attach
      end
    end
    RequestModel(model)
    RequestModel(model2)
    while not HasModelLoaded(model) do
        Citizen.Wait(5)
    end
    while not HasModelLoaded(model2) do
      Citizen.Wait(5)
  end
    local vehicle = CreateVehicle( model, pc.x,pc.y,pc.z, (pc.h or 1.0), 1, 1, 0)
    Wait(200)
    FreezeEntityPosition(vehicle, 1)
    SetEntityVisible(vehicle, 0)
    Wait(200)
    local obj = CreateObject(model2, pc.x, pc.y, pc.z, 1, 1, 1)
    Wait(300)
    
    AttachEntityToEntity(obj, vehicle, 0, attach[1], attach[2], attach[3], attach[4], attach[5], attach[6], 0, 1, 0, 0, 0, 2)
    local hobj, hobj2, hobj3
    if md then 
      if md.model == GetHashKey("fjordmodeltea") then 
        local model3 = GetHashKey("p_steamerlight01x")
        RequestModel(model3)
        while not HasModelLoaded(model3) do
          Citizen.Wait(5)
        end
        hobj, hobj2, hobj3 = CreateObject(GetHashKey("p_stageshelllight_red01x"), pc.x, pc.y, pc.z, 1, 1, 1), CreateObject(model3, pc.x, pc.y, pc.z, 1, 1, 1), CreateObject(model3, pc.x, pc.y, pc.z, 1, 1, 1)
        Wait(100)
        local attaches = {
          [1] = {-1.76, -0.42, 0.87, -40.0, 0.0, 90.0, "Back"},
          [2] = {1.69, 0.48, 0.99, 0.0, 0.0, 270.0, "Front Left"},
          [3] = {1.69, -0.5, 0.99, 0.0, 0.0, 270.0, "Front Right"},
        }
        Wait(100)
        AttachEntityToEntity(hobj, obj, 0, attaches[1][1], attaches[1][2], attaches[1][3], attaches[1][4], attaches[1][5], attaches[1][6], 0, 1, 0, 0, 0, 2)
        AttachEntityToEntity(hobj2, obj, 0, attaches[2][1], attaches[2][2], attaches[2][3], attaches[2][4], attaches[2][5], attaches[2][6], 0, 1, 0, 0, 0, 2)
        AttachEntityToEntity(hobj3, obj, 0, attaches[3][1], attaches[3][2], attaches[3][3], attaches[3][4], attaches[3][5], attaches[3][6], 0, 1, 0, 0, 0, 2)
        SetModelAsNoLongerNeeded(model3)
        SetLightIntensityForObject(hobj2, 0.0)
        SetLightIntensityForObject(hobj3, 0.0)
        SetLightIntensityForObject(hobj, 0.0)

      end
    end
    local a = {
      vehicle = vehicle, 
      object = obj,
      engine = false,
      speed = Config.maxspeeds[engine],
      headlights = false,
      headlight_l = hobj2, 
      headlight_r = hobj3,
      headlight_b = hobj,
      incar = false,
      curr_speed = 0,
    }
    Wait(50)
    car = a
    FreezeEntityPosition(vehicle, 0)
    SetModelAsNoLongerNeeded(model)
    SetModelAsNoLongerNeeded(model2)
  else
    TriggerEvent("Notification:redm_car", Config.Texts.Car, Config.Texts.AlreadySpawned, Config.Textures.locked[1], Config.Textures.locked[2], 2500)
  end
end
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.Command, function(_, args)
  if Config.SpawnCommand then 
    TriggerServerEvent("redm_ford:spawn_car")
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.ResetCommand, function(_, args)
  if car then 
    local dist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(car.vehicle))
    if dist < 4.0 then 
      SetEntityRotation(car.vehicle, 0.0, 0.0, 0.0, 2, 1)
    else
      TriggerEvent("Notification:redm_car", Config.Texts.Car, Config.Texts.FarAway, Config.Textures.locked[1], Config.Textures.locked[2], 2500)
    end
  else
    TriggerEvent("Notification:redm_car", Config.Texts.Car, Config.Texts.NotSpawned, Config.Textures.locked[1], Config.Textures.locked[2], 2500)
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(Config.DeleteCommand, function(_, args)
  if car then 
    DeleteEntity(car.vehicle)
    DeleteEntity(car.headlight_l)
    DeleteEntity(car.headlight_r)
    DeleteEntity(car.headlight_b)
    DeleteEntity(car.object)
    car = nil
  else
    TriggerEvent("Notification:redm_car", Config.Texts.Car, Config.Texts.NotSpawned, Config.Textures.locked[1], Config.Textures.locked[2], 2500)
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
  while true do
    Wait(5)
    if Config.CarSpawns and not menuOpen then 
      for i,v in pairs(Config.CarSpawns) do 
        local dist = #(GetEntityCoords(PlayerPedId()) - vector3(v.pos[1], v.pos[2], v.pos[3]))
        if dist < 10.0 then
            Citizen.InvokeNative(0x2A32FAA57B937173, 0x6903B113, v.pos[1], v.pos[2], v.pos[3]-0.8, 0, 0, 0, 0, 0, 0, 0.3, 0.3,0.3, 126, 1, 1, 255, 0, 0, 2, 0, 0, 0, 0)
        end
        if dist < 2.0 then 
          if IsControlPressed(0, Config.Shop) then 
            TriggerServerEvent("redm_ford:open_menu", i)
            Wait(2000)
          end
        end
      end
    else
      Wait(800)
    end
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
  Wait(1000)
  while true do
    Wait(10)
    if car then 
      if car.incar then 
        if IsControlPressed(0, Config.Horn) then 
          if car.engine and not car.horn then
            car.horn = true
            TriggerEvent("redm_ford:horn_active")
            TriggerServerEvent("redm_ford:horn",GetEntityCoords(PlayerPedId()))
          end
        end
        if IsControlPressed(0, Config.Engine) then 
          if not car.engine then 
            print("engine on")
            SetLightIntensityForObject(car.headlight_b, 1.0)
            SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), 1, 1)
          else
            print("engine off")
            car.curr_speed = 0.0
            SetVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId()), 0, 1)
            if car.headlights then 
              car.headlights = not car.headlights
              SetLightIntensityForObject(car.headlight_l, 0.0)
              SetLightIntensityForObject(car.headlight_r, 0.0)
            end
            SetLightIntensityForObject(car.headlight_b, 0.0)
          end
          car.engine = not car.engine
          Wait(1200)
        end
        if IsControlPressed(0, Config.Headlight) then 
          if car.engine then 
            if car.headlights then
              print("light off")
              SetLightIntensityForObject(car.headlight_l, 0.0)
              SetLightIntensityForObject(car.headlight_r, 0.0)
            else
              print("light on")
              SetLightIntensityForObject(car.headlight_l, 1.0)
              SetLightIntensityForObject(car.headlight_r, 1.0)
            end
            car.headlights = not car.headlights
            Wait(400)
          end
          Wait(400)
        end
      end
    else
      Wait(1000)
    end 
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
  local sound = 0
  while true do
      Wait(200)
      if car then 
          car.incar = IsPedInVehicle(PlayerPedId(), car.vehicle, 1) 
          if car.engine then 
              if Config.WeirdSmokeAndSound then 
                sound = sound + 1
                if sound == 7 then 
                  sound = 0
                  local cc = GetEntityCoords(car.vehicle)
                  AddExplosion(cc.x, cc.y, cc.z-2.9, 8, 0.0, true, false, 0)
                end
              end
              if car.incar then 
                local a = GetEntitySpeedVector(car.vehicle, 1)
                local b = a.y
                if a.y < 0 then 
                  b = a.y
                  b = b - (b+b)
                end
                car.curr_speed = string.format("%.1f", b)
                if a.y > car.speed.v1 then 
                    SetVehicleForwardSpeed(car.vehicle, car.speed.v2)
                end
                if a.y < car.speed.r1 then 
                    SetVehicleForwardSpeed(car.vehicle, car.speed.r2)
                end
              end
          end
      else
        Wait(500)
      end
  end
end)

Citizen.CreateThread(function()
  local color1, color2 = {126,0,0, 200}, {126,0,0, 200}
  while true do
    Citizen.Wait(5)
    if car and Config.NativeHUD then 
      if car.incar then 
        if car.engine then 
          color2 = {0,126,0, 200}
        else
          color2 = {126,0,0, 200}
        end
        if car.headlights then 
          color1 = {0,126,0, 200}
        else
          color1 = {126,0,0, 200}
        end
    SetTextColor(126,0,0, 215)
    SetTextScale(0.35,0.35)
    SetTextFontForCurrentCommand(0)--0,1,5,6, 9, 11, 12, 15, 18, 19, 20, 22, 24, 25, 28, 29
    SetTextCentre(1)
    local str = CreateVarString(10, "LITERAL_STRING", car.curr_speed.."km/h", Citizen.ResultAsLong())
    DisplayText(str,0.46,0.9)
    DrawSprite("INVENTORY_ITEMS", "weapon_melee_davy_lantern", 0.5, 0.9, 0.05, 0.05, 0.1, color1[1], color1[2], color1[3], color1[4], 0)
    DrawSprite("hud_textures", "gang_savings", 0.53, 0.91, 0.04, 0.04, 0.1, color2[1], color2[2], color2[3], color2[4], 0)
      end
    else
      Wait(800)
    end
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("redm_ford:spawn_c", function(pos, md, engine)
  spawnCar(pos, md, engine)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("redm_ford:horn_active", function()
  Wait(2000)
  if car then 
    car.horn = false
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("redm_ford:horn_c", function(c)
  local cc = GetEntityCoords(PlayerPedId())
  local dist = #(c-cc)
  if dist < 15.0 then
    Horn(c)
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("redm_ford:upgrade_update", function(id)
  if car then
    car.speed = Config.maxspeeds[id]
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("redm_ford:upgrade_menu", function(id)
  MenuData.CloseAll()
  menuOpen = true
  local elements = {}

  for i,v in pairs(Config.Upgrades) do 
      local nr = #elements+1
      elements[nr] = {label = v.label.." $"..v.price, value = v.value, desc = v.desc, value2 = v.value2, price = v.price}
  end 

  MenuData.Open('default', GetCurrentResourceName(), 'car_dealer_menu_upgrades',{
       title    = Config.CarSpawns[id].name,
       subtext    = Config.Texts.Upgrades,
       align    = "top-right",
       elements = elements,
   },
   function(data, menu)
    if data.current.value then 
      if data.current.value == "engine" then 
        TriggerServerEvent("redm_ford:buy_upgrade", data.current.value2)
      end
      menuOpen = false
      menu.close()
    end
   end,
   function(data, menu)
      menuOpen = false
      menu.close()
   end)
end)

--------------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("redm_ford:open_menu_c", function(id)
  MenuData.CloseAll()
  menuOpen = true
  local elements = {}
  elements[1] = {label = Config.Texts.Spawn, value = "spawn", desc = Config.Texts.SpawnD}
  elements[2] = {label = Config.Texts.Upgrade, value = "upgrade", desc = Config.Texts.UpgradeD}
  for i,v in pairs(Config.Carmodels) do 
      elements[#elements+1] = {label = v.name.." $"..v.price, value = i, desc = Config.Texts.BuyThis}
  end 

  MenuData.Open('default', GetCurrentResourceName(), 'car_dealer_menu',{
       title    = Config.CarSpawns[id].name,
       subtext    = Config.Texts.Cars,
       align    = "top-right",
       elements = elements,
   },
   function(data, menu)
    if data.current.value then 
      if data.current.value == "spawn" then 
        TriggerServerEvent("redm_ford:spawn_car", id)
        menuOpen = false
        menu.close()
      elseif data.current.value == "upgrade" then 
        TriggerEvent("redm_ford:upgrade_menu", id)
      else
        TriggerServerEvent("redm_ford:buy_car", data.current.value)
        menuOpen = false
        menu.close()
      end

    end
   end,
   function(data, menu)
      menuOpen = false
      menu.close()
   end)
end)
--------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end
    if car then 
      if car.vehicle then 
        DeleteEntity(car.vehicle)
        DeleteEntity(car.headlight_l)
        DeleteEntity(car.headlight_r)
        DeleteEntity(car.headlight_b)
        DeleteEntity(car.object)
      end
    end
    if menuOpen then 
      MenuData.CloseAll()
    end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
local VORPcore = nil
RegisterNetEvent('Notification:redm_car')
AddEventHandler('Notification:redm_car', function(t1, t2, dict, txtr, timer)
    if not HasStreamedTextureDictLoaded(dict) then
        RequestStreamedTextureDict(dict, true) 
        while not HasStreamedTextureDictLoaded(dict) do
            Citizen.Wait(5)
        end
    end
    if Config.VorpNotif then 
      if not VORPcore then 
        TriggerEvent("getCore", function(core)
            VORPcore = core
        end)
      end
      VORPcore.NotifyAvanced(t1, t2, dict, txtr, "COLOR_PURE_WHITE", timer)
    else
      exports[GetCurrentResourceName()].LeftNot(0, tostring(t1), tostring(t2), tostring(dict), tostring(txtr), tonumber(timer))
    end
    SetStreamedTextureDictAsNoLongerNeeded(dict)
end)
