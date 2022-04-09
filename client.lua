-- insert your animation and wait time etc here before opening the inventory.
function playAnimation()
end

-- probably don't touch below here
local groupLookup = {}
local modelHashes = {}

for group,data in pairs(Config.Groups) do  
  AddTextEntry(string.format('trash_help:%s',group), string.format(Config.HelpStr,data.label))
end

for model,group in pairs(Config.Models) do
  local hash = GetHashKey(model)
  groupLookup[hash] = group
  modelHashes[#modelHashes+1] = hash
end 

function showHelpNotification(group)
  DisplayHelpTextThisFrame(string.format('trash_help:%s',group),false)
end

function getClosestObject()
  local ped = PlayerPedId()
  local pos = GetEntityCoords(ped)

  local closestObj,closestPos,closestHash,closestDist

  for _,hash in ipairs(modelHashes) do
    local obj = GetClosestObjectOfType(pos, Config.InteractRadius, hash, false)

    if obj and obj > 0 then
      local objPos  = GetEntityCoords(obj) 
      local objDist = #(objPos - pos)

      if not closestDist or objDist < closestDist then
        closestObj  = obj
        closestPos  = objPos
        closestHash = hash
        closestDist = objDist
      end
    end
  end

  return closestObj,closestPos,closestHash,closestDist
end

RegisterNetEvent("trash:searchedTrash")
AddEventHandler("trash:searchedTrash",function(id)
  exports["mf-inventory"]:openOtherInventory(id)
  busy = false
end)

Dumpster = {}
local models = {
  `prop_bin_01a`, 
  `prop_bin_02a`,    
  `prop_bin_03a`,   
  `prop_bin_04a`,  
  `prop_bin_05a`,    
  `prop_bin_06a`,    
  `prop_bin_07a`,      
  `prop_bin_07b`,     
  `prop_bin_07c`,      
  `prop_bin_07d`,     
  `prop_bin_08a`,  
  `prop_bin_09a`,    
  `prop_bin_010a`,
  `prop_bin_011a`,   
  `prop_bin_011b`,   
  `prop_bin_012a`,  
  `prop_bin_013a`,   
  `prop_bin_014a`,
  `prop_bin_014b`,
  `prop_bin_beach_01a`,
  `prop_bin_beach_01d`,
  `prop_bin_delpiero`,
  `prop_bin_delpiero_b`,
  `prop_cs_dumpster_01a`,
  `p_dumpster_t`,
  `prop_snow_dumpster_01`,
  `prop_dumpster_01a`,
  `prop_dumpster_02a`,
  `prop_dumpster_02b`,
  `prop_dumpster_3a`,
  `prop_dumpster_4a`,
  `prop_dumpster_4b`
}

if Config.Target then
  CreateThread(function()
    exports["fivem-target"]:AddTargetModels({
      name = "dumpster_dive",
      label = "Dumpster",
      icon = "fas fa-dumpster",
      models = models,
      interactDist = 2.5,
      onInteract = Dumpster.OnInteract,
      options = {
        {
          name = "search_dumpster",
          label = "Search Dumpster"
        }
      }  
    })
  end)
else
  CreateThread(function()
    local closest,pos,hash,dist
    local lastCheck = GetGameTimer()

    while true do
      local waitTime = 500
      local now = GetGameTimer()

      if not busy then
        if now - lastCheck >= 500 then
          closest,pos,hash,dist = getClosestObject()
          lastCheck = now
        end

        if closest then
          local group = groupLookup[hash]
          showHelpNotification(group)

          if IsControlJustPressed(0,Config.InteractControl) then
            busy = true
            FreezeEntityPosition(closest,true)
            playAnimation()
            TriggerServerEvent("trash:searchTrash",pos,hash)
          end

          waitTime = 0
        end
      end

      Wait(waitTime)
    end
  end)
end

Dumpster.OnInteract = function(targetName, optionName)
  if optionName == "search_dumpster" then
    local closest,pos,hash,dist = getClosestObject()

    if closest then
      FreezeEntityPosition(closest,true)
      TriggerServerEvent("trash:searchTrash",pos,hash)
    end
  end
end
