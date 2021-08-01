local HB = game:GetService("RunService").Heartbeat

local Library = loadstring(game:HttpGet("https://github.com/N4RWH4L/Scripts/raw/main/Uwuware.lua", true))()

local Win = Library:CreateWindow("Soda Champions Sim")

local Main = Win:AddFolder("Main") do
    Main:AddToggle({
        text = "Auto Tap",
        flag = "AutoTap"
    }) spawn(function()
        while HB:Wait() do
            if Library.flags.AutoTap then
                game:GetService("ReplicatedStorage").Events.GameMechanics.Events.TappingEvent:FireServer()
            end
        end
    end)

    Main:AddList({
        text = "Ammount",
        flag = "Ammount",
        values = require(game:GetService("ReplicatedStorage").Modules.Progression).RebirthTable --Adds an extra 1 for some reason
    })

    Main:AddToggle({
        text = "Auto Rebirth",
        flag = "AutoRebirth"
    }) spawn(function()
        while HB:Wait() do
            if Library.flags.AutoRebirth then
                game:GetService("ReplicatedStorage").Events.GameMechanics.Events.RebirthEvent:FireServer(tonumber(Library.flags.Ammount))
            end
        end
    end)
end

local Credits = Win:AddFolder("Credits") do
    Credits:AddLabel({
        text = "Script - Narwhal#2358"
    })

    Credits:AddLabel({
        text = "UI - Jan"
    })
end

Library:Init()