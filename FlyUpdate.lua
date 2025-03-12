-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local hoverEnabled = false -- Toggleable feature (default off)
local hoverHeight = 5 -- Height above the ground to hover
local hoverSpeed = 50 -- Speed of hover movement
local isDragging = false -- For UI dragging
local dragStartPos, frameStartPos

-- Debug: Check if the script is running
print("Script loaded!") -- This should appear in the console if the script is executing

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "HoverUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 150) -- Increased height for slider
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Visible = true -- UI is displayed by default
frame.Active = true -- Allows UI to be draggable
frame.Draggable = true -- Enables dragging

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "Hover Control"
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

-- Slider for Hover Speed
local slider = Instance.new("Frame")
slider.Parent = frame
slider.Size = UDim2.new(0.8, 0, 0.1, 0)
slider.Position = UDim2.new(0.1, 0, 0.55, 0)
slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
slider.BorderSizePixel = 0

local sliderFill = Instance.new("Frame")
sliderFill.Parent = slider
sliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- Default to 50% speed
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
sliderValue.Text = "Speed: 50%"
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
    hoverSpeed = sliderPos * 100 -- Adjust speed based on slider position
    sliderValue.Text = "Speed: " .. math.floor(sliderPos * 100) .. "%"
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
