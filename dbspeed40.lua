-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(newChar)
    character = newChar
end)

-- Speed variables
local originalWalkSpeed = 16
local boostedWalkSpeed = originalWalkSpeed + 40
local isBoosted = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedBoostGUI"
screenGui.Parent = player.PlayerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 150, 0, 50)
mainFrame.Position = UDim2.new(0.5, -75, 0, 10) -- Center top
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true -- Allows dragging
mainFrame.Draggable = true -- Makes frame movable
mainFrame.Parent = screenGui

-- Create title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 20)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Title text
local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Position = UDim2.new(0, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Speed Boost"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.SourceSansBold
titleText.TextSize = 14
titleText.Parent = titleBar

-- Create toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.8, 0, 0.5, 0)
toggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.Parent = mainFrame

-- Function to update speed
local function updateSpeed()
    if character and character:FindFirstChild("Humanoid") then
        if isBoosted then
            character.Humanoid.WalkSpeed = boostedWalkSpeed
            toggleButton.Text = "ON"
            toggleButton.TextColor3 = Color3.fromRGB(50, 255, 50)
        else
            character.Humanoid.WalkSpeed = originalWalkSpeed
            toggleButton.Text = "OFF"
            toggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
end

-- Toggle button click event
toggleButton.MouseButton1Click:Connect(function()
    isBoosted = not isBoosted
    updateSpeed()
end)

-- Update speed when character changes
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    updateSpeed()
end)

-- Initialize speed
if character and character:FindFirstChild("Humanoid") then
    originalWalkSpeed = character.Humanoid.WalkSpeed
    boostedWalkSpeed = originalWalkSpeed + 40
    updateSpeed()
end
