local UIS = game:GetService("UserInputService")
local TPS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 1. UI Yaratish
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MainList = Instance.new("ScrollingFrame")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "Bunyodbek_Forest_Hub"
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(15, 25, 15)
Frame.Position = UDim2.new(0.3, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 330, 0, 550)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 3
Frame.BorderColor3 = Color3.fromRGB(255, 165, 0)

Title.Parent = Frame
Title.Text = "99 NIGHTS FOREST HUB | K: Open"
Title.Size = UDim2.new(1, 0, 0.08, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(255, 100, 0)

-- X va K tugmalari
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Frame
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)

UIS.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == Enum.KeyCode.K then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

MainList.Parent = Frame
MainList.Position = UDim2.new(0, 5, 0.1, 0)
MainList.Size = UDim2.new(1, -10, 0.88, 0)
MainList.CanvasSize = UDim2.new(0, 0, 2, 0)
MainList.BackgroundTransparency = 1

local function createButton(name, y, color, callback)
    local b = Instance.new("TextButton")
    b.Parent = MainList
    b.Text = name
    b.Size = UDim2.new(1, -10, 0, 40)
    b.Position = UDim2.new(0, 5, 0, y)
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1, 1, 1)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- --- FUNKSIYALAR BO'LIMI ---

-- 1. CAMERA-RELATIVE FLY (Faqat WASD + Kamera yo'nalishi)
local flying = false
local flySpeed = 50
local flyBtn = createButton("FLY (Kameraga Qarab Uchish): OFF", 0, Color3.fromRGB(80, 40, 0), function()
    flying = not flying
    flyBtn.Text = "FLY: " .. (flying and "ON" or "OFF")
    flyBtn.BackgroundColor3 = flying and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(80, 40, 0)
    
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "ForestFlyVector"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = hrp
        
        task.spawn(function()
            while flying and hrp and hrp:FindFirstChild("ForestFlyVector") do
                local camCFrame = Camera.CFrame
                local velocity = Vector3.new(0, 0, 0)
                
                if UIS:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + camCFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - camCFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - camCFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + camCFrame.RightVector end
                
                if velocity.Magnitude > 0 then
                    hrp.ForestFlyVector.Velocity = velocity.Unit * flySpeed
                else
                    hrp.ForestFlyVector.Velocity = Vector3.new(0, 0, 0)
                end
                task.wait()
            end
            if hrp:FindFirstChild("ForestFlyVector") then hrp.ForestFlyVector:Destroy() end
        end)
    else
        if hrp:FindFirstChild("ForestFlyVector") then hrp.ForestFlyVector:Destroy() end
    end
end)

-- 2. CAMPFIRE-GA TELEPORT
createButton("Teleport to Campfire", 50, Color3.fromRGB(200, 100, 0), function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("campfire") or v.Name:lower() == "fire" then
            LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 5, 0)
            break
        end
    end
end)

-- 3. MASOFADAN INSTANT DARAXT CHOPISH (Joyingdan jilmaysan)
createButton("Chop All Trees (Masofadan Instant)", 100, Color3.fromRGB(34, 139, 34), function()
    local count = 0
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name:lower():find("tree") or v.Name:lower():find("daraxt") then
            pcall(function()
                local cd = v:FindFirstChildOfClass("ClickDetector") or v:FindFirstChild([[ClickDetector]], true)
                if cd then
                    fireclickdetector(cd)
                    count = count + 1
                end
                if v:FindFirstChild("Humanoid") then
                    v.Humanoid.Health = 0
                    count = count + 1
                elseif v:FindFirstChild("Health") then
                    v.Health.Value = 0
                    count = count + 1
                end
            end)
        end
    end
    game.StarterGui:SetCore("SendNotification", {
        Title = "O'rmon Hub",
        Text = count .. " ta daraxt uzoqdan chopildi!",
        Duration = 3
    })
end)

-- 4. OLOVGA LOG VA BENZIN SOLISH
createButton("Put Items to Fire (Log/Gas)", 150, Color3.fromRGB(230, 90, 0), function()
    local campfire = workspace:FindFirstChild("Campfire") or workspace:FindFirstChild("Fire")
    if campfire then
        for _, item in pairs(workspace:GetChildren()) do
            if item.Name:lower():find("log") or item.Name:lower():find("gas") or item.Name:lower():find("fuel") or item.Name:lower():find("benzin") then
                local itemPart = item:IsA("Model") and item.PrimaryPart or item
                if itemPart then
                    itemPart.CFrame = campfire:IsA("Model") and campfire:GetModelCFrame() or campfire.CFrame
                end
            end
        end
    end
end)

-- 5. MAYDALAGICHGA SOLISH (Yog'och + Metallar)
createButton("Put Items to Grinder (Wood/Metal)", 200, Color3.fromRGB(70, 70, 80), function()
    local grinder
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("grinder") or v.Name:lower():find("chipper") or v.Name:lower():find("maydalagich") then
            grinder = v
            break
        end
    end
    
    if grinder then
        local grinderCFrame = grinder:IsA("Model") and grinder:GetModelCFrame() or grinder.CFrame
        local count = 0
        for _, item in pairs(workspace:GetChildren()) do
            -- Endi bu yerda Log (o'tin) bilan birga Metal, Iron (temir) va Steel (po'lat) ham qidiriladi
            if item.Name:lower():find("log") or item.Name:lower():find("wood") or item.Name:lower():find("metal") or item.Name:lower():find("iron") or item.Name:lower():find("steel") then
                local itemPart = item:IsA("Model") and item.PrimaryPart or item
                if itemPart then 
                    itemPart.CFrame = grinderCFrame 
                    count = count + 1
                end
            end
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "Maydalagich",
            Text = count .. " ta o'tin va metal maydalagichga solindi!",
            Duration = 3
        })
    end
end)

-- 6. OVQATLARNI GULXANGA TELEPORT QILISH
createButton("Teleport Food to Campfire", 250, Color3.fromRGB(255, 192, 203), function()
    local campfire = workspace:FindFirstChild("Campfire") or workspace:FindFirstChild("Fire")
    if campfire then
        local fireCFrame = campfire:IsA("Model") and campfire:GetModelCFrame() or campfire.CFrame
        for _, item in pairs(workspace:GetChildren()) do
            if item.Name:lower():find("meat") or item.Name:lower():find("food") or item.Name:lower():find("fish") or item.Name:lower():find("raw") then
                local itemPart = item:IsA("Model") and item.PrimaryPart or item
                if itemPart then itemPart.CFrame = fireCFrame end
            end
        end
    end
end)

-- 7. SERVER HOP
createButton("Server Hop", 300, Color3.fromRGB(50, 50, 50), function()
    local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    for _, s in pairs(servers) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TPS:TeleportToPlaceInstance(game.PlaceId, s.id)
        end
    end
end)