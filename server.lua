data = {}
local VorpCore
local VorpInv
local QBRItems
local QRCore
local qc
--------------------------------------------------------------------------------------------------------------------------------------------
if Config.framework == "redemrp" then
  TriggerEvent("redemrp_inventory:getData",function(call)
      data = call
  end)
elseif Config.framework == "redemrp-reboot" then
  TriggerEvent("redemrp_inventory:getData",function(call)
      data = call
  end)
  RItems = exports.redemrp_inventory:GetItemsList()
  RedEM = exports["redem_roleplay"]:RedEM()
elseif Config.framework == "vorp" then 
  TriggerEvent("getCore",function(core)
      VorpCore = core
  end)
  
  VorpInv = exports.vorp_inventory:vorp_inventoryApi()
elseif Config.framework == "qbr" then 
  qc = "qbr-core"
  QBRItems = exports[qc]:GetItems()
elseif Config.framework == "qbr2" then 
  qc = "qr-core"
  QRCore = exports[qc]:GetCoreObject()
end

function GetPlayerData(src)
  local a = nil 
  if Config.framework == "redemrp" then
      TriggerEvent('redemrp:getPlayerFromId', src, function(user)
          if user then 
              local identifier = tostring(user.getIdentifier())
              local charid = tonumber(user.getSessionVar("charid"))
              local money = user.getMoney()
              local job = user.getJob()
              a = {identifier = identifier, charid = charid, name = pname, money = money, job = job}
          else
              a = false 
          end
      end)
      Wait(200)
  elseif Config.framework == "redemrp-reboot" then
      local Player = RedEM.GetPlayer(src)
      if Player then 
          local identifier = Player.identifier
          local charid = Player.charid
          local money = Player.money
          local job = Player.job   
          a = {identifier = identifier, charid = charid, name = pname, money = money, job = job}
      else
          a = false 
      end
  elseif Config.framework == "vorp" then 
      local Character = VorpCore.getUser(src).getUsedCharacter
      local job =  Character.job
      local identifier = Character.identifier
      local charid = Character.charIdentifier
      local money =  Character.money
      a = {identifier = identifier, charid = charid, name = pname, money = money, job = job}
  elseif Config.framework == "qbr" or Config.framework == "qbr2" then 
      local User 
      if  Config.Framework == "qbr" then
          User = exports[qc]:GetPlayer(_source)
      else
          User = QRCore.Functions.GetPlayer(_source)
      end
      local job =  User.PlayerData.job
      local identifier = User.PlayerData.license
      local charid = User.PlayerData.cid
      local money = User.PlayerData.money.cash
      a = {identifier = identifier, charid = charid, name = pname, money = money, job = job.name}
  end
  return a
end
--------------------------------------------------------------------------------------------------------------------------------------------
function ReadSQL(dat)
  local a = nil
  if Config.framework == "redemrp" then 
      MySQL.Async.fetchAll("SELECT * FROM redm_ford WHERE identifier=@id2 AND charid=@id3", {id2=dat.identifier, id3=dat.charid}, function(result)
          if result[1] then
              a = result
          else
              a = false
          end
      end)
  elseif Config.framework == "redemrp-reboot" then
      MySQL.query("SELECT * FROM redm_ford WHERE identifier=? AND charid=?", {dat.identifier, dat.charid}, function(result)
          if result[1] then
              a = result
          else
              a = false
          end
      end)
  elseif Config.framework == "vorp" then 
      exports.ghmattimysql:execute("SELECT * FROM redm_ford WHERE identifier=@id2 AND charid=@id3", {id2=dat.identifier, id3=dat.charid}, function(result)
          if result[1] then
              a = result
          else
              a = false
          end
      end)
  elseif Config.framework == "qbr" or Config.framework == "qbr2" then 
      MySQL.query("SELECT * FROM redm_ford WHERE identifier=@id2 AND charid=@id3", {id2=dat.identifier, id3=dat.charid}, function(result)
          if result[1] then
              a = result
          else
              a = false
          end
      end)
  end
  while a == nil do 
      Wait(100)
  end
  return a
end
--------------------------------------------------------------------------------------------------------------------------------------------
function UpdateSQL(dat, save)
  if Config.framework == "redemrp" then 
      MySQL.Async.execute("UPDATE redm_ford SET engine=@engine WHERE identifier=@id2 AND charid=@id3", {id2 = dat.identifier, id3 = dat.charid, engine = save}, function(done)
      end)
  elseif Config.framework == "redemrp-reboot" then
      MySQL.update("UPDATE redm_ford SET engine=? WHERE identifier=? AND charid=?", {save, dat.identifier, dat.charid}, function(done)
      end)
  elseif Config.framework == "vorp" then 
      exports.ghmattimysql:execute("UPDATE redm_ford SET engine=@engine WHERE identifier=@id2 AND charid=@id3", {id2 = dat.identifier, id3 = dat.charid, engine = save}, function(done)
      end)
  elseif Config.framework == "qbr" or Config.framework == "qbr2" then 
      MySQL.Async.prepare("UPDATE redm_ford SET engine=@engine WHERE identifier=@id2 AND charid=@id3", {id2 = dat.identifier, id3 = dat.charid, engine = save})
  end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function InsertSQL(dat, save)
  if Config.framework == "redemrp" then 
      MySQL.Async.execute("INSERT INTO redm_ford (identifier, charid, model) VALUES (@identifier, @charid, @model)",  {identifier = dat.identifier, charid = dat.charid, model = save}, function(result)
      end)
  elseif Config.framework == "redemrp-reboot" then
      MySQL.insert("INSERT INTO redm_ford (identifier, charid, model) VALUES (?,?,?)",  {dat.identifier, dat.charid, save}, function(id)
      end)
  elseif Config.framework == "vorp" then 
      exports.ghmattimysql:execute("INSERT INTO redm_ford (identifier, charid, model) VALUES (@identifier, @charid, @model)",  {identifier = dat.identifier, charid = dat.charid, model = save}, function(done)
      end)
  elseif Config.framework == "qbr" or Config.framework == "qbr2" then 
      MySQL.Async.insert("INSERT INTO redm_ford (identifier, charid, model) VALUES (@identifier, @charid, @model)",  {identifier = dat.identifier, charid = dat.charid, model = save})
  end
end
--------------------------------------------------------------------------------------------------------------------------------------------
function RemovePMoney(src, value)
  if Config.framework == "redemrp" then 
      TriggerEvent('redemrp:getPlayerFromId', src, function(user)
          user.removeMoney(value)
      end)
  elseif Config.framework == "redemrp-reboot" then
      local Player = RedEM.GetPlayer(src)
      Player.RemoveMoney(value)
  elseif Config.framework == "vorp" then 
      local Character = VorpCore.getUser(src).getUsedCharacter
      Character.removeCurrency(0 , value)
  elseif Config.framework == "qbr" or Config.framework == "qbr2" then 
      local User 
      if  Config.Framework == "qbr" then
          User = exports[qc]:GetPlayer(src)
      else
          User = QRCore.Functions.GetPlayer(src)
      end
      User.Functions.RemoveMoney("cash", value, "RicX : Remove Money")
  end
end
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("redm_ford:open_menu", function(id)
  local _source = source
  local player = GetPlayerData(_source)
  if player then 
    local go = true
    if Config.CarSpawns[id].job then 
      go = false
      for i,v in pairs(Config.CarSpawns[id].job) do 
        if v == player.job then 
          go = true
        end
      end
      if go then 
        TriggerClientEvent("redm_ford:open_menu_c", _source, id)
      end
    end
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("redm_ford:buy_car", function(id)
  local _source = source
  local player = GetPlayerData(_source) 
  local dat = ReadSQL({identifier = player.identifier, charid = player.charid})
  Wait(400)
  if not dat then 
    if Config.Carmodels[id] then 
      local price = Config.Carmodels[id].price
      if player.money >= price then 
        InsertSQL({identifier=player.identifier, charid = player.charid}, id)
        RemovePMoney(_source, price)
      end
    end
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("redm_ford:buy_upgrade", function(id)
  local _source = source
  local player = GetPlayerData(_source) 
  local dat = ReadSQL({identifier = player.identifier, charid = player.charid})
  Wait(400)
  if dat then 
    if id > dat[1].engine then 
      if Config.Upgrades[id] then 
        local price = Config.Upgrades[id].price
        if player.money >= price then 
          TriggerClientEvent("redm_ford:upgrade_update", _source, id)
          UpdateSQL({identifier=player.identifier, charid = player.charid}, id)
          RemovePMoney(_source, price)
        end
      end
    end
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("redm_ford:spawn_car", function(id)
  local _source = source
  local player = GetPlayerData(_source) 
  local dat = ReadSQL({identifier = player.identifier, charid = player.charid})
  Wait(400)
  if dat then 
    local spawn = nil 
    if id then 
      spawn = Config.CarSpawns[id].spawn
    end
    TriggerClientEvent("redm_ford:spawn_c", _source, spawn, Config.Carmodels[dat[1].model], dat[1].engine)
  end
end)
--------------------------------------------------------------------------------------------------------------------------------------------
