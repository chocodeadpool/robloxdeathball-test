-- Hover + Auto-Parry Script for Roblox Death Ball
-- Host this script on GitHub and call it using a loader script.

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local hoverEnabled = false -- Toggleable feature (default off)
local hoverHeight = 15 -- Height above the ground to hover
local hoverSpeed = 50 -- Speed of hover movement
local autoParryEnabled = false -- Toggleable feature (default off)
local parryDistance = 10 -- Distance to auto-parry
local parryCooldown = 1 -- Cooldown in seconds
local canParry = true

-- Debug: Check if the script is running
print("Script loaded!") -- This should appear in the console if the script is executing

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "HoverParryUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 150) -- Increased height for the new button
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Visible = true -- UI is displayed by default

local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "Hover + Parry"
title.Size = UDim2.new(1, 0, 0.2, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local hoverToggleButton = Instance.new("TextButton")
hoverToggleButton.Parent = frame
hoverToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
hoverToggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
hoverToggleButton.Text = "Hover: OFF"
hoverToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hoverToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
hoverToggleButton.Font = Enum.Font.SourceSans
hoverToggleButton.TextSize = 18

local parryToggleButton = Instance.new("TextButton")
parryToggleButton.Parent = frame
parryToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
parryToggleButton.Position = UDim2.new(0.1, 0, 0.6, 0)
parryToggleButton.Text = "Parry: OFF"
parryToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
parryToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
parryToggleButton.Font = Enum.Font.SourceSans
parryToggleButton.TextSize = 18

-- Toggle Hover
hoverToggleButton.MouseButton1Click:Connect(function()
    hoverEnabled = not hoverEnabled
    if hoverEnabled then
        hoverToggleButton.Text = "Hover: ON"
        hoverToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        print("Hover Enabled")
    else
        hoverToggleButton.Text = "Hover: OFF"
        hoverToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        print("Hover Disabled")
    end
end)

-- Toggle Auto-Parry
parryToggleButton.MouseButton1Click:Connect(function()
    autoParryEnabled = not autoParryEnabled
    if autoParryEnabled then
        parryToggleButton.Text = "Parry: ON"
        parryToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        print("Auto-Parry Enabled")
    else
        parryToggleButton.Text = "Parry: OFF"
        parryToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        print("Auto-Parry Disabled")
    end
end)

-- Hover Function
local function hover()
    if not hoverEnabled or not rootPart then
        return
    end

    -- Calculate hover position
    local ray = Ray.new(rootPart.Position, Vector3.new(0, -hoverHeight * 2, 0))
    local hit, position = workspace:FindPartOnRay(ray, character)

    if hit then
        local hoverPosition = position + Vector3.new(0, hoverHeight, 0)
        local direction = (hoverPosition - rootPart.Position).Unit
        rootPart.Velocity = direction * hoverSpeed
    end
end

-- Auto-Parry Function
local function parryBall()
    if not autoParryEnabled or not canParry then
        return
    end

    local ball = workspace:FindFirstChild("DeathBall") -- Replace "DeathBall" with the actual ball name
    if not ball or not rootPart then
        return
    end

    local distance = (rootPart.Position - ball.Position).Magnitude
    if distance <= parryDistance then
        canParry = false
        ball.Velocity = (ball.Position - rootPart.Position).Unit * 50 -- Push the ball away
        print("Parried the ball!")

        -- Cooldown
        task.wait(parryCooldown)
        canParry = true
    end
end

-- Heartbeat Loop
local heartbeatConnection
heartbeatConnection = RunService.Heartbeat:Connect(function()
    pcall(hover) -- Catch errors
    pcall(parryBall) -- Catch errors
end)

-- Toggle GUI with NumLock
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.NumLock then
        frame.Visible = not frame.Visible
        print("GUI Toggled. Visible:", frame.Visible)
    end
end)

-- Cleanup on character change or script stop
local function cleanup()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
    if screenGui then
        screenGui:Destroy()
    end
end

-- Listen for character changes
player.CharacterAdded:Connect(function()
    cleanup()
    character = player.Character
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

player.CharacterRemoving:Connect(cleanup)

-- Debug: Verify GUI creation
print("GUI created. Hover and Parry are OFF by default.")
