-- Auto-Parry Death Ball Script
-- Place this script in a LocalScript (for player-side functionality)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local ball = workspace:WaitForChild("DeathBall") -- Replace with the name of your Death Ball
local parryDistance = 10 -- Distance at which auto-parry activates
local parryCooldown = 3 -- Cooldown time in seconds
local canParry = true

-- Function to parry the ball
local function parryBall()
    if canParry and (rootPart.Position - ball.Position).Magnitude <= parryDistance then
        canParry = false
        ball.Velocity = (ball.Position - rootPart.Position).Unit * 50 -- Push the ball away
        print("Parried the ball!")
        
        -- Cooldown before next parry
        task.wait(parryCooldown)
        canParry = true
    end
end

-- Main loop to check for parry conditions
while true do
    parryBall()
    task.wait(0.1) -- Adjust the wait time for performance
end
