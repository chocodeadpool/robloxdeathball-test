-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local hoverEnabled = false -- Toggleable feature (default off)
local hoverHeight = 5 -- Default hover height
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
frame.Size = UDim2.new(0, 200, 0, 180) -- Increased height for sliders
frame.Position = UDim2.new(0.5, -100, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Visible = true -- UI is displayed by default
frame.Active = true -- Allows UI to be draggable
frame.Draggable = true -- Enables dragging

-- Title
local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "Hover Control"
title.Size = UDim2.new(1, 0, 0.15, 0)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Parent = frame
toggleButton.Size = UDim2.new(0.8, 0, 0.15, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.2, 0)
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 18

-- Hover Height Slider
local heightSlider = Instance.new("Frame")
heightSlider.Parent = frame
heightSlider.Size = UDim2.new(0.8, 0, 0.1, 0)
heightSlider.Position = UDim2.new(0.1, 0, 0.45, 0)
heightSlider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
heightSlider.BorderSizePixel = 0

local heightSliderFill = Instance.new("Frame")
heightSliderFill.Parent = heightSlider
heightSliderFill.Size = UDim2.new(0.5, 0, 1, 0) -- Default to 50% height
heightSliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
heightSliderFill.BorderSizePixel = 0

local heightSliderButton = Instance.new("TextButton")
heightSliderButton.Parent = heightSliderFill
heightSliderButton.Size = UDim2.new(1, 0, 1, 0)
heightSliderButton.Text = ""
heightSliderButton.BackgroundTransparency = 1

-- Hover Height Value Display
local heightValue = Instance.new("TextLabel")
heightValue.Parent = frame
heightValue.Size = UDim2.new(0.8, 0, 0.1, 0)
heightValue.Position = UDim2.new(0.1, 0, 0.6, 0)
heightValue.Text = "Height: 5"
heightValue.TextColor3 = Color3.fromRGB(255, 255, 255)
heightValue.BackgroundTransparency = 1
heightValue.Font = Enum.Font.SourceSans
heightValue.TextSize = 16

-- Slider Logic for Hover Height
local function updateHeightSlider(input)
    local sliderSize = heightSlider.AbsoluteSize.X
    local sliderPos = (input.Position.X - heightSlider.AbsolutePosition.X) / sliderSize
    sliderPos = math.clamp(sliderPos, 0, 1)
    heightSliderFill.Size = UDim2.new(sliderPos, 0, 1, 0)
    hoverHeight = math.floor(sliderPos * 20) -- Adjust height between 0 and 20
    heightValue.Text = "Height: " .. hoverHeight
end

heightSliderButton.MouseButton1Down:Connect(function()
    updateHeightSlider(UserInputService:GetMouseLocation())
    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateHeightSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

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
