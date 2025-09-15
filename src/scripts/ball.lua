Ball = {}
Ball.__index = Ball  -- Set up metatable for Ball instances

-- setmetatable(Ball, { __index = playdate.graphics.sprite })

function Ball.new(image)
    -- Create an instance of playdate.graphics.sprite
    local b = playdate.graphics.sprite.new(image)
    
    -- Assign Ball as its metatable
    setmetatable(b, Ball)
  
    if b and b.moveTo then
      print("Ball instance is valid")
    else
      print("Ball instance is INVALID")
    end

    b.velocityX = 200  -- Initial horizontal speed
    b.velocityY = 0    -- Initial vertical speed
    b.gravity = 500    -- Gravity strength (pixels per second²)
    b.bounceFactor = 0.8  -- Energy loss on bounce
    b.collisionResponse = "bounce"  -- Default response

    return b
end

function Ball:test()
  print("I am a Ball!")
end

function Ball:update(dt)
    -- Apply gravity
    self.velocityY = self.velocityY + self.gravity * dt

    -- Compute next position
    local nextX = self.x + self.velocityX * dt
    local nextY = self.y + self.velocityY * dt

    -- Check for collisions
    local actualX, actualY, collisions, count = self:moveWithCollisions(nextX, nextY)

    for _, col in ipairs(collisions) do
        local response = self.collisionResponse

        if type(response) == "function" then
            response = response(col.other) or "freeze"
        end

        if response == "bounce" then
            -- Reverse direction based on collision normal
            if col.normal.x ~= 0 then
                self.velocityX = -self.velocityX * self.bounceFactor
            end
            if col.normal.y ~= 0 then
                self.velocityY = -self.velocityY * self.bounceFactor
            end
        end
    end
end
