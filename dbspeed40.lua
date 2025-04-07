-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player setup
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Speed variables
local boostAmount = 15
local isBoosted = false
local moveDirection = Vector3.new(0, 0, 0)
local speedConnection = nil
local inputConnection = nil

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedBoostGUI"
screenGui.Parent = player.PlayerGui

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 150, 0, 50)
mainFrame.Position = UDim2.new(0.5, -75, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
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

-- Function to apply velocity-based movement boost
local function applyMovementBoost()
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    
    if inputConnection then
        inputConnection:Disconnect()
        inputConnection = nil
    end
    
    if isBoosted then
        -- Track movement input
        inputConnection = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                return
            end
            
            if input.UserInputType == Enum.UserInputType.Gamepad1 then
                moveDirection = Vector3.new(input.Position.X, 0, -input.Position.Y)
            end
        end)
        
        -- Apply boost force
        speedConnection = RunService.Heartbeat:Connect(function()
            if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                local currentVelocity = rootPart.Velocity
                
                -- Only boost when player is trying to move
                if moveDirection.Magnitude > 0 or humanoid.MoveDirection.Magnitude > 0 then
                    local boostDirection = humanoid.MoveDirection.Magnitude > 0 and humanoid.MoveDirection or moveDirection.Unit
                    local boostForce = boostDirection * boostAmount
                    
                    -- Apply velocity while preserving vertical movement (jumping/falling)
                    rootPart.Velocity = Vector3.new(
                        currentVelocity.X + boostForce.X,
                        currentVelocity.Y, -- Keep original Y velocity
                        currentVelocity.Z + boostForce.Z
                    )
                end
            end
        end)
        
        toggleButton.Text = "ON"
        toggleButton.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        toggleButton.Text = "OFF"
        toggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end

-- Toggle button click event
toggleButton.MouseButton1Click:Connect(function()
    isBoosted = not isBoosted
    applyMovementBoost()
end)

-- Handle character changes
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    character:WaitForChild("HumanoidRootPart")
    applyMovementBoost()
end)

-- Initialize
applyMovementBoost()
