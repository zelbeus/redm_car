Config = {}
Config.framework = "redemrp-reboot" --"redemrp" or "redemrp-reboot" or "qbr" or "qbr2" or "vorp" | CHANGE THE SQL PATH IN FXMANIFEST TOO IF USING DIFFERENT THAN DEFAULT ("redemrp-reboot")
Config.VorpNotif = false 
Config.menuapi = "redemrp_menu_base" --"redemrp_menu_base" or "menuapi"

Config.Textures = {
  cross = {"scoretimer_textures", "scoretimer_generic_cross"},
  locked = {"menu_textures","stamp_locked_rank"},
  tick = {"scoretimer_textures","scoretimer_generic_tick"},
  money = {"inventory_items", "money_moneystack"},
  alert = {"menu_textures", "menu_icon_alert"},
}


Config.Engine = 0x8AAA0AD4 -- LEFT ALT
Config.Headlight = 0x80F28E95 -- L
Config.Shop = 0x8AAA0AD4 -- LEFT ALT
Config.Horn = 0x0522B243 -- F

Config.WeirdSmokeAndSound = true

Config.SpawnCommand = true 
Config.Command = "spawn_car"
Config.DeleteCommand = "delete_car"
Config.ResetCommand = "reset_car"

Config.NativeHUD = true

Config.CarSpawns = {
    {pos = {2454.492, -1319.561, 45.433}, spawn = {x = 2447.080, y = -1321.614, z = 45.405, h = 95.208}, job = {"driver", "mechanic"}, name = "Car Mechanic"}
}

Config.Carmodels = {
  [GetHashKey("fjordmodeltea")] = {model = GetHashKey("fjordmodeltea"), price = 1000, attach = {0.0, -0.22, -0.83, 0.0, 0.0, 90.0}, name = "Fjord Model Tea"},
}

Config.Upgrades = {
  [1] = {label = "Engine I.", value = "engine", value2 = 1, desc = "Engine Level 1", price = 100},
  [2] = {label = "Engine II.", value = "engine", value2 = 2, desc = "Engine Level 2", price = 200},
  [3] = {label = "Engine III.", value = "engine", value2 = 3, desc = "Engine Level 3", price = 300},
  [4] = {label = "Engine IV.", value = "engine", value2 = 4, desc = "Engine Level 4", price = 400},
  [5] = {label = "Engine V.", value = "engine", value2 = 5, desc = "Engine Level 5", price = 500},
  [6] = {label = "Engine VI.", value = "engine", value2 = 6, desc = "Engine Level 6", price = 600},
}

Config.Texts = {
  Cars = "Cars",
  Spawn = "Spawn Car",
  SpawnD = "Spawn the purchased car",
  BuyThis = "Buy this model",
  Upgrade = "Upgrade",
  UpgradeD = "Buy Upgrades for your car",
  Upgrades = "Upgrades",
  BuyThis2 = "Buy this upgrade",
  CarDealer = "Car Dealer",
  NoMoney = "You dont have enough money!",
  NoJob = "You dont have the required job!",
  BetterEngine = "You have a better engine in the car!",
  Car = "Car",
  AlreadySpawned = "You have the car already spawned!",
  FarAway = "Car is too far!",
  NotSpawned = "Car is not spawned",
  AlreadyHave = "You have already a car!",
  NoCar = "You dont have any car!",
  BuyPrevious = "You have to upgrade the previous Level!",
  UpgradePurchased = "Upgrade Purchased!",
  CarPurchased = "Car purchased!",
}

Config.maxspeeds = {
  [1] = {v1 = 6.8, v2 = 5.4, r1 = -3.5, r2 = -2.0},
  [2] = {v1 = 9.8, v2 = 8.5, r1 = -4.5, r2 = -3.0},
  [3] = {v1 = 11.8, v2 = 8.9, r1 = -4.5, r2 = -3.0},
  [4] = {v1 = 14.8, v2 = 11.5, r1 = -6.5, r2 = -3.8},
  [5] = {v1 = 19.9, v2 = 17.5, r1 = -6.5, r2 = -3.8},
  [6] = {v1 = 22.9, v2 = 19.5, r1 = -6.5, r2 = -3.8},
}