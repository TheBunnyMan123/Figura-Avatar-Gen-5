---@class BunnyUtils
local lib = {}

---@alias VillagerTradeItem {id: Minecraft.itemID, Count: integer, tag: table}
---@alias VillagerTrades {buy: VillagerTradeItem, buyB?: VillagerTradeItem, sell: VillagerTradeItem}[]

---@param trades VillagerTrades
---@param name TextJsonComponent
function lib.getVillager(trades, profession, name)
  local final = "minecraft:villager_spawn_egg{display:{Name:'" .. toJson(name):gsub("'", "\\'") .. "'},EntityTag:{CustomName:'" .. toJson(name):gsub("'", "\\'") .. "',VillagerData:{level:99,profession:\"" .. profession .. "\"},Offers:{Recipes:"
  final = final .. toJson(trades)
  final = final .. "}}}"

  host:setSlot("hotbar.0", final)
end

function lib.getHeadCommand(uuid, texture, name)
  local encodedTexture = base64.encode(texture)
  local new = client.compareVersions(client.getVersion(), '1.20.4') == 1
  local gradient = BunnyUtils.gradient(vec(150, 255, 100) / 255, vec(50, 255, 150) / 255, #name)
  local finalName = {}

  for i = 1, #name do
    table.insert(finalName, {
      text = name:sub(i, i),
      color = "#" .. vectors.rgbToHex(gradient[i]),
      italic = false
    })
  end

  finalName = toJson(finalName)

  if new then
    return 'player_head[custom_name=\'' .. finalName .. '\'profile={id:[I;' .. table.concat({client.uuidToIntArray(uuid)}, ",") .. '],properties:[{name:"textures",value:"' .. encodedTexture .. '"}]}]'
  else
    return 'player_head{display:{Name:\'' .. finalName .. '\'},SkullOwner:{Id:[I;' .. table.concat({client.uuidToIntArray(uuid)}, ",") .. '],Properties:{textures:[{Value:"' .. encodedTexture .. '"}]}}}'
  end
end
lib.getHeadString = lib.getHeadCommand

function lib.getBunnyHeadRaw(texture, name)
  if not texture:match("^jukebox;") then
    texture = base64.encode(texture)
  end
  return lib.getHeadCommand(avatar:getUUID(), texture, name)
end
function lib.getBunnyHead(texture, name)
  host:setSlot("hotbar.0", lib.getBunnyHeadRaw(texture, name))
end

lib.getHead = function(uuid, texture, name)
  name = name or texture
  host:setSlot("hotbar.0", lib.getHeadCommand(uuid, texture, name))
end

if host:isHost() then
  local backup = (file:exists("items.json") and parseJson(file:readString("items.json"))) or {}

  lib.backupItem = function(item, backupName)
    if backup[backupName] then
      warn("Item with name already exists")
      return
    end

    backup[backupName] = item.id .. toJson(item.tag)
    file:writeString("items.json", toJson(backup), "utf8")
  end
  lib.getBackedUpItem = function(name)
    if not backup[name] then return end
    host:setSlot(0, backup[name])
  end
end

local villagers = {
  {
    trades = {
      {
        buy = {
          id = "minecraft:stick", 
          Count = 1
        }, 
        sell = {
          id = "minecraft:stick", 
          Count = 1, 
          tag = {
            display = {
              Name = toJson({
                text = "Whacking Stick",
                italic = false
              })
            },
            Enchantments = {
              {
                id = "minecraft:knockback", 
                lvl = 255
              }
            }
          }
        }
      },
      {
        buy = {
          id = "minecraft:diamond_sword",
          Count = 1
        },
        sell = {
          id = "minecraft:diamond_sword",
          Count = 1,
          tag = {
            display = {
              Name = toJson({
                text = "The Killer",
                italic = false
              })
            },
            Enchantments = {
              {
                id = "minecraft:sharpness",
                lvl = 255
              },
              {
                id = "minecraft:fire_aspect",
                lvl = 255
              }
            }
          }
        }
      }
    }, 
    profession = "minecraft:weaponsmith", 
    name = {
      text = "Powerful Items Merchant",
      color = "dark_green",
      italic = false
    }
  }
}

function lib.getVillagers()
  for k, v in pairs(villagers) do
    host:setSlot("inventory." .. (k - 1), lib.getVillager(v.trades, v.profession, v.name))
  end
end

local p5Heads = {
  id = "584fb77d-5c02-468b-a5ba-4d62ce8eabe2",
  textures = {
    "disco",
    "voidspace",
    "lootbox",
    "tripwire;ffab0a",
    "tripwire;ffffff",
    "tripwire;ffaaee",
    "tripwire;ff0000",
    "tripwire;00ff00",
    "tripwire;0000ff",
    "lamp",
    "mirrors;splitter",
    "mirrors;mirror",
    "mirrors;lens",
    "mini_blocks;smooth_stone", --end rods redirect laser
    "mirrors;aligner",
    "mirrors;redirector",
    "gates;prism",
    "gates;AND",
    "gates;OR",
    "gates;NOR",
    "gates;XNOR",
    "gates;XOR",
    "gates;NAND",
    "gates;lens"
  }
}
-- Cat plushie: 68ad0b90-a570-4d4c-995a-bddce95bf294
function lib.get4P5Heads()
  for k, v in pairs(p5Heads.textures) do
    host:setSlot("inventory." .. (k - 1), lib.getHeadString(p5Heads.id, v, v))
  end
end

local adventHeads = {
  id = "7363e787-f626-415c-863e-e89f2787d2ef",
  textures = {
    "snowman",
    "snowfall",
    "fireworks",
    "train",
    "jukebox",
    "door_wreath",
    "christmas_hat",
    "snow_globe",
    "cauldron",
    "vines",
    "snowflakes",
    "tree",
    "lights",
    "dvd",
    "reindeer",
    "shelfElf",
    "fireflies",
    "baubles",
    "carols",
    "present",
    "debug",
    "no_mode"
  }
}
function lib.getAdventHeads()
  for k, v in pairs(adventHeads.textures) do
    host:setSlot("inventory." .. (k - 1), lib.getHeadString(adventHeads.id, v, v:gsub("[_].", function(str)
      return str:gsub("_", " "):gsub("%s", string.upper)
    end):gsub("shelfElf", "Shelf elf"):gsub("dvd", "DVD"):gsub("^.", string.upper)))
  end
end

function lib.getSign(text)
  local version = client.getVersion()
  local lessThan1_20 = client.compareVersions(version, "1.20") == -1
  local lessThan1_20_5 = client.compareVersions(version, "1.20.5") == -1
  
  local nbt = "minecraft:oak_sign"
  local json = toJson({
    text = text
  }):gsub("'", "\\'")

  if lessThan1_20 then
    nbt = nbt .. "{BlockEntityTag:{Text1:'" .. json .. "'}}"
  elseif lessThan1_20_5 then
    nbt = nbt .. "{BlockEntityTag:{front_text:{messages:['" .. json .. "','{\"text\":\"\"}','{\"text\":\"\"}','{\"text\":\"\"}']}}}"
  else
    nbt = nbt .. "[block_entity_data={id:\"minecraft:oak_sign\",front_text:{messages:['" .. json .. "','{\"text\":\"\"}','{\"text\":\"\"}','{\"text\":\"\"}']}}]"
  end

  host:setSlot("weapon.mainhand", nbt)
end

---Calculates the matrix
---@param part ModelPart
---@return Matrix4
function lib.calcMatrix(part)
  if not part then return matrices.mat4() end
  return part:getPositionMatrix() * lib.calcMatrix(part:getParent())
end

---Calculates the true position of a part (not in world)
---@param part ModelPart
---@return Vector3
function lib.truePos(part)
  return lib.calcMatrix(part):apply(part:getTruePivot())
end

function lib.gradient(color1, color2, steps)
  local colorDelta = (color2 - color1) / steps
  local generatedSteps = {}

  for i = 0, steps do
    table.insert(generatedSteps, color1 + (colorDelta * i))
  end

  return generatedSteps
end

return lib

