local groupLookup = {}
local idLookup = {}

for model,group in pairs(Config.Models) do
  local hash = GetHashKey(model)

  groupLookup[hash] = group
  groupLookup[hash%0x100000000] = group
end

function constructLootTable(group)
  local loot = {}

  math.randomseed(os.time())

  for _,tableName in ipairs(Config.Groups[group].lootTables) do
    local lootTable = Config.LootTables[tableName]
    for _,item in ipairs(lootTable) do
      if item.chance >= math.random(0,100) and #loot < 50 then
        table.insert(loot,{
          name = item.name,
          count = math.random(item.min,item.max)
        })
      end
    end
  end

  return loot
end

function validateInventory(pos,group,cb)
  exports["mf-inventory"]:onReady(function()
    local id = idLookup[pos]

    if not id then
      local loot = constructLootTable(group)
      local items = exports["mf-inventory"]:buildInventoryItems(loot)
      id = exports['mf-inventory']:createTemporaryInventory("inventory",string.format("trash:%s",group),"inventory",50.0,50,items)
      idLookup[pos] = id
    end

    cb(id)
  end)
end

RegisterNetEvent("trash:searchTrash")
AddEventHandler("trash:searchTrash",function(pos,hash)
  local player = source
  local group = groupLookup[hash]

  if not group then
    return
  end

  validateInventory(tostring(pos),group,function(id)
    TriggerClientEvent("trash:searchedTrash",player,id)
  end)
end)