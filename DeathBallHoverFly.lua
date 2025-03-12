-- Hover Script for Roblox Death Ball
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
local hoverHeight = 5 -- Height above the ground to hover
local hoverSpeed = 50 -- Speed of hover movement

-- Debug: Check if the script is running
print("Script loaded!") -- This should appear in the console if the script is executing

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "HoverUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Visible = true -- UI is displayed by default

local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "Hover"
title.Size = UDim2.new(1, 0, 0.3, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local toggleButton = Instance.new("TextButton")
toggleButton.Parent = frame
toggleButton.Size = UDim2.new(0.8, 0, 0.4, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 18

-- Toggle Hover
toggleButton.MouseButton1Click:Connect(function()
    hoverEnabled = not hoverEnabled
    if hoverEnabled then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        print("Hover Enabled")
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        print("Hover Disabled")
    end
end)

-- Make the UI draggable
local dragging = false
local dragStartPos
local frameStartPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = Vector2.new(input.Position.X, input.Position.Y)
        frameStartPos = frame.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local dragDelta = Vector2.new(input.Position.X, input.Position.Y) - dragStartPos
        frame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + dragDelta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + dragDelta.Y)
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Hover Function
local function hover()
    if not hoverEnabled or not rootPart then
        return
    end

    -- Calculate hover position
    local hoverPosition = rootPart.Position + Vector3.new(0, hoverHeight, 0)
    local direction = (hoverPosition - rootPart.Position).Unit
    rootPart.Velocity = direction * hoverSpeed
end

-- Heartbeat Loop
local heartbeatConnection
heartbeatConnection = RunService.Heartbeat:Connect(function()
    pcall(hover) -- Catch errors
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
print("GUI created. Hover is OFF by default.")
