if true then return end
local pages = {
   {"String Bass", {
      "Logs",
      "Jack O' Lantern"
   }},
   {"Snare Drum", {
      "Sand",
      "Gravel",
      "Concrete Powder"
   }},
   {" Hi-Hat", {
      "Beacon",
      "Sea Lantern"
   }},
   {"Bass Drum", {
      "All Stones",
      "All Ores",
      "All Coral",
      "Netherrack",
      "Quartz",
      "Bricks",
      "Respawn Anchor"
   }},
   {"Glockenspiel", {
      "Gold Block"
   }},
   {" Flute", {
      "Clay Block"
   }},
   {" Chimes", {
      "Packed Ice"
   }},
   {" Guitar", {
      "All Wool"
   }},
   {"Vibraphone", {
      "Iron Block"
   }},
   {" Cowbell", {
      "Soul Sand"
   }},
   {" Digeridoo", {
      "Pumpkin",
      "Carved Pumpkin"
   }},
   {"Square Wave", {
      "Emerald"
   }},
   {" Banjo", {
      "Hay Bale"
   }},
   {"Xylophone", {
      "Bone Block"
   }},
   {" Violin", {
      "Note Block"
   }},
   {" Pling", {
      "Glowstone"
   }},
   {" Villager", {
      "Lectern"
   }},
   {"Slime Break", {
      "Slime Block"
   }},
   {" Anvil", {
      "Anvil"
   }},
   {"Extra", {
      "Custom Sounds - Player Head NBT",
      "Mob Sound - Corrosponding Mob Head"
   }}
}

function generate_title(title)
   return {
      (" "):rep((74 - client.getTextWidth(title) / 2) / 6) .. title:match("^ *"),
      {
         text = title:gsub("^ *", "") .. "\n",
         color = "dark_gray",
         underlined = true
      }
   }
end

function generate_list_section(block)
   return {
      {
         text = "\n* ",
         color = "black",
         bold = true,
         underlined = false
      },
      {
         text = block,
         color = "blue",
         bold = true,
         underlined = false
      }
   }
end

function generate_page(title, list)
   local json = generate_title(title)

   for _, block in pairs(list) do
      local generated = generate_list_section(block);
      json[#json + 1] = generated[1];
      json[#json + 1] = generated[2];
   end

   return toJson(json)
end

function generate_nbt()
   local jsonPages = {}

   for _, page in pairs(pages) do
      jsonPages[#jsonPages + 1] = generate_page(page[1], page[2])
   end

   return toJson {
      title = "AoF Jukebox Instruments",
      author = "TheKillerBunny",
      pages = jsonPages
   }
end

host:clipboard("give @p written_book" .. generate_nbt())

