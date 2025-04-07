-- Death Ball Game in Lua
local player = nil
local parryRadius = 2
local ball = nil
local ballSpeed = 10
local canParry = true
local parryCooldown = 0.5

function spawnBall()
    if ball ~= nil then return end
    
    local spawnPos = {
        x = math.random(-10, 10),
        y = 0,
        z = math.random(-10, 10)
    }
    
    -- Create ball (implementation depends on your engine)
    ball = createBallObject(spawnPos)
    
    -- Set initial velocity toward player with some randomness
    local direction = {
        x = (player.x - spawnPos.x) + math.random(-3, 3),
        y = 0,
        z = (player.z - spawnPos.z) + math.random(-3, 3)
    }
    
    -- Normalize direction and apply speed
    local length = math.sqrt(direction.x^2 + direction.y^2 + direction.z^2)
    ball.velocity = {
        x = direction.x/length * ballSpeed,
        y = 0,
        z = direction.z/length * ballSpeed
    }
end

function update(deltaTime)
    if ball == nil or player == nil then return end
    
    -- Check for parry collision
    local dx = ball.x - player.x
    local dz = ball.z - player.z
    local distance = math.sqrt(dx^2 + dz^2)
    
    if distance <= parryRadius and canParry then
        parryBall()
    end
    
    -- Update ball position
    ball.x = ball.x + ball.velocity.x * deltaTime
    ball.y = ball.y + ball.velocity.y * deltaTime
    ball.z = ball.z + ball.velocity.z * deltaTime
end

function parryBall()
    canParry = false
    
    -- Reflect ball with some randomness
    ball.velocity.x = -ball.velocity.x + math.random(-2, 2)
    ball.velocity.z = -ball.velocity.z + math.random(-2, 2)
    
    -- Normalize and speed up
    local length = math.sqrt(ball.velocity.x^2 + ball.velocity.z^2)
    ball.velocity.x = ball.velocity.x/length * ballSpeed * 1.5
    ball.velocity.z = ball.velocity.z/length * ballSpeed * 1.5
    
    -- Start cooldown
    setTimeout(function()
        canParry = true
    end, parryCooldown * 1000)
end

-- Initialization
function start()
    player = getPlayerObject() -- You need to implement this
    createParryCircleVisual()  -- You need to implement this
    
    -- Spawn balls periodically
    setInterval(function()
        spawnBall()
    end, math.random(1000, 3000))
end

start()
