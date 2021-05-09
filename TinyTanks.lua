local Library = loadstring(game:HttpGet("https://gist.githubusercontent.com/N4RWH4L/00babeb1f70d74817f25990d5fc8a9ca/raw/4c24135c572df5864195f8273b2be8cca53e5e1c/Uwuware.lua", true))()

local function getTank()
    local tank = game:GetService("Workspace").Tanks:FindFirstChild("Tank-"..game.Players.LocalPlayer.Name)
    repeat
        wait()
        tank = game:GetService("Workspace").Tanks:FindFirstChild("Tank-"..game.Players.LocalPlayer.Name)
    until tank
    return tank
end

game:GetService("Workspace").Tanks.ChildAdded:Connect(function(v)
    if v.Name == "Tank-"..game.Players.LocalPlayer.Name then
        v:WaitForChild("Settings").MoveSpeed.Value = Library.flags.MovementSpeed
        v.Settings.RotationSpeed.Value = Library.flags.RotationSpeed
        v.Settings.MaxFireRate.Value = Library.flags.Firerate
        if Library.flags.InfiniteAmmo then
            v.Settings.LoadedShots.Value = 9999
        end
        if Library.flags.InstantReload then
            v.Settings.ReloadTime.Value = 0
        end
        if Library.flags.InfiniteAbilities then
            v.Settings.AbilityCooldown.Value = 0
        end
    end
end)

local Main = Library:CreateWindow("Tiny Tanks")

do
    local TankMods = Main:AddFolder("Mods")

    TankMods:AddList({
        text = "Ammo Type",
        flag = "AmmoType",
        values = {
            "Base",
            "Bouncy",
            "Rocket",
            "Piercing",
            "AoE"
        }
    })

    TankMods:AddButton({
        text = "Load Ammo",
        callback = function()
            getTank().Remotes.LoadAmmoType:FireServer(Library.flags.AmmoType)
        end
    })

    TankMods:AddSlider({
        text = "Movement Speed",
        flag = "MovementSpeed",
        min = 1,
        max = 100,
        value = 20,
        callback = function()
            getTank().Settings.MoveSpeed.Value = Library.flags.MovementSpeed
        end
    })

    TankMods:AddSlider({
        text = "Rotation Speed",
        flag = "RotationSpeed",
        min = 1,
        max = 1000,
        value = 200,
        callback = function()
            getTank().Settings.RotationSpeed.Value = Library.flags.RotationSpeed
        end
    })

    TankMods:AddToggle({
        text = "Infinite Ammo",
        flag = "InfiniteAmmo",
        callback = function()
            if Library.flags.InfiniteAmmo then
                getTank().Settings.LoadedShots.Value = 9999
            end
        end
    })

    TankMods:AddToggle({
        text = "Instant Reload",
        flag = "InstantReload",
        callback = function()
            if Library.flags.InstantReload then
                getTank().Settings.ReloadTime.Value = 0
            end
        end
    })
    
    TankMods:AddToggle({
        text = "Infinite Abilities",
        flag = "InfiniteAbilities",
        callback = function()
            if Library.flags.InfiniteAbilities then
                getTank().Settings.AbilityCooldown.Value = 0
            end
        end
    })

    TankMods:AddSlider({
        text = "Firerate",
        flag = "Firerate",
        min = 0,
        max = 1,
        value = 0.2,
        float = 0.01,
        callback = function()
            getTank().Settings.MaxFireRate.Value = Library.flags.Firerate
        end
    })
end

do
    local OP = Main:AddFolder("OP")

    OP:AddToggle({
        text = "Kill All",
        flag = "KillAll"
    }) spawn(function()
        while wait() do
            if Library.flags.KillAll then
                for _, v in pairs(game:GetService("Workspace").Tanks:GetChildren()) do
                    if v.Name ~= getTank().Name and v.Settings.TeamColor.Value ~= getTank().Settings.TeamColor.Value and v:FindFirstChild("Base") then
                        game:GetService("ReplicatedStorage").Remotes.FireBullet:FireServer(0, v.Base.CFrame, {})
                    end
                end
                wait(1)
            end
        end
    end)
end

do
    local Other = Main:AddFolder("Other")

    Other:AddBind({
        text = "Toggle GUI",
        key = Enum.KeyCode.BackSlash,
        callback = function()
            Library:Close()
        end
    })

    Other:AddButton({
        text = "Destroy GUI",
        callback = function()
            for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
                if v:FindFirstChild("Hello, how are you today?") then
                    v:Destroy()
                end
            end
        end
    })
end

do
    local Credits = Main:AddFolder("Credits")

    Credits:AddLabel({
        text = "Made by Narwhal#0187"
    })

    Credits:AddLabel({
        text = "UI by Jan"
    })
end

Library:Init()