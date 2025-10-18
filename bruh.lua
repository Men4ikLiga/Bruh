-- Kavo UI Library (полная версия)
local Kavo = {}
local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new
local input = game:GetService("UserInputService")
local run = game:GetService("RunService")

local Utility = {}
local Objects = {}

function Kavo:DraggingEnabled(frame, parent)
    parent = parent or frame
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

function Utility:TweenObject(obj, properties, duration, ...)
    tween:Create(obj, tweeninfo(duration, ...), properties):Play()
end

local themes = {
    SchemeColor = Color3.fromRGB(74, 99, 135),
    Background = Color3.fromRGB(36, 37, 43),
    Header = Color3.fromRGB(28, 29, 34),
    TextColor = Color3.fromRGB(255,255,255),
    ElementColor = Color3.fromRGB(32, 32, 38)
}

function Kavo.CreateLib(kavName, themeList)
    if not themeList then themeList = themes end
    
    local selectedTab
    kavName = kavName or "Library"
    
    for i,v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name == kavName then
            v:Destroy()
        end
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local MainCorner = Instance.new("UICorner")
    local MainHeader = Instance.new("Frame")
    local headerCover = Instance.new("UICorner")
    local coverup = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local close = Instance.new("ImageButton")
    local MainSide = Instance.new("Frame")
    local sideCorner = Instance.new("UICorner")
    local coverup_2 = Instance.new("Frame")
    local tabFrames = Instance.new("Frame")
    local tabListing = Instance.new("UIListLayout")
    local pages = Instance.new("Frame")
    local Pages = Instance.new("Folder")
    local infoContainer = Instance.new("Frame")
    local blurFrame = Instance.new("Frame")

    Kavo:DraggingEnabled(MainHeader, Main)

    ScreenGui.Parent = game.CoreGui
    ScreenGui.Name = tostring(math.random(1,100))..tostring(math.random(1,50))..tostring(math.random(1,100))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = themeList.Background
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.336, 0, 0.275, 0)
    Main.Size = UDim2.new(0, 525, 0, 318)

    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = Main

    MainHeader.Name = "MainHeader"
    MainHeader.Parent = Main
    MainHeader.BackgroundColor3 = themeList.Header
    MainHeader.Size = UDim2.new(0, 525, 0, 29)

    headerCover.CornerRadius = UDim.new(0, 4)
    headerCover.Parent = MainHeader

    title.Name = "title"
    title.Parent = MainHeader
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.017, 0, 0.344, 0)
    title.Size = UDim2.new(0, 204, 0, 8)
    title.Font = Enum.Font.Gotham
    title.Text = kavName
    title.TextColor3 = Color3.fromRGB(245, 245, 245)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left

    close.Name = "close"
    close.Parent = MainHeader
    close.BackgroundTransparency = 1
    close.Position = UDim2.new(0.949, 0, 0.137, 0)
    close.Size = UDim2.new(0, 21, 0, 21)
    close.Image = "rbxassetid://3926305904"
    close.ImageRectOffset = Vector2.new(284, 4)
    close.ImageRectSize = Vector2.new(24, 24)
    close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    MainSide.Name = "MainSide"
    MainSide.Parent = Main
    MainSide.BackgroundColor3 = themeList.Header
    MainSide.Position = UDim2.new(0, 0, 0.091, 0)
    MainSide.Size = UDim2.new(0, 149, 0, 289)

    tabFrames.Name = "tabFrames"
    tabFrames.Parent = MainSide
    tabFrames.BackgroundTransparency = 1
    tabFrames.Position = UDim2.new(0.043, 0, 0, 0)
    tabFrames.Size = UDim2.new(0, 135, 0, 283)

    tabListing.Name = "tabListing"
    tabListing.Parent = tabFrames
    tabListing.SortOrder = Enum.SortOrder.LayoutOrder

    pages.Name = "pages"
    pages.Parent = Main
    pages.BackgroundTransparency = 1
    pages.Position = UDim2.new(0.299, 0, 0.122, 0)
    pages.Size = UDim2.new(0, 360, 0, 269)

    Pages.Name = "Pages"
    Pages.Parent = pages

    local Tabs = {}
    local first = true

    function Tabs:NewTab(tabName)
        tabName = tabName or "Tab"
        local tabButton = Instance.new("TextButton")
        local UICorner = Instance.new("UICorner")
        local page = Instance.new("ScrollingFrame")
        local pageListing = Instance.new("UIListLayout")

        page.Name = "Page"
        page.Parent = Pages
        page.BackgroundColor3 = themeList.Background
        page.BorderSizePixel = 0
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 5
        page.Visible = false
        page.ScrollBarImageColor3 = themeList.SchemeColor

        pageListing.Name = "pageListing"
        pageListing.Parent = page
        pageListing.SortOrder = Enum.SortOrder.LayoutOrder
        pageListing.Padding = UDim.new(0, 5)

        tabButton.Name = tabName.."TabButton"
        tabButton.Parent = tabFrames
        tabButton.BackgroundColor3 = themeList.SchemeColor
        tabButton.Size = UDim2.new(0, 135, 0, 28)
        tabButton.AutoButtonColor = false
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tabName
        tabButton.TextColor3 = themeList.TextColor
        tabButton.TextSize = 14
        tabButton.BackgroundTransparency = 1

        if first then
            first = false
            page.Visible = true
            tabButton.BackgroundTransparency = 0
        else
            page.Visible = false
            tabButton.BackgroundTransparency = 1
        end

        UICorner.CornerRadius = UDim.new(0, 5)
        UICorner.Parent = tabButton

        tabButton.MouseButton1Click:Connect(function()
            for i,v in next, Pages:GetChildren() do v.Visible = false end
            page.Visible = true
            for i,v in next, tabFrames:GetChildren() do
                if v:IsA("TextButton") then
                    Utility:TweenObject(v, {BackgroundTransparency = 1}, 0.2)
                end
            end
            Utility:TweenObject(tabButton, {BackgroundTransparency = 0}, 0.2)
        end)

        local Sections = {}

        function Sections:NewSection(secName)
            secName = secName or "Section"
            local sectionFunctions = {}
            local sectionFrame = Instance.new("Frame")
            local sectionlistoknvm = Instance.new("UIListLayout")
            local sectionHead = Instance.new("Frame")
            local sHeadCorner = Instance.new("UICorner")
            local sectionName = Instance.new("TextLabel")
            local sectionInners = Instance.new("Frame")
            local sectionElListing = Instance.new("UIListLayout")

            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = page
            sectionFrame.BackgroundColor3 = themeList.Background
            sectionFrame.BorderSizePixel = 0
            
            sectionlistoknvm.Name = "sectionlistoknvm"
            sectionlistoknvm.Parent = sectionFrame
            sectionlistoknvm.SortOrder = Enum.SortOrder.LayoutOrder
            sectionlistoknvm.Padding = UDim.new(0, 5)

            sectionHead.Name = "sectionHead"
            sectionHead.Parent = sectionFrame
            sectionHead.BackgroundColor3 = themeList.SchemeColor
            sectionHead.Size = UDim2.new(0, 352, 0, 33)

            sHeadCorner.CornerRadius = UDim.new(0, 4)
            sHeadCorner.Parent = sectionHead

            sectionName.Name = "sectionName"
            sectionName.Parent = sectionHead
            sectionName.BackgroundTransparency = 1
            sectionName.Size = UDim2.new(1, 0, 1, 0)
            sectionName.Font = Enum.Font.Gotham
            sectionName.Text = secName
            sectionName.TextColor3 = themeList.TextColor
            sectionName.TextSize = 14
            sectionName.TextXAlignment = Enum.TextXAlignment.Left

            sectionInners.Name = "sectionInners"
            sectionInners.Parent = sectionFrame
            sectionInners.BackgroundTransparency = 1
            sectionInners.Position = UDim2.new(0, 0, 0.190, 0)

            sectionElListing.Name = "sectionElListing"
            sectionElListing.Parent = sectionInners
            sectionElListing.SortOrder = Enum.SortOrder.LayoutOrder
            sectionElListing.Padding = UDim.new(0, 3)

            local Elements = {}

            function Elements:NewButton(bname, callback)
                bname = bname or "Click Me!"
                callback = callback or function() end

                local buttonElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local btnInfo = Instance.new("TextLabel")

                buttonElement.Name = bname
                buttonElement.Parent = sectionInners
                buttonElement.BackgroundColor3 = themeList.ElementColor
                buttonElement.ClipsDescendants = true
                buttonElement.Size = UDim2.new(0, 352, 0, 33)
                buttonElement.AutoButtonColor = false
                buttonElement.Font = Enum.Font.SourceSans
                buttonElement.Text = ""
                buttonElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                buttonElement.TextSize = 14

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = buttonElement

                btnInfo.Name = "btnInfo"
                btnInfo.Parent = buttonElement
                btnInfo.BackgroundTransparency = 1
                btnInfo.Position = UDim2.new(0.096, 0, 0.272, 0)
                btnInfo.Size = UDim2.new(0, 314, 0, 14)
                btnInfo.Font = Enum.Font.GothamSemibold
                btnInfo.Text = bname
                btnInfo.TextColor3 = themeList.TextColor
                btnInfo.TextSize = 14
                btnInfo.TextXAlignment = Enum.TextXAlignment.Left

                buttonElement.MouseButton1Click:Connect(function()
                    callback()
                end)

                return {}
            end

            function Elements:NewToggle(tname, callback)
                local TogFunction = {}
                tname = tname or "Toggle"
                callback = callback or function() end
                local toggled = false

                local toggleElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local togName = Instance.new("TextLabel")

                toggleElement.Name = "toggleElement"
                toggleElement.Parent = sectionInners
                toggleElement.BackgroundColor3 = themeList.ElementColor
                toggleElement.ClipsDescendants = true
                toggleElement.Size = UDim2.new(0, 352, 0, 33)
                toggleElement.AutoButtonColor = false
                toggleElement.Font = Enum.Font.SourceSans
                toggleElement.Text = ""
                toggleElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                toggleElement.TextSize = 14

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = toggleElement

                togName.Name = "togName"
                togName.Parent = toggleElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.096, 0, 0.272, 0)
                togName.Size = UDim2.new(0, 288, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = tname
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                toggleElement.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    pcall(callback, toggled)
                end)

                function TogFunction:UpdateToggle(newText, isTogOn)
                    if newText ~= nil then togName.Text = newText end
                    toggled = isTogOn or toggled
                    pcall(callback, toggled)
                end

                return TogFunction
            end

            function Elements:NewDropdown(dropname, list, callback)
                local DropFunction = {}
                dropname = dropname or "Dropdown"
                list = list or {}
                callback = callback or function() end

                local dropFrame = Instance.new("Frame")
                local dropOpen = Instance.new("TextButton")
                local itemTextbox = Instance.new("TextLabel")
                local UICorner = Instance.new("UICorner")
                local UIListLayout = Instance.new("UIListLayout")

                dropFrame.Name = "dropFrame"
                dropFrame.Parent = sectionInners
                dropFrame.BackgroundColor3 = themeList.Background
                dropFrame.BorderSizePixel = 0
                dropFrame.Size = UDim2.new(0, 352, 0, 33)
                dropFrame.ClipsDescendants = true

                dropOpen.Name = "dropOpen"
                dropOpen.Parent = dropFrame
                dropOpen.BackgroundColor3 = themeList.ElementColor
                dropOpen.Size = UDim2.new(0, 352, 0, 33)
                dropOpen.AutoButtonColor = false
                dropOpen.Font = Enum.Font.SourceSans
                dropOpen.Text = ""
                dropOpen.TextColor3 = Color3.fromRGB(0, 0, 0)
                dropOpen.TextSize = 14

                itemTextbox.Name = "itemTextbox"
                itemTextbox.Parent = dropOpen
                itemTextbox.BackgroundTransparency = 1
                itemTextbox.Position = UDim2.new(0.097, 0, 0.273, 0)
                itemTextbox.Size = UDim2.new(0, 138, 0, 14)
                itemTextbox.Font = Enum.Font.GothamSemibold
                itemTextbox.Text = dropname
                itemTextbox.TextColor3 = themeList.TextColor
                itemTextbox.TextSize = 14
                itemTextbox.TextXAlignment = Enum.TextXAlignment.Left

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = dropOpen

                UIListLayout.Parent = dropFrame
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 3)

                for i,v in next, list do
                    local optionSelect = Instance.new("TextButton")
                    local UICorner_2 = Instance.new("UICorner")

                    optionSelect.Name = "optionSelect"
                    optionSelect.Parent = dropFrame
                    optionSelect.BackgroundColor3 = themeList.ElementColor
                    optionSelect.Size = UDim2.new(0, 352, 0, 33)
                    optionSelect.AutoButtonColor = false
                    optionSelect.Font = Enum.Font.GothamSemibold
                    optionSelect.Text = "  "..v
                    optionSelect.TextColor3 = themeList.TextColor
                    optionSelect.TextSize = 14
                    optionSelect.TextXAlignment = Enum.TextXAlignment.Left

                    UICorner_2.CornerRadius = UDim.new(0, 4)
                    UICorner_2.Parent = optionSelect

                    optionSelect.MouseButton1Click:Connect(function()
                        callback(v)
                        itemTextbox.Text = v
                        dropFrame.Size = UDim2.new(0, 352, 0, 33)
                    end)
                end

                return DropFunction
            end

            function Elements:NewKeybind(keytext, first, callback)
                keytext = keytext or "KeybindText"
                callback = callback or function() end
                local oldKey = first.Name

                local keybindElement = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")
                local togName = Instance.new("TextLabel")
                local togName_2 = Instance.new("TextLabel")

                keybindElement.Name = "keybindElement"
                keybindElement.Parent = sectionInners
                keybindElement.BackgroundColor3 = themeList.ElementColor
                keybindElement.ClipsDescendants = true
                keybindElement.Size = UDim2.new(0, 352, 0, 33)
                keybindElement.AutoButtonColor = false
                keybindElement.Font = Enum.Font.SourceSans
                keybindElement.Text = ""
                keybindElement.TextColor3 = Color3.fromRGB(0, 0, 0)
                keybindElement.TextSize = 14

                keybindElement.MouseButton1Click:Connect(function()
                    togName_2.Text = ". . ."
                    local a, b = game:GetService('UserInputService').InputBegan:wait()
                    if a.KeyCode.Name ~= "Unknown" then
                        togName_2.Text = a.KeyCode.Name
                        oldKey = a.KeyCode.Name
                    end
                end)

                game:GetService("UserInputService").InputBegan:Connect(function(current, ok)
                    if not ok and current.KeyCode.Name == oldKey then
                        callback()
                    end
                end)

                UICorner.CornerRadius = UDim.new(0, 4)
                UICorner.Parent = keybindElement

                togName.Name = "togName"
                togName.Parent = keybindElement
                togName.BackgroundTransparency = 1
                togName.Position = UDim2.new(0.096, 0, 0.272, 0)
                togName.Size = UDim2.new(0, 222, 0, 14)
                togName.Font = Enum.Font.GothamSemibold
                togName.Text = keytext
                togName.TextColor3 = themeList.TextColor
                togName.TextSize = 14
                togName.TextXAlignment = Enum.TextXAlignment.Left

                togName_2.Name = "togName"
                togName_2.Parent = keybindElement
                togName_2.BackgroundTransparency = 1
                togName_2.Position = UDim2.new(0.727, 0, 0.272, 0)
                togName_2.Size = UDim2.new(0, 70, 0, 14)
                togName_2.Font = Enum.Font.GothamSemibold
                togName_2.Text = oldKey
                togName_2.TextColor3 = themeList.SchemeColor
                togName_2.TextSize = 14
                togName_2.TextXAlignment = Enum.TextXAlignment.Right

                return {}
            end

            return Elements
        end

        return Sections
    end

    return Tabs
end

return Kavo
end

-- Основной скрипт SCP Roleplay
local library = Kavo.CreateLib("Novaz#5792", "BloodTheme")
local main = window:NewTab("Main")
local main3 = window:NewTab("Auto Farm")
local main1 = window:NewTab("Teleports")
local main4 = window:NewTab("Combat")
local main2 = window:NewTab("Misc")
local section = main:NewSection("Main")
local section1 = main1:NewSection("Area TP")
local section2 = main1:NewSection("SCP TP")
local section3 = main1:NewSection("Spawn TP")
local section4 = main2:NewSection("LocalPlayer")
local section5 = main3:NewSection("Auto Farm")
local section6 = main4:NewSection("Combat")
local section7 = main4:NewSection("ESP")

local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local camera = game.Workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local userInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Переменные для функций
local aimbotEnabled = false
local autoShoot = true
local aimSpeed = 1
local aimPart = "Голова"

-- Функции
local function GetClosestPlayer()
   local target = nil
   local distance = math.huge
   for i,v in next, game.Players:GetPlayers() do
       if v and v ~= plr and v.Character and v.Character:FindFirstChildOfClass('Humanoid') and v.Character:FindFirstChildOfClass('Humanoid').RootPart and v.Team ~= plr.Team then
           local plrdist = plr:DistanceFromCharacter(v.Character:FindFirstChildOfClass('Humanoid').RootPart.CFrame.p)
           if plrdist < distance then
               target = v
               distance = plrdist
           end
       end
   end
   return target
end

local function ClosestPlayerToMouse()
    local target = nil
    local dist = math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Name ~= plr.Name then
            if v.Team ~= plr.Team 
                and v.Character
                and v.Character:FindFirstChild("Humanoid")
                and v.Character.Humanoid.Health ~= 0
                and v.Character:FindFirstChild("HumanoidRootPart")
            then
                local screenpoint = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local check = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenpoint.X, screenpoint.Y)).magnitude
                if check < dist then
                    target = v
                    dist = check
                end
            end
        end
    end
    return target
end

-- Умный Aimbot функция
local function GetClosestEnemy()
    local target = nil
    local distance = math.huge
    local localPlayer = game.Players.LocalPlayer
    local localTeam = localPlayer.Team
    
    for _, v in next, game.Players:GetPlayers() do
        if v and v ~= localPlayer and v.Character and v.Character:FindFirstChild("Humanoid") 
        and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("Head") then
            
            local isEnemy = false
            local playerTeam = v.Team
            
            if localTeam and playerTeam then
                if (localTeam.Name == "Chaos Insurgency" or localTeam.Name == "Class - D") then
                    isEnemy = (playerTeam.Name ~= "Chaos Insurgency" and playerTeam.Name ~= "Class - D")
                else
                    isEnemy = (playerTeam.Name == "Chaos Insurgency" or playerTeam.Name == "Class - D")
                end
            end
            
            if isEnemy then
                local character = localPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local dist = (character.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude
                    if dist < distance then
                        local screenPoint = workspace.CurrentCamera:WorldToViewportPoint(v.Character.Head.Position)
                        if screenPoint.Z > 0 then
                            target = v
                            distance = dist
                        end
                    end
                end
            end
        end
    end
    return target
end

local function AutoShoot(target)
    if target and target.Character and target.Character:FindFirstChild("Head") and autoShoot then
        local args = {
            [1] = {
                [1] = target.Character.Head.Position.X,
                [2] = target.Character.Head.Position.Y,
                [3] = target.Character.Head.Position.Z
            },
            [2] = target.Character.Head
        }
        game:GetService("ReplicatedStorage").Remotes.ShootRemote:FireServer(unpack(args))
    end
end

-- Таблицы
local spawns = {} 
for i,v in ipairs(game.Workspace.Spawns:GetChildren()) do 
    if not table.find(spawns, v.Name) then 
        table.insert(spawns, v.Name)
    end 
end

local playerss = {} 
for i,v in ipairs(game.Players:GetChildren()) do 
    if not table.find(playerss, v.Name) then 
        table.insert(playerss, v.Name)
    end 
end

-- Основной интерфейс
section:NewButton("TP To Nuke Bunker (Hidden)", "", function()
    pcall(function()
        plr.Character.HumanoidRootPart.CFrame = CFrame.new(233, 15, 511)
    end)
end)

section:NewButton("Breach 008", "", function()
    pcall(function()
        plr.Character.HumanoidRootPart.CFrame = CFrame.new(233, 17, 511)
        wait(1)
        fireproximityprompt(game:GetService("Workspace")["Sector 3"].ModelCI008["Meshes/Chaos Insurgency Hack Device_Cylinder"].CIHackDevicePrompt)
    end)
end)

-- Teleports
section1:NewDropdown("Select Area", "", {"Sector 1", "Sector 2-1", "Sector 2-2", "Sector 3", "Bunker", "Control Room", "Transformer", "Class D Containment", "Class D Viewing", "Heli Pad", "Shooting Range"}, function(c)
    d = c 
end)

section1:NewButton("Tp To Selected Area", "", function()
    pcall(function()
        if d == "Sector 3" then 
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(491, 42, 150)
        elseif d == "Bunker" then 
            plr.Character.HumanoidRootPart.CFrame = CFrame.new(228, 42, 438)
        -- ... остальные локации
        end
    end)
end)

-- Combat с улучшенным aimbot
section6:NewToggle("Умный Aimbot", "Автоматически наводится на врагов при зажатой клавише", function(state)
    aimbotEnabled = state
end)

section6:NewKeybind("Клавиша Aimbot", "Зажмите для активации aimbot", Enum.KeyCode.Q, function() end)

section6:NewToggle("Авто-стрельба", "Автоматически стреляет при наведении", function(state)
    autoShoot = state
end)

section6:NewSlider("Скорость наведения", "Скорость прицеливания", 100, 1, function(value)
    aimSpeed = value / 100
end)

section6:NewDropdown("Часть тела", "Выберите часть тела для прицеливания", {"Голова", "Торс", "Ноги"}, function(part)
    aimPart = part
end)

-- Основной цикл aimbot
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and userInput:IsKeyDown(Enum.KeyCode.Q) then
        local target = GetClosestEnemy()
        if target then
            local headPos = target.Character.Head.Position
            local camera = workspace.CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.Position, headPos)
            AutoShoot(target)
        end
    end
end)

-- Анти AFK 
for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
    v:Disable()
end

print("SCP Roleplay Script loaded successfully!")
