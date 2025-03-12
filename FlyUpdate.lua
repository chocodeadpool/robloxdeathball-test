-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
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
frame.Draggable = true

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
toggleButton.TextSize = 18

-- Slider for Hover Height
local slider = Instance.new("Frame")
slider.Parent = frame
slider.Size = UDim2.new(0.8, 0, 0.1, 0)
slider.Position = UDim2.new(0.1, 0, 0.55, 0)
slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
slider.BorderSizePixel = 0

local sliderFill = Instance.new("Frame")
sliderFill.Parent = slider
sliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- Default to 50% height
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
sliderFill.BorderSizePixel = 0

local sliderButton = Instance.new("TextButton")
sliderButton.Parent = sliderFill
sliderButton.Size = UDim2.new(1, 0, 1, 0)
sliderButton.Text = ""
sliderButton.BackgroundTransparency = 1

-- Slider Value Display
local sliderValue = Instance.new("TextLabel")
sliderValue.Parent = frame
sliderValue.Size = UDim2.new(0.8, 0, 0.1, 0)
sliderValue.Position = UDim2.new(0.1, 0, 0.7, 0)
sliderValue.Text = "Height: 5"
sliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderValue.BackgroundTransparency = 1
sliderValue.Font = Enum.Font.SourceSans
sliderValue.TextSize = 16

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

-- Slider Logic
local function updateSlider(input)
    local sliderSize = slider.AbsoluteSize.X
    local sliderPos = (input.Position.X - slider.AbsolutePosition.X) / sliderSize
    sliderPos = math.clamp(sliderPos, 0, 1)
    sliderFill.Size = UDim2.new(sliderPos, 0, 1, 0)
    hoverHeight = sliderPos * 20 -- Adjust height range (0 to 20)
    sliderValue.Text = "Height: " .. math.floor(hoverHeight)
end

sliderButton.MouseButton1Down:Connect(function()
    updateSlider(UserInputService:GetMouseLocation())
    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

-- Hover Function
local function hover()
    if not hoverEnabled or not rootPart then
        return
    end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -50, 0), raycastParams) -- Increased raycast distance

    local targetHeight
    if raycastResult then
        targetHeight = raycastResult.Position.Y + hoverHeight
    else
        targetHeight = rootPart.Position.Y + hoverHeight
    end

    local hoverPosition = Vector3.new(rootPart.Position.X, targetHeight, rootPart.Position.Z)
    rootPart.CFrame = CFrame.new(hoverPosition)
end

-- Heartbeat Loop
local heartbeatConnection
heartbeatConnection = RunService.Heartbeat:Connect(function()
    pcall(hover)
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
