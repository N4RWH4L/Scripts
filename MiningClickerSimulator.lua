local Library = loadstring(game:HttpGet("https://github.com/N4RWH4L/Scripts/raw/main/Uwuware.lua", true))()

local Main = Library:CreateWindow("Mining Clicker Simulator")

local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
local inventoryUI = playerGui.inventory.mainFrame1234.a1

local statModule = require(game:GetService("ReplicatedStorage").Modules.statModule)

-- from https://stackoverflow.com/a/20100401
local function split(s, delimiter)
    local result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

local function toShortString(number)
    local shorts = {"k", "M", "B", "T", "qd", "Qn"}
    local pow = #shorts * 3

    for i = #shorts, 1, -1 do
        if number >= 10 ^ pow then
            return string.format("%.2f" .. shorts[i], number / 10 ^ pow)
        end
        pow = pow - 3
    end

    return tostring(number)
end

Main:AddToggle(
    {
        text = "Auto Mine",
        flag = "AutoMine"
    }
)
task.spawn(
    function()
        while task.wait() do
            if Library.flags.AutoMine then
                game:GetService("ReplicatedStorage").Remotes.Click:InvokeServer()
            end
        end
    end
)

do -- Auto Buy Pickaxe
    local pickaxeModule = require(game:GetService("ReplicatedStorage").Modules.pickaxesModule)

    local function getCurrentPickaxe()
        return game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool").Name
    end

    local function getNextPickaxe()
        local current = pickaxeModule.picks[getCurrentPickaxe()]

        local next

        for i, v in pairs(pickaxeModule.picks) do
            if v.Index == current.Index + 1 then
                next = i
            end
        end

        return next
    end

    Main:AddToggle(
        {
            text = "Auto Buy Pickaxe",
            flag = "AutoBuyPickaxe"
        }
    )
    task.spawn(
        function()
            while task.wait(1) do
                if Library.flags.AutoBuyPickaxe then
                    local nextPick = getNextPickaxe()
                    if nextPick then
                        game:GetService("ReplicatedStorage").Remotes.BuyPickaxe:InvokeServer(nextPick)
                    end
                end
            end
        end
    )
end

Main:AddToggle(
    {
        text = "Auto Rebirth",
        flag = "AutoRebirth"
    }
)
task.spawn(
    function()
        while task.wait(1) do
            if Library.flags.AutoRebirth then
                game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer()
            end
        end
    end
)

do -- Pets Section
    local Pets = Main:AddFolder("Pets")

    local eggList = {}

    -- I know I could have looped through the egg costs table, but this way puts them in order by default
    for _, v in pairs(game:GetService("ReplicatedStorage").itemStorage:GetChildren()) do
        if string.find(v.Name, "Egg") and statModule.eggCosts[v.Name] then
            table.insert(eggList, v.Name .. "-" .. toShortString(statModule.eggCosts[v.Name]))
        end
    end

    local petContainer = inventoryUI.a2.scrollingFrame

    local function interatePets(callback)
        for i, v in pairs(petContainer:GetChildren()) do
            if v:IsA("Frame") and v:FindFirstChild("dmg") then
                callback(i, v)
            end
        end
    end

    local function getPetType(ring)
        local petType

        for i, v in pairs(statModule.specialColors) do
            if ring.ImageColor3 == v then
                petType = i
            end
        end

        return ring.Visible and petType
    end

    local function getDamage(v)
        local name = v.ViewportFrame:FindFirstChildWhichIsA("Model").Name

        return statModule.getDmg(name, statModule.getLevel(name), getPetType(v.main.ring))
    end

    do -- Auto Equip Best Pets
        local function getCurrentPetValue()
            local value = 0

            interatePets(
                function(_, v)
                    if v.check.Visible then
                        value = value + getDamage(v)
                    end
                end
            )

            return value
        end

        local function getPetValues()
            local values = {}

            interatePets(
                function(_, v)
                    table.insert(values, getDamage(v))
                end
            )

            return values
        end

        local function getBestPetValue()
            local values = getPetValues()
            local maxValue = 0

            table.sort(
                values,
                function(a, b)
                    return a > b
                end
            )

            for i = 1, split(inventoryUI.a2.equipTxt.Text, "/")[2] do
                maxValue = maxValue + values[i]
            end

            return maxValue
        end

        Pets:AddToggle(
            {
                text = "Auto Equip Best Pets",
                flag = "AutoEquipBestPets"
            }
        )
        task.spawn(
            function()
                while task.wait(1) do
                    if Library.flags.AutoEquipBestPets and getBestPetValue() > getCurrentPetValue() then
                        print("Best: " .. getBestPetValue() .. "\nCurrent: " .. getCurrentPetValue())
                        firesignal(inventoryUI.equipBest.TextButton.Activated)
                    end
                end
            end
        )
    end

    Pets:AddList(
        {
            text = "Egg",
            flag = "Egg",
            values = eggList
        }
    )

    Pets:AddToggle(
        {
            text = "Auto Hatch Eggs",
            flag = "AutoHatchEggs"
        }
    )
    task.spawn(
        function()
            while task.wait(1) do
                if Library.flags.AutoHatchEggs then
                    game:GetService("ReplicatedStorage").Remotes.buyEgg:InvokeServer(
                        split(Library.flags.Egg, "-")[1],
                        1
                    )
                end
            end
        end
    )

    Pets:AddSlider(
        {
            text = "Minimum Value",
            flag = "MinimumValue",
            value = 100,
            min = 1,
            max = 100000
        }
    )

    Pets:AddToggle(
        {
            text = "Auto Delete Pets",
            flag = "AutoDeletePets"
        }
    )
    task.spawn(
        function()
            while task.wait(1) do
                if Library.flags.AutoDeletePets then
                    local toDelete = {}
                    local delete = false -- Delete variable because apparently taking the length of a lua dictionary isn't a thing

                    interatePets(
                        function(i, v)
                            if getDamage(v) < Library.flags.MinimumValue then
                                toDelete[v.Name] = true
                                delete = true
                            end
                        end
                    )

                    if delete then
                        game:GetService("ReplicatedStorage").Remotes.deleteItems:InvokeServer(toDelete)
                    end
                end
            end
        end
    )

    Pets:AddToggle(
        {
            text = "Auto Craft Goldens",
            flag = "AutoCraftGoldens"
        }
    )
    task.spawn(
        function()
            while task.wait(1) do
                if Library.flags.AutoCraftGoldens then
                    local petCounts = {}

                    interatePets(
                        function(i, v)
                            if not getPetType(v.main.ring) then
                                local name = v.ViewportFrame:FindFirstChildWhichIsA("Model").Name

                                if petCounts[name] then
                                    petCounts[name] = petCounts[name] + 1
                                else
                                    petCounts[name] = 1
                                end
                            end
                        end
                    )

                    for i, v in pairs(petCounts) do
                        if v >= 3 then
                            game:GetService("ReplicatedStorage").Remotes.CraftToGold:FireServer(i)
                        end
                    end
                end
            end
        end
    )
end

do -- Teleport Section
    local Teleports = Main:AddFolder("Teleports")

    for _, v in pairs(game:GetService("Workspace").TeleportBricks:GetChildren()) do
        Teleports:AddButton(
            {
                text = v.Name,
                callback = function()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                end
            }
        )
    end
end

do -- Misc Section
    local Misc = Main:AddFolder("Misc")

    Misc:AddToggle(
        {
            text = "Auto Collect Bonus",
            flag = "AutoCollectBonus"
        }
    )
    task.spawn(
        function()
            while task.wait(5) do
                game:GetService("ReplicatedStorage").Remotes.Bonus:InvokeServer()
            end
        end
    )

    Misc:AddToggle(
        {
            text = "Auto Collect Rewards",
            flag = "AutoCollectRewards"
        }
    )
    task.spawn(
        function()
            while task.wait(1) do
                if Library.flags.AutoCollectRewards then
                    for _, v in pairs(playerGui.rewards.achievementsPanel.RebirthCounter.scrollingFrame:GetChildren()) do
                        if
                            v:IsA("Frame") and v:FindFirstChild("standard") and
                                v.standard.buyAll.Frame.BackgroundColor3 == Color3.fromRGB(46, 204, 113)
                         then
                            game:GetService("ReplicatedStorage").Remotes.claimAchievment:FireServer(v.Name)
                        end
                    end
                end
            end
        end
    )
end

do
    local Other = Main:AddFolder("Other")

    Other:AddBind(
        {
            text = "Toggle GUI",
            key = Enum.KeyCode.BackSlash,
            callback = function()
                Library:Close()
            end
        }
    )

    Other:AddButton(
        {
            text = "Destroy GUI",
            callback = function()
                for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
                    if v:FindFirstChild("Hello, how are you today?") then
                        v:Destroy()
                    end
                end
            end
        }
    )
end

do
    local Credits = Main:AddFolder("Credits")

    Credits:AddLabel(
        {
            text = "Made by Narwhal#8928"
        }
    )

    Credits:AddLabel(
        {
            text = "UI by Jan"
        }
    )
end

Library:Init()
