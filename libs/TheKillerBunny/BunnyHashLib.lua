local mod = {}

function mod.djb2(str)
   local hash = 5381

   for char in string.gmatch(str, ".") do
      hash = (bit32.lshift(hash, 5) + hash) + string.byte(char)
   end

   return hash
end

return mod

