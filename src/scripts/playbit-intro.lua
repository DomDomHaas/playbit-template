-- This is the Playbit intro sequence/splash. Use it in your project if you'd like to show that you've used Playbit!
import("scripts/bounceTest")

module = {}
playbitIntro = module

local image = nil
local startupSfx = nil
local hasPlayedSfx = false

local lVersion = _VERSION
if jit then
  lVersion = jit.version -- Example: LuaJIT 2.1.0-beta3
end

print("Starting with Love2D version " .. lVersion)

screenW = love.graphics.getWidth()
screenH = love.graphics.getHeight()

local startPos = {
  [1] = {10, 10},
  [2] = {screenW - 10, 10},
  -- [3] = {screenW - 10, screenH - 10},
  -- [4] = {10, screenH - 10},
}

local dirs = {
  [1] = {1, 1},
  [2] = {-1, 1},
  [3] = {-1, -1},
  [4] = {1, -1},
}

local sprites = {}

local collisionResponses = {
  [1] = playdate.graphics.sprite.kCollisionTypeSlide,
  [2] = playdate.graphics.sprite.kCollisionTypeFreeze,
  [3] = playdate.graphics.sprite.kCollisionTypeOverlap,
  [4] = playdate.graphics.sprite.kCollisionTypeBounce,
}

function module.isComplete()
  -- TODO: when (future) animation is implemented, return true when anim is done instead
  return hasPlayedSfx and not startupSfx:isPlaying()
end

local function createSprite(collisionResponse)
  local img = playdate.graphics.image.new("textures/playbit-logo-small")
  local spr = playdate.graphics.sprite.new(img)
  -- spr:setImage(img)
  spr:add()

  local w, h = spr:getSize()
  spr:setCollideRect(0, 0, w, h)
  spr:setCollisionResponse(collisionResponse)

  return spr
end


local function initSprites()
  for i = 1, #startPos, 1 do
    -- local spr = createSprite(collisionResponses[i])
    local spr = createSprite(playdate.graphics.sprite.kCollisionTypeBounce)
    spr:moveTo(startPos[i][1], startPos[i][2])
    table.insert(sprites, spr)
  end

  local spriteToCenterTesting = createSprite(playdate.graphics.sprite.kCollisionTypeFreeze)

   -- if the default of setCenter(0.5, 0.5)
   -- the image should be visible in the top left but cut off
   -- as some of it will be off screen
  spriteToCenterTesting:moveTo(0, 0)

  local spriteForScaling = createSprite(playdate.graphics.sprite.kCollisionTypeFreeze)

   spriteForScaling:moveTo(200, 120)
   spriteForScaling:setScale(2)
  
end

local function moveSprite(sprite, dirX, dirY)
  local x, y = sprite:getPosition()
  -- sprite:moveWithCollisions(x + dirX, y + dirY)

  local actualX, actualY, collisions, count = sprite:moveWithCollisions(x + dirX, y + dirY)

  for _, col in ipairs(collisions) do
      local response = sprite.collisionResponse

      if type(response) == "function" then
          response = response(col.other) or "freeze"
      end

      if response == "bounce" then
          -- Reverse movement direction based on collision normal
          if col.normal.x ~= 0 then
            dirX = dirX * -1
            print("bounce on X")
          end
          if col.normal.y ~= 0 then
            dirY = dirY * -1
            print("bounce on X")
          end
      end
  end

  return dirX, dirY
end


local function moveSpritesInScene()
  for key, spr in pairs(sprites) do
    local dirX = dirs[key][1]
    local dirY = dirs[key][2]

    dirX, dirY = moveSprite(spr, dirX, dirY)

    local nextX, nextY = spr:getPosition()

    if (nextX > screenW or nextX < 0) then
      dirX = dirX * -1
    end

    if (nextY > screenH or nextY < 0) then
      dirY = dirY * -1
    end

    dirs[key][1], dirs[key][2] = dirX, dirY

  end
  
end



function module.init()

  -- initSprites()

  bounceTestingLoad()

  startupSfx = playdate.sound.sampleplayer.new("sounds/playbit-startup")
  hasPlayedSfx = false
end

-- print("screenW " .. screenW .. " screenH " .. screenH)


function module.update()
  if not hasPlayedSfx then
    startupSfx:play()
    hasPlayedSfx = true
  end

  -- moveSpritesInScene()

  bounceTestingUpdate()

  bounceTestingDraw()

  -- playdate.graphics.sprite.draw()
  -- image:draw(0, 0)
end

function module.destroy()
  image = nil
  startupSfx = nil
end