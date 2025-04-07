--[[
    Death Ball Auto-Parry Script
    ✅ Creates red parry zone
    ✅ Detects incoming balls
    ✅ Fires parry remote or simulates key
    ✅ Debug mode for troubleshooting
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")

local lp = Players.LocalPlayer
repeat wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local char = lp.Character
local root = char:WaitForChild("HumanoidRootPart")

-- Debug toggle
local DEBUG = true

-- Create parry detection circle
local circle = Instance.new("Part")
circle.Shape = Enum.PartType.Ball
circle.Size = Vector3.new(6, 6, 6)
circle.Anchored = true
circle.CanCollide = false
circle.Transparency = 0.5
circle.Material = Enum.Material.ForceField
circle.Color = Color3.fromRGB(255, 0, 0)
circle.Name = "AutoParryZone"
circle.Parent = workspace

-- Parry function
local function triggerParry()
    if DEBUG then print("[AutoParry] Attempting to parry...") end

    -- Check for RemoteEvent named "Parry"
    local remote = lp:FindFirstChild("Parry") or char:FindFirstChild("Parry")
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer()
        if DEBUG then print("[AutoParry] Fired Parry RemoteEvent") end
    else
        -- Fall back to simulating 'F' key
        VirtualInput:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
        VirtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
        if DEBUG then print("[AutoParry] Simulated 'F' key press") end
    end
end

-- Ball detection and parry trigger
local function detectAndParry()
    circle.Position = root.Position

    local parts = workspace:GetPartBoundsInBox(circle.CFrame, circle.Size, nil)
    for _, part in ipairs(parts) do
        if part:IsA("BasePart") and part.Name:lower():find("ball") then
            if (part.Position - root.Position).Magnitude <= 3.5 then
                if part.Velocity.Magnitude > 5 then
                    if DEBUG then
                        print("[AutoParry] Detected ball near: " .. part:GetFullName())
                        print("[AutoParry] Velocity:", part.Velocity.Magnitude)
                    end
                    triggerParry()
                    break
                end
            end
        end
    end
end

-- Main loop
RunService.RenderStepped:Connect(detectAndParry)
