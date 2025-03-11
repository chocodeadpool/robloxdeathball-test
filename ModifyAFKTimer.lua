-- AFK Lobby Timer Change Script
-- Host this script on GitHub and call it using a loader script.

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Variables
local timerChanged = false -- Track if the timer has been changed
local targetTimer = 1 -- Target timer value (1 second)

-- Debug: Check if the script is running
print("Script loaded!") -- This should appear in the console if the script is executing

-- Function to recursively search for the AFK timer
local function findAFKTimer(gui)
    for _, child in pairs(gui:GetDescendants()) do
        if child:IsA("TextLabel") and child.Name == "AFKTimer" then
            return child
        end
    end
    return nil
end

-- Function to change the AFK lobby timer
local function changeTimer()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local afkTimer = findAFKTimer(playerGui)

    if afkTimer then
        -- Change the timer value
        afkTimer.Text = tostring(targetTimer)
        timerChanged = true
        print("Timer changed successfully to 1 second!")
    else
        warn("AFK Timer not found in PlayerGui!")
    end
end

-- Heartbeat Loop to continuously check for the timer
RunService.Heartbeat:Connect(function()
    if not timerChanged then
        pcall(changeTimer) -- Catch errors
    end
end)

-- Debug: Verify script execution
print("Attempting to change AFK timer...")
