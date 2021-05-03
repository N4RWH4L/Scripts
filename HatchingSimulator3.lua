local Library = loadstring(game:HttpGet("https://github.com/N4RWH4L/Scripts/raw/main/Uwuware.lua", true))()

local Win = Library:CreateWindow("Auto Hatch")

Win:AddToggle({
    text = "Auto Coin",
    flag = "AutoCoin"
}) spawn(function()
    while wait() do
        if Library.flags.AutoCoin then
            if not game.Players.LocalPlayer.Character:FindFirstChild("Coin") then
                game:GetService("Players").LocalPlayer.Backpack.Coin.Parent = game.Players.LocalPlayer.Character
            end
            game.Players.LocalPlayer.Character:FindFirstChild("Coin"):Activate()
        end
    end
end)

local Eggs = Win:AddFolder("Eggs")
local eggs = {}

for _, v in pairs(game:GetService("Workspace").Eggs:GetChildren()) do
    if v:FindFirstChild("NameBrick") then
        eggs[#eggs+1] = v.Name
    end
end

Eggs:AddList({
    text = "Egg",
    flag = "Egg",
    values = eggs
})

Eggs:AddToggle({
    text = "Auto Open Egg",
    flag = "AutoOpen",
}) spawn(function()
    while wait(1) do
        if Library.flags.AutoOpen then
            game:GetService("ReplicatedStorage").KeyBind:InvokeServer("plsnohackplsnoooooob", game:GetService("Players").LocalPlayer, Library.flags.Egg, false, "", "", "", "", "", "")
        end
    end
end)

Eggs:AddButton({
    text = "Open Egg",
    callback = function()
        game:GetService("ReplicatedStorage").KeyBind:InvokeServer("plsnohackplsnoooooob", game:GetService("Players").LocalPlayer, Library.flags.Egg, false, "", "", "", "", "", "")
    end
})

local Credits = Win:AddFolder("Credits")

Credits:AddLabel({
    text = "Script - Narwhal#0187"
})

Credits:AddLabel({
    text = "UI - Jan"
})

Library:Init()