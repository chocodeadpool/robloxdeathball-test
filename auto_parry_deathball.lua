-- Auto-Parry Death Ball Script (Optimized)
-- Place this script in a LocalScript (for player-side functionality)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local ball = workspace:WaitForChild("DeathBall") -- Replace with the name of your Death Ball
local parryDistance = 10 -- Distance at which auto-parry activates
local parryCooldown = 3 -- Cooldown time in seconds
local canParry = true

-- Assume these are the conditions for intermission and arena
local intermissionOver = false
local playerInArena = false

-- Function to check if the player is inside the arena
local function isPlayerInArena()
    -- Replace with your logic to check if the player is inside the arena
    -- For example, you might check if the player's position is within certain bounds
    return playerInArena
end

-- Function to parry the ball
local function parryBall()
    if not ball or not rootPart then
        return -- Exit if the ball or rootPart is missing
    end

    if intermissionOver and isPlayerInArena() and canParry and (rootPart.Position - ball.Position).Magnitude <= parryDistance then
        canParry = false
        ball.Velocity = (ball.Position - rootPart.Position).Unit * 50 -- Push the ball away
        print("Parried the ball!")
        
        -- Cooldown before next parry
        task.wait(parryCooldown)
        canParry = true
    end
end

-- Use a heartbeat event instead of a while loop
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(parryBall) -- Use pcall to catch errors
end)

-- Example event listeners to update intermission and arena status
-- Replace these with your actual event listeners
game:GetService("ReplicatedStorage").IntermissionOverEvent.OnClientEvent:Connect(function()
    intermissionOver = true
end)

game:GetService("ReplicatedStorage").PlayerEnteredArenaEvent.OnClientEvent:Connect(function()
    playerInArena = true
end)

game:GetService("ReplicatedStorage").PlayerLeftArenaEvent.OnClientEvent:Connect(function()
    playerInArena = false
end)
