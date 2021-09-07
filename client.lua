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

Citizen.CreateThread(function()
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

RegisterNetEvent("trash:searchedTrash")
AddEventHandler("trash:searchedTrash",function(id)
  exports["mf-inventory"]:openOtherInventory(id)
  busy = false
end)