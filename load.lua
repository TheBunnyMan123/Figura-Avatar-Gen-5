for _, v in pairs(listFiles("scripts.init", true)) do
   require(v)
end

for _, v in pairs(listFiles("scripts.common", true)) do
   require(v)
end

if host:isHost() then
   for _, v in pairs(listFiles("scripts.host", true)) do
      require(v)
   end
end

