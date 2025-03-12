-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local hoverEnabled = false
local hoverHeight = 5 -- Default hover height
local isDragging = false
local dragStartPos, frameStartPos

-- Debug: Check if the script is running
print("Script loaded!")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "HoverUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Visible = true
frame.Active = true

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "Fly Height Control"
title.Size = UDim2.new(1, 0, 0.2, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Parent = frame
toggleButton.Size = UDim2.new(0.8, 0, 0.2, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
toggleButton.Font = Enum.Font.SourceSans

toggleButton.MouseButton1Click:Connect(function()
    hoverEnabled = not hoverEnabled
    if hoverEnabled then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        humanoid.PlatformStand = false -- Ensure the player doesn't stay floating
    end
end)

-- Slider UI
local slider = Instance.new("Frame")
slider.Parent = frame
slider.Size = UDim2.new(0.8, 0, 0.1, 0)
slider.Position = UDim2.new(0.1, 0, 0.55, 0)
slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local sliderFill = Instance.new("Frame")
sliderFill.Parent = slider
sliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- Default to 50%
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

local sliderButton = Instance.new("TextButton")
sliderButton.Parent = sliderFill
sliderButton.Size = UDim2.new(0, 10, 1, 0)
sliderButton.Position = UDim2.new(1, -5, 0, 0)
sliderButton.Text = ""
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

-- Display Value
local sliderValue = Instance.new("TextLabel")
sliderValue.Parent = frame
sliderValue.Size = UDim2.new(0.8, 0, 0.1, 0)
sliderValue.Position = UDim2.new(0.1, 0, 0.7, 0)
sliderValue.Text = "Height: 5"
sliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderValue.BackgroundTransparency = 1

-- Slider Logic
sliderButton.MouseButton1Down:Connect(function()
    isDragging = true
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderSize = slider.AbsoluteSize.X
        local sliderPos = (input.Position.X - slider.AbsolutePosition.X) / sliderSize
        sliderPos = math.clamp(sliderPos, 0, 1)
        sliderFill.Size = UDim2.new(sliderPos, 0, 1, 0)
        sliderButton.Position = UDim2.new(sliderPos, -5, 0, 0)
        hoverHeight = math.floor(sliderPos * 20) -- Adjust height range (0 to 20)
        sliderValue.Text = "Height: " .. hoverHeight
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- Smooth Hovering
local function hover()
    if not hoverEnabled or not rootPart then return end
    humanoid.PlatformStand = true
    local ray = workspace:Raycast(rootPart.Position, Vector3.new(0, -50, 0), RaycastParams.new())
    local targetHeight = (ray and ray.Position.Y or rootPart.Position.Y) + hoverHeight
    rootPart.Velocity = Vector3.new(0, (targetHeight - rootPart.Position.Y) * 2, 0)
end

RunService.Heartbeat:Connect(hover)

-- Toggle GUI with NumLock
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.NumLock then
        frame.Visible = not frame.Visible
    end
end)
