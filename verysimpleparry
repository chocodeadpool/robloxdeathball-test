-- Simple Auto Parry for Death Ball
-- Made for executor use (client-side only)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

repeat wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
local char = lp.Character
local root = char:WaitForChild("HumanoidRootPart")

-- Create a red parry detection circle
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

-- Optional: Tween transparency for visual effect
task.spawn(function()
	while true do
		circle.Transparency = 0.5
		wait(0.5)
		circle.Transparency = 0.7
		wait(0.5)
	end
end)

-- Parry function (calls the remote if it exists)
local function triggerParry()
	-- This is the known parry remote in Death Ball (as of now)
	local remote = lp:FindFirstChild("Parry")
	if remote and remote:IsA("RemoteEvent") then
		remote:FireServer()
	else
		-- If remote isn't found, try simulating a keybind
		local virtualInput = game:GetService("VirtualInputManager")
		virtualInput:SendKeyEvent(true, Enum.KeyCode.F, false, nil)
		virtualInput:SendKeyEvent(false, Enum.KeyCode.F, false, nil)
	end
end

-- Detection loop
RunService.RenderStepped:Connect(function()
	if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end

	circle.Position = root.Position

	local parts = workspace:GetPartBoundsInBox(circle.CFrame, circle.Size)
	for _, part in pairs(parts) do
		if part.Name:lower():find("ball") and part:IsA("Part") and part.Velocity.Magnitude > 5 then
			triggerParry()
			break
		end
	end
end)
