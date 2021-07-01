--Settings
local fov = 100
local circle = true

--Script
assert(hookmetamethod, "Your exploit isn't supported")
assert(getnamecallmethod or get_namecall_method, "Your exploit isn't supported")

local plr = game:GetService("Players").LocalPlayer
local currentCamera = game:GetService("Workspace").CurrentCamera
local mouse = plr:GetMouse()

if circle then
    local GuiService = game:GetService("GuiService")
    
    local circle = Drawing.new("Circle")
    circle.Transparency = 1
    circle.Thickness = 2
    circle.Color = Color3.fromRGB(255, 255, 255)
    circle.NumSides = 12
    circle.Filled = false
    circle.Visible = true
    circle.Radius = fov
    circle.Position = Vector2.new(mouse.X, mouse.Y + GuiService:GetGuiInset().Y)

    game:GetService("RunService"):BindToRenderStep("CirclePositioning", 10, function()
	    circle.Position = Vector2.new(mouse.X, mouse.Y + GuiService:GetGuiInset().Y)
    end) 
end

local function getPlr()
	local bestPlr
	local smallest = math.huge

	for _, v in pairs(game:GetService("Players"):GetPlayers()) do
		if v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Head") and v.TeamColor ~= plr.TeamColor then
			local mag = (Vector2.new(currentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position).X, currentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position).Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
			
			if fov >= mag and mag < smallest then
				bestPlr = v
				smallest = mag
			end
		end
	end

	return bestPlr or nil
end

local callMethod = getnamecallmethod or get_namecall_method
local newClosure = newcclosure or function(f)
	return f
end
local old
old = hookmetamethod(game, "__namecall", newClosure(function(...)
	local isEvent = tostring(callMethod()) == "FireServer"
	local arguments = {...}

	if isEvent and tostring(arguments[1]) == "HitPart"  then
		arguments[2] = getPlr() and getPlr().Character.Head or arguments[2]
		arguments[3] = getPlr() and getPlr().Character.Head.Position or arguments[3]

		return arguments[1].FireServer(unpack(arguments))
	end

	return old(...)
end))