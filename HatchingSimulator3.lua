local Library = loadstring(game:HttpGet("https://github.com/N4RWH4L/Scripts/raw/main/Uwuware.lua", true))()

local Win = Library:CreateWindow("Auto Hatch")

local Main = Win:AddFolder("Main")

Main:AddToggle({
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

local eggs = {}

for _, v in pairs(game:GetService("Workspace").Eggs:GetChildren()) do
    if v:FindFirstChild("NameBrick") then
        eggs[#eggs+1] = v.Name
    end
end

Main:AddList({
    text = "Egg",
    flag = "Egg",
    values = eggs
})

Main:AddToggle({
    text = "Auto Open Egg",
    flag = "AutoOpen",
}) spawn(function()
    while wait(1) do
        if Library.flags.AutoOpen then
            game:GetService("ReplicatedStorage").KeyBind:InvokeServer("plsnohackplsnoooooob", game:GetService("Players").LocalPlayer, Library.flags.Egg, false, "", "", "", "", "", "")
        end
    end
end)

Main:AddButton({
    text = "Open Egg",
    callback = function()
        game:GetService("ReplicatedStorage").KeyBind:InvokeServer("plsnohackplsnoooooob", game:GetService("Players").LocalPlayer, Library.flags.Egg, false, "", "", "", "", "", "")
    end
})

Win:AddLabel({
    text = "Credits"
})

Win:AddLabel({
    text = "Script - Narwhal#0187"
})

Win:AddLabel({
    text = "UI - Jan"
})

Library:Init()