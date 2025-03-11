-- DeathBall Hover/Fly Script
-- Place this script in a LocalScript (for player-side functionality)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Hover/Fly Settings
local hoverHeight = 5 -- Height above the ground to hover
local flySpeed = 50 -- Speed of flying movement
local isFlying = false

-- Enable flying when the player jumps
UserInputService.JumpRequest:Connect(function()
    if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
        isFlying = true
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    end
end)

-- Disable flying when the player lands
humanoid.StateChanged:Connect(function(_, newState)
    if newState == Enum.HumanoidStateType.Landed then
        isFlying = false
    end
end)

-- Fly movement logic
local function fly()
    if not isFlying or not rootPart then
        return
    end

    -- Get player input
    local moveDirection = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + rootPart.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - rootPart.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - rootPart.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + rootPart.CFrame.RightVector
    end

    -- Normalize movement direction
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit
    end

    -- Apply movement
    rootPart.Velocity = moveDirection * flySpeed + Vector3.new(0, hoverHeight, 0)
end

-- Update fly movement every frame
RunService.Heartbeat:Connect(function()
    pcall(fly)
end)
