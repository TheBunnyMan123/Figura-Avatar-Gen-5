local mod = {}

local function mkDesc(list, index)
   local desc = {}

   for i, v in ipairs(list) do
      if i == index then
         desc[#desc + 1] = {text = v, color = "white"}
      else
         desc[#desc + 1] = {text = v, color = "gray"}
      end

      if i ~= #list then
         desc[#desc + 1] = {text="\n"}
      end
   end

   return toJson(desc)
end

function mod.newMulti(name, list, func)
   local index = 1

   local action = action_wheel:newAction()
      :setOnScroll(function(dir, self)
         index = index % #list
         if dir < 0 then
            index = index + 1
         else
            index = index - 1
            index = index % #list
            if index == 0 then
               index = #list
            end
         end

         func(list[index])
         self:setTitle(mkDesc(list, index))
      end)
      :setTitle(mkDesc(list, index))

   return action
end

return mod

