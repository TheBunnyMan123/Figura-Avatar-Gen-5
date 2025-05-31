local part = models:newPart("pongPortrait", "PORTRAIT")
local white = textures:newTexture("PongPortrait$WhitePixel", 1, 1):setPixel(0, 0, vec(1, 1, 1))

local background = part:newSprite("background")
   :setTexture(white, 1, 1)
   :setColor(0, 0, 0)
   :setSize(16, 16)
   :setPos(4, 8)
   :setLight(15)

local ball = part:newSprite("ball")
   :setTexture(white, 1, 1)
   :setSize(1, 1)
   :setPos(4, 8, -1)
   :setLight(15)

local leftPaddle = part:newSprite("leftPaddle")
   :setTexture(white, 1, 1)
   :setSize(1, 3)
   :setPos(4, 8, -1)
   :setLight(15)

local rightPaddle = part:newSprite("rightPaddle")
   :setTexture(white, 1, 1)
   :setSize(1, 3)
   :setPos(-3, 8, -1)
   :setLight(15)

local topLeft = vec(4, 8)

local ballPos = vec(4, 4)
local ballDir = vec(0.2, 0.2)

local leftPaddlePos = vec(0, 0)
local rightPaddlePos = vec(7, 0)
function events.WORLD_TICK()
   local newBallPos = ballPos + ballDir

   if newBallPos.x <= 1 then
      local relativeToPaddlePos = ballPos.y - leftPaddlePos.y

      if relativeToPaddlePos >= 0 and relativeToPaddlePos <= 3 then
         ballDir.x = -ballDir.x
         newBallPos = ballPos + ballDir
      else
         newBallPos = vec(4, 4)
      end
   elseif newBallPos.x >= 6 then
      local relativeToPaddlePos = ballPos.y - rightPaddlePos.y

      if relativeToPaddlePos >= 0 and relativeToPaddlePos <= 3 then
         ballDir.x = -ballDir.x
         newBallPos = ballPos + ballDir
      else
         newBallPos = vec(4, 4)
      end
   end

   if newBallPos.y <= 0 then
      ballDir.y = 0.2
   elseif newBallPos.y >= 7 then
      ballDir.y = -0.2
   end
   
   local relativeLeftPaddlePos = ballPos.y - leftPaddlePos.y
   local relativeRightPaddlePos = ballPos.y - rightPaddlePos.y
   local dirX = ballDir.x
   local ballX = ballPos.x

   if relativeLeftPaddlePos < 1.5 and dirX < 0 and ballX < 3.5 then
      leftPaddlePos.y = math.clamp(leftPaddlePos.y - 0.3, 0, 6)
   elseif relativeLeftPaddlePos > 1.5 and dirX < 0 and ballX < 4 then
      leftPaddlePos.y = math.clamp(leftPaddlePos.y + 0.3, 0, 6)
   end

   if relativeRightPaddlePos < 1.5 and dirX > 0 and ballX > 3.5 then
      rightPaddlePos.y = math.clamp(rightPaddlePos.y - 0.3, 0, 6)
   elseif relativeRightPaddlePos > 1.5 and dirX > 0 and ballX > 3 then
      rightPaddlePos.y = math.clamp(rightPaddlePos.y + 0.3, 0, 6)
   end

   local trueLeftPaddlePos = topLeft - leftPaddlePos
   local trueRightPaddlePos = topLeft - rightPaddlePos

   ballPos = newBallPos
   local trueBallPos = topLeft - ballPos

   ball:setPos(trueBallPos.x, trueBallPos.y, -1)
   leftPaddle:setPos(trueLeftPaddlePos.x, trueLeftPaddlePos.y, -1)
   rightPaddle:setPos(trueRightPaddlePos.x, trueRightPaddlePos.y, -1)
end

