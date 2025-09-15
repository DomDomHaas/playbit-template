import ("scripts/ball")

local function createWall(x, y, w, h)
  local wall = playdate.graphics.sprite.new(playdate.graphics.image.new("textures/wall"))
  wall:moveTo(x, y)
  wall:setCollideRect(0, 0, w, h)
  wall.collisionResponse = "freeze"
  wall:add()
  table.insert(walls, wall)
end

function bounceTestingLoad()
    -- Create ball instance
    local bImage = playdate.graphics.image.new("textures/ball")
    local hasImg = bImage == nil and 'no img' or 'has img'
    print("Ball img " .. hasImg)

    ball = Ball.new(bImage)

    local hasBall = ball == nil and 'no ball' or 'has ball'
    print("Ball.new " .. hasBall)

    ball:test()

    ball:moveTo(200, 100)  -- Start position
    ball:setCollideRect(0, 0, ball.width, ball.height)
    ball:add()

    -- Create walls
    walls = {}

    createWall(0, 0, 10, love.graphics.getHeight())  -- Left wall
    createWall(love.graphics.getWidth() - 10, 0, 10, love.graphics.getHeight()) -- Right wall
    createWall(0, 0, love.graphics.getWidth(), 10) -- Top wall
    createWall(0, love.graphics.getHeight() - 10, love.graphics.getWidth(), 10) -- Floor
end


function bounceTestingUpdate(dt)
  ball:update(dt)  -- Update ball physics
end


function bounceTestingDraw()
  playdate.graphics.sprite.drawAll()  -- Draw all sprites

  -- Debug: Draw walls
  love.graphics.setColor(1, 0, 0)  -- Red color for walls

  for _, wall in ipairs(walls) do
      local w, h = wall:getSize()
      love.graphics.rectangle("fill", wall.x, wall.y, w, h)
  end

  love.graphics.setColor(1, 1, 1)  -- Reset color
end
