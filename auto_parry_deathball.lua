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

-- Variables to track game state
local intermissionOver = false
local playerInArena = false

-- Function to check if the player is inside the arena
local function isPlayerInArena()
    -- Replace this with your logic to check if the player is inside the arena
    -- Example: Check if the player's position is within certain bounds
    local arenaCenter = Vector3.new(0, 0, 0) -- Replace with your arena's center position
    local arenaSize = Vector3.new(100, 100, 100) -- Replace with your arena's size
    local playerPosition = rootPart.Position

    return (playerPosition - arenaCenter).Magnitude <= arenaSize.Magnitude / 2
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
local function onIntermissionOver()
    intermissionOver = true
    print("Intermission is over!")
end

local function onPlayerEnteredArena()
    playerInArena = true
    print("Player entered the arena!")
end

local function onPlayerLeftArena()
    playerInArena = false
    print("Player left the arena!")
end

-- Replace these with your actual RemoteEvents or BindableEvents
local replicatedStorage = game:GetService("ReplicatedStorage")
local intermissionOverEvent = replicatedStorage:WaitForChild("IntermissionOverEvent")
local playerEnteredArenaEvent = replicatedStorage:WaitForChild("PlayerEnteredArenaEvent")
local playerLeftArenaEvent = replicatedStorage:WaitForChild("PlayerLeftArenaEvent")

-- Connect to the events
intermissionOverEvent.OnClientEvent:Connect(onIntermissionOver)
playerEnteredArenaEvent.OnClientEvent:Connect(onPlayerEnteredArena)
playerLeftArenaEvent.OnClientEvent:Connect(onPlayerLeftArena)
