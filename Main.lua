if getgenv().GrooveLoaded then
    if getgenv().GrooveUI then
        getgenv().GrooveUI:Destroy()
    end
else
    getgenv().GrooveLoaded = true
end

local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")

local tempStuff = workspace.TempStuff

local player = game.Players.LocalPlayer

local remotes = replicatedStorage.Remotes.BlockDefaultRE

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
getgenv().GrooveUI = Rayfield

local Window = Rayfield:CreateWindow({
   Name = "Groove Arena",
   Icon = 106778899500943,
   LoadingTitle = "Loading Groove Arena",
   LoadingSubtitle = "by unknown",
   ShowText = "Groove",
   Theme = "AmberGlow",

   ToggleUIKeybind = "LeftControl",

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "groove_arena"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local function notify(title, contnt, duration, image)
    Rayfield:Notify({
        Title = title,
        Content = contnt,
        Duration = duration,
        Image = image or "rewind",
    })
end

local MainTab = Window:CreateTab("Main", "swords")
local Tab2 = Window:CreateTab("Farm", "circle-pound-sterling")
MainTab:CreateSection("Section")

local auto = false
local farmCoins = false
local connection

local function connectParry(character)
    if connection then
        connection:Disconnect()
        connection = nil
    end
    if not auto then
        return
    end

    local hitbox = character:WaitForChild("Hitbox")
    connection = hitbox.Touched:Connect(function(hit)
        if hit.Name == "BallServer" then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                remotes:FireServer(root.Position)
            end
        end
    end)
end

local function autofarmCoins(character)
    task.spawn(function()
        while farmCoins do
            if character and character.PrimaryPart then
                for _, coin in pairs(tempStuff:GetChildren()) do
                    character:SetPrimaryPartCFrame(coin.CFrame * CFrame.new(0, 2, 0))
                    task.wait(0.35)
                    if not farmCoins then break end
                end
            end
            task.wait(0.3)
        end
    end)
end

player.CharacterAdded:Connect(function(char)
    connectParry(char)
    if farmCoins then
        autofarmCoins(char)
    end
end)

local char = player.Character
if char then
    connectParry(char)
end

MainTab:CreateToggle({
   Name = "Auto parry (WorkInProgress)",
   CurrentValue = false,
   Flag = "AutoParry",
   Callback = function(Value)
    auto = Value
    if auto then
        notify("Auto Parry", "🟩 Auto Parry Enabled", 1.2, "swords")
        if player.Character then
            connectParry(player.Character)
        end
    else
        notify("Auto Parry", "🟥 Auto Parry Disabled", 1.2, "swords")
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
   end,
})

Tab2:CreateToggle({
   Name = "Auto Farm Coins",
   CurrentValue = false,
   Flag = "AutoCoins",
   Callback = function(Value)
      farmCoins = Value
      if farmCoins then
          notify("Auto Farm", "🟩 Auto Farm Coins Enabled", 1.2, "coins")
          if player.Character then
              autofarmCoins(player.Character)
          end
      else
          notify("Auto Farm", "🟥 Auto Farm Coins Disabled", 1.2, "coins")
      end
   end,
})

if userInputService.KeyboardEnabled then
    notify("Groove Arena", "Press the key Left Control next to Windows key to open/close the menu!", 6.5, "rewind")
end

Rayfield:LoadConfiguration()
