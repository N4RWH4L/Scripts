local Library = loadstring(game:HttpGet("https://github.com/N4RWH4L/Scripts/raw/main/Uwuware.lua", true))()

local Win = Library:CreateWindow("Tapping Gods")

Win:AddToggle({
    text = "Auto Tap",
    flag = "AutoTap"
}) spawn(function()
    while wait() do
        if Library.flags.AutoTap then
            game:GetService("ReplicatedStorage").Events.Tap:FireServer()
        end
    end
end)

Win:AddToggle({
    text = "Auto Equip Pets",
    flag = "AutoEquipPets"
}) spawn(function()
    while wait(1) do
        if Library.flags.AutoEquipPets then
            game:GetService("ReplicatedStorage").Events.PetAction:InvokeServer("EquipBest")
        end
    end
end)

local Rebirth = Win:AddFolder("Rebirths")

local Rebirths = {}

for v, _ in pairs(require(game:GetService("ReplicatedStorage").Modules.Rebirths)) do
    Rebirths[#Rebirths+1] = tostring(v)
end

Rebirth:AddList({
    text = "Rebirths",
    flag = "Rebirths",
    values = Rebirths
})

Rebirth:AddToggle({
    text = "Auto Rebirth",
    flag = "AutoRebirth"
}) spawn(function()
    while wait(1) do
        if Library.flags.AutoRebirth then
            game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(tonumber(Library.flags.Rebirths))
        end
    end
end)

local Egg = Win:AddFolder("Eggs")

local Eggs = {}

for _, v in pairs(game:GetService("Workspace").Eggs:GetChildren()) do
    Eggs[#Eggs+1] = v.Name
end

Egg:AddList({
    text = "Egg",
    flag = "Egg",
    values = Eggs
})

Egg:AddLabel({
    text = "You must be near the egg"
})

Egg:AddToggle({
    text = "Auto Open Egg",
    flag = "AutoOpen"
}) spawn(function()
    while wait(1) do
        if Library.flags.AutoOpen then
            game:GetService("ReplicatedStorage").Events.OpenEgg:FireServer(Library.flags.Egg)
        end
    end
end)

local Upgrade = Win:AddFolder("Upgrades")

for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.CoreUI.Frames.Upgrades.Holder.ScrollingFrame:GetChildren()) do
    if v:IsA("Frame") then
        Upgrade:AddToggle({
            text = v.Name,
            flag = v.Name
        }) spawn(function()
            while wait(1) do
                if Library.flags[v.Name] then
                    game:GetService("ReplicatedStorage").Events.UpgradeAction:InvokeServer(v.Name)
                end
            end
        end)
    end
end

local Credits = Win:AddFolder("Credits")

Credits:AddLabel({
    text = "Scripting - Narwhal#0187"
})

Credits:AddLabel({
    text = "UI - Jan"
})

Library:Init()