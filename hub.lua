local UIS = game:GetService("UserInputService")
local TPS = game:GetService("TeleportService")
local Http = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI Yaratish
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MainList = Instance.new("ScrollingFrame")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "Bunyodbek_Escape_Keyboard_Hub"
ScreenGui.ResetOnSpawn = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.Position = UDim2.new(0.3, 0, 0.1, 0)
Frame.Size = UDim2.new(0, 340, 0, 560)
Frame.Active = true
Frame.Draggable = true
Frame.BorderSizePixel = 3
Frame.BorderColor3 = Color3.fromRGB(0, 170, 255)

Title.Parent = Frame
Title.Text = "ESCAPE KEYBOARD HUB | K: Hide"
Title.Size = UDim2.new(1, 0, 0.08, 0)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

-- X Tugmasi (Scriptni butunlay yopish va o'chirish)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Frame
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy() -- Script UI-ni o'yindan butunlay o'chiradi
end)

-- K Tugmasi (Menyuni yoqish va yashirish)
UIS.InputBegan:Connect(function(input, proc)
    if not proc and input.KeyCode == Enum.KeyCode.K then
        if ScreenGui and ScreenGui.Parent then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
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

-- --- ESCAPE KEYBOARD FUNKSIYALARI ---

-- 1. WORLD 2 AUTO WIN (Oxiriga teleport va yutish)
createButton("World 2: Auto Win", 0, Color3.fromRGB(0, 120, 215), function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local winPart = nil
    for _, v in pairs(workspace:GetDescendants()) do
        local name = v.Name:lower()
        if name:find("win") or name:find("finish") or name:find("end") then
            if v.Parent and (v.Parent.Name:lower():find("world2") or v.Parent.Name:lower():find("world 2") or v.Parent.Name:lower():find("stage")) then
                winPart = v
                break
            end
        end
    end
    
    if not winPart then
        winPart = workspace:FindFirstChild("World2") or workspace:FindFirstChild("World 2")
    end
    
    if winPart then
        local targetCFrame = winPart:IsA("Model") and winPart:GetModelCFrame() or winPart.CFrame
        char.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 4, 0)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Escape Keyboard",
            Text = "2-Dunyo oxiriga teleport bo'ldingiz!",
            Duration = 3
        })
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Xatolik",
            Text = "World 2 marra nuqtasi topilmadi!",
            Duration = 3
        })
    end
end)

-- 2. BLACK SECRET KEY OLISH
createButton("Collect Black Secret Key", 50, Color3.fromRGB(40, 40, 40), function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local found = false
    for _, v in pairs(workspace:GetDescendants()) do
        local name = v.Name:lower()
        if name:find("black") and (name:find("key") or name:find("secret")) then
            local part = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or (v:IsA("BasePart") and v or nil)
            if part then
                char.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 2, 0)
                found = true
                local prompt = v:FindFirstChildOfClass("ProximityPrompt", true)
                if prompt then fireproximityprompt(prompt) end
                break
            end
        end
    end
    
    if found then
        game.StarterGui:SetCore("SendNotification", {Title = "Kalit Tizimi", Text = "Black Secret Key olindi!", Duration = 3})
    else
        game.StarterGui:SetCore("SendNotification", {Title = "Xatolik", Text = "Black Secret Key topilmadi!", Duration = 3})
    end
end)

-- 3. GOLDEN SPECIAL KEY OLISH
createButton("Collect Golden Special Key", 100, Color3.fromRGB(218, 165, 32), function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local found = false
    for _, v in pairs(workspace:GetDescendants()) do
        local name = v.Name:lower()
        if (name:find("gold") or name:find("golden")) and (name:find("key") or name:find("special")) then
            local part = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or (v:IsA("BasePart") and v or nil)
            if part then
                char.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 2, 0)
                found = true
                local prompt = v:FindFirstChildOfClass("ProximityPrompt", true)
                if prompt then fireproximityprompt(prompt) end
                break
            end
        end
    end
    
    if found then
        game.StarterGui:SetCore("SendNotification", {Title = "Kalit Tizimi", Text = "Golden Special Key olindi!", Duration = 3})
    else
        game.StarterGui:SetCore("SendNotification", {Title = "Xatolik", Text = "Golden Special Key topilmadi!", Duration = 3})
    end
end)

-- 4. BARCHA KALITLARNI YIG'ISH
createButton("Collect All Keys", 150, Color3.fromRGB(138, 43, 226), function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local count = 0
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("key") then
            local part = v:IsA("Model") and (v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")) or (v:IsA("BasePart") and v or nil)
            if part then
                char.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 2, 0)
                local prompt = v:FindFirstChildOfClass("ProximityPrompt", true)
                if prompt then fireproximityprompt(prompt) end
                count = count + 1
                task.wait(0.3)
            end
        end
    end
    game.StarterGui:SetCore("SendNotification", {Title = "Kalit Tizimi", Text = count .. " ta kalit yig'ildi!", Duration = 3})
end)

-- 5. SERVER HOP
createButton("Server Hop", 200, Color3.fromRGB(50, 50, 50), function()
    local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data
    for _, s in pairs(servers) do
        if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TPS:TeleportToPlaceInstance(game.PlaceId, s.id)
        end
    end
end)