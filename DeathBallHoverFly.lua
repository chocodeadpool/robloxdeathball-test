-- Modified Script: Hover at a Specific Height
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local hoverHeight = 5 -- Desired height above the ground
local hoverForce = Vector3.new(0, 196.2, 0) -- Adjust this value for hover strength
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
raycastParams.FilterDescendantsInstances = {character} -- Ignore the player's character

-- Function to check the ground and adjust hover height
local function hover()
    local rayOrigin = rootPart.Position
    local rayDirection = Vector3.new(0, -hoverHeight - 5, 0) -- Raycast downward
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

    if raycastResult then
        local groundPosition = raycastResult.Position
        local targetPosition = groundPosition + Vector3.new(0, hoverHeight, 0)
        local offset = targetPosition - rootPart.Position

        -- Apply force to hover at the desired height
        rootPart.Velocity = rootPart.Velocity * 0.9 + offset * 10 -- Smooth hover
    end
end

-- Use a heartbeat event to continuously adjust hover
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(hover) -- Use pcall to catch errors
end)
