-- Modify AFK Lobby Timer Script
-- Changes the AFK lobby timer from 20 seconds to 1 second

-- Find the AFK lobby timer
local afkTimer = nil

-- Wait for the timer to exist in the game
while not afkTimer do
    for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()) do
        if v.Name == "AFKTimer" and v:IsA("TextLabel") then
            afkTimer = v
            break
        end
    end
    wait(0.1)
end

-- Modify the timer to 1 second
afkTimer.Text = "1" -- Change the displayed text to 1 second
afkTimer.Parent.Changed:Connect(function()
    afkTimer.Text = "1" -- Ensure the timer stays at 1 second
end)

-- Optional: Force the timer to end immediately
local function forceEndTimer()
    if afkTimer and afkTimer.Parent then
        afkTimer.Text = "0"
        afkTimer.Parent.Visible = false -- Hide the timer UI
    end
end

-- Call the function to force the timer to end
forceEndTimer()

print("AFK Timer modified to 1 second!")
