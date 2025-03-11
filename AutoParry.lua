-- Auto-Parry DeathBall Script with Toggleable UI
-- Host this script on GitHub and call it using a loader script.

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local ball = workspace:WaitForChild("DeathBall") -- Replace with your DeathBall name
local parryDistance = 10 -- Distance to auto-parry
local parryCooldown = 1 -- Cooldown in seconds
local canParry = true
local autoParryEnabled = false -- Toggleable feature

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Name = "AutoParryUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = frame
title.Text = "Auto-Parry"
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

-- Toggle Auto-Parry
toggleButton.MouseButton1Click:Connect(function()
    autoParryEnabled = not autoParryEnabled
    if autoParryEnabled then
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        print("Auto-Parry Enabled")
    else
        toggleButton.Text = "OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        print("Auto-Parry Disabled")
    end
end)

-- Auto-Parry Function
local function parryBall()
    if not ball or not rootPart or not autoParryEnabled or not canParry then
        return
    end

    if (rootPart.Position - ball.Position).Magnitude <= parryDistance then
        canParry = false
        ball.Velocity = (ball.Position - rootPart.Position).Unit * 50 -- Push the ball away
        print("Parried the ball!")

        -- Cooldown
        task.wait(parryCooldown)
        canParry = true
    end
end

-- Heartbeat Loop
RunService.Heartbeat:Connect(function()
    pcall(parryBall) -- Catch errors
end)

-- Toggle GUI with RightShift
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        frame.Visible = not frame.Visible
        print("GUI Toggled")
    end
end)

print("Auto-Parry Script Loaded")
