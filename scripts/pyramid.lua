function generate_pyramid(height)
   local list = {}

   for y = 1, height + 1, 1 do
      for x = 0, height - y, 1 do
         for z = 0, height - y, 1 do
            list[#list + 1] = vec(x + y / 2, y, z + y / 2)
         end
      end
   end

   return list
end

function pyramid_size(height)
   local total = 0
   for i = 1, height do
      total = total + i^2
   end
   return total
end

print(pyramid_size(100), #generate_pyramid(100))

