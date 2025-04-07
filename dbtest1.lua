-- Death Ball Game for Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Configuration
local PARRY_RADIUS = 5
local BALL_SPEED = 50
local PARRY_COOLDOWN = 0.5
local BALL_COLOR = Color3.fromRGB(255, 0, 0)
local PARRY_COLOR = Color3.fromRGB(0, 255, 0)
local SPAWN_INTERVAL = {1, 3} -- min, max in seconds

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Create parry circle
local parryCircle = Instance.new("Part")
parryCircle.Name = "ParryCircle"
parryCircle.Shape = Enum.PartType.Cylinder
parryCircle.Size = Vector3.new(0.2, PARRY_RADIUS*2, PARRY_RADIUS*2)
parryCircle.Transparency = 0.7
parryCircle.CanCollide = false
parryCircle.Anchored = true
parryCircle.Material = Enum.Material.Neon
parryCircle.Color = PARRY_COLOR
parryCircle.Parent = character

local canParry = true
local currentBall = nil

-- Function to spawn a ball
local function spawnBall()
    if currentBall and currentBall.Parent then return end
    
    -- Random spawn position around the player
    local spawnPosition = humanoidRootPart.Position + 
        Vector3.new(
            math.random(-20, 20),
            5,
            math.random(-20, 20)
        )
    
    -- Create ball
    currentBall = Instance.new("Part")
    currentBall.Name = "DeathBall"
    currentBall.Shape = Enum.PartType.Ball
    currentBall.Size = Vector3.new(2, 2, 2)
    currentBall.Position = spawnPosition
    currentBall.Color = BALL_COLOR
    currentBall.Material = Enum.Material.Neon
    currentBall.Anchored = false
    currentBall.CanCollide = true
    currentBall.Massless = true
    
    -- Add velocity toward player with some randomness
    local direction = (humanoidRootPart.Position - spawnPosition).Unit
    direction = direction + Vector3.new(
        math.random(-10, 10)/20,
        0,
        math.random(-10, 10)/20
    ).Unit
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = direction * BALL_SPEED
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Parent = currentBall
    
    currentBall.Parent = workspace
    
    -- Add touch detection
    currentBall.Touched:Connect(function(hit)
        if hit.Parent == character and canParry then
            parryBall()
        end
    end)
    
    -- Clean up if ball gets stuck
    game:GetService("Debris"):AddItem(currentBall, 10)
end

-- Function to parry the ball
local function parryBall()
    if not currentBall or not currentBall.Parent then return end
    if not canParry then return end
    
    canParry = false
    
    -- Visual feedback
    parryCircle.Color = Color3.fromRGB(255, 255, 255)
    task.delay(0.1, function()
        parryCircle.Color = PARRY_COLOR
    end)
    
    -- Calculate reflection with randomness
    local ballPosition = currentBall.Position
    local playerPosition = humanoidRootPart.Position
    local incomingDirection = (ballPosition - playerPosition).Unit
    
    local reflectedDirection = Vector3.new(
        -incomingDirection.X + math.random(-5, 5)/10,
        0,
        -incomingDirection.Z + math.random(-5, 5)/10
    ).Unit
    
    -- Apply new velocity
    local bodyVelocity = currentBall:FindFirstChildOfClass("BodyVelocity")
    if bodyVelocity then
        bodyVelocity.Velocity = reflectedDirection * BALL_SPEED * 1.5
    end
    
    -- Cooldown
    task.delay(PARRY_COOLDOWN, function()
        canParry = true
    end)
end

-- Update parry circle position
local function updateParryCircle()
    parryCircle.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, 0, math.pi/2)
end

-- Main game loop
RunService.Heartbeat:Connect(function(deltaTime)
    updateParryCircle()
    
    if currentBall and currentBall.Parent then
        -- Add some curve to the ball
        local bodyVelocity = currentBall:FindFirstChildOfClass("BodyVelocity")
        if bodyVelocity then
            bodyVelocity.Velocity = bodyVelocity.Velocity + 
                Vector3.new(
                    math.random(-5, 5)/10,
                    0,
                    math.random(-5, 5)/10
                )
        end
    end
end)

-- Spawn balls periodically
while true do
    spawnBall()
    task.wait(math.random(SPAWN_INTERVAL[1]*10, SPAWN_INTERVAL[2]*10)/10)
end
