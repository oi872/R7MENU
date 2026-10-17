-- R7 MENU | Interface visual & Funcionalidades Completas (PC & Mobile)
-- LocalScript em StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "R7Menu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local purple = Color3.fromRGB(130, 85, 255)
local dark = Color3.fromRGB(17, 17, 25)
local panel = Color3.fromRGB(28, 28, 40)
local white = Color3.fromRGB(240, 240, 255)

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

-- // CÍRCULO DO FOV \\ --
local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = gui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = purple
fovStroke.Thickness = 1.5
fovStroke.Parent = fovCircle

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircle

-- // JANELA PRINCIPAL \\ --
local main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(370, 325),
    Position = UDim2.new(0.5, -185, 0.5, -162),
    BackgroundColor3 = dark,
    BorderSizePixel = 0
}, gui)

create("UICorner", { CornerRadius = UDim.new(0, 12) }, main)
create("UIStroke", { Color = purple, Thickness = 1.5 }, main)

-- Cabeçalho
local header = create("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = panel,
    BorderSizePixel = 0
}, main)

create("UICorner", { CornerRadius = UDim.new(0, 12) }, header)

create("TextLabel", {
    Position = UDim2.fromOffset(13, 0),
    Size = UDim2.new(1, -65, 1, 0),
    BackgroundTransparency = 1,
    Text = "✦  R7 MENU",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local minimized = false
local collapse = create("TextButton", {
    Name = "Collapse",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -9, 0.5, 0),
    Size = UDim2.fromOffset(30, 29),
    BackgroundColor3 = purple,
    Text = "−",
    TextColor3 = white,
    Font = Enum.Font.GothamBold,
    TextSize = 21,
    BorderSizePixel = 0
}, header)

create("UICorner", { CornerRadius = UDim.new(0, 7) }, collapse)

-- Arrastar no PC e Mobile
local dragging, dragStart, startPosition
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

-- Corpo
local body = create("Frame", {
    Name = "Body",
    Position = UDim2.fromOffset(9, 55),
    Size = UDim2.new(1, -18, 1, -64),
    BackgroundTransparency = 1
}, main)

local tabs = create("Frame", {
    Size = UDim2.new(1, 0, 0, 37),
    BackgroundTransparency = 1
}, body)

local function makeTab(name, position)
    local button = create("TextButton", {
        Position = UDim2.new(position, 0, 0, 0),
        Size = UDim2.new(0.5, -4, 1, 0),
        BackgroundColor3 = panel,
        Text = name,
        TextColor3 = white,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0
    }, tabs)
    create("UICorner", { CornerRadius = UDim.new(0, 7) }, button)
    return button
end

local combatTab = makeTab("⚔  Combat", 0)
local visualTab = makeTab("◈  Visuais", 0.5)

local content = create("ScrollingFrame", {
    Position = UDim2.fromOffset(0, 45),
    Size = UDim2.new(1, 0, 1, -45),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = purple,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new(0, 0, 0, 0)
}, body)

create("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, content)
create("UIPadding", { PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 4) }, content)

local function clearOptions()
    for _, child in ipairs(content:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- Variáveis de Estado
local Toggles = {
    Aimbot = false,
    WallWalk = false,
    ThroughWalls = false,
    Skeleton = false,
    Box = false,
    Line = false,
    Name = false, -- Opção Nome adicionada
}
local fovRadius = 100

local function updateFOVShape()
    fovCircle.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
end
updateFOVShape()

local function makeToggle(name, stateKey)
    local row = create("Frame", {
        Size = UDim2.new(1, -2, 0, 43),
        BackgroundColor3 = panel,
        BorderSizePixel = 0
    }, content)

    create("UICorner", { CornerRadius = UDim.new(0, 7) }, row)

    create("TextLabel", {
        Position = UDim2.fromOffset(11, 0),
        Size = UDim2.new(1, -95, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = white,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local active = Toggles[stateKey] or false

    local button = create("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0.5, 0),
        Size = UDim2.fromOffset(60, 27),
        BackgroundColor3 = active and Color3.fromRGB(40, 155, 100) or Color3.fromRGB(65, 65, 80),
        Text = active and "ON" or "OFF",
        TextColor3 = white,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        BorderSizePixel = 0
    }, row)

    create("UICorner", { CornerRadius = UDim.new(0, 6) }, button)

    button.Activated:Connect(function()
        active = not active
        Toggles[stateKey] = active
        button.Text = active and "ON" or "OFF"
        button.BackgroundColor3 = active and Color3.fromRGB(40, 155, 100) or Color3.fromRGB(65, 65, 80)

        if stateKey == "Aimbot" then
            fovCircle.Visible = active
        end
    end)
end

local function makeFOV()
    local row = create("Frame", {
        Size = UDim2.new(1, -2, 0, 65),
        BackgroundColor3 = panel,
        BorderSizePixel = 0
    }, content)

    create("UICorner", { CornerRadius = UDim.new(0, 7) }, row)

    local label = create("TextLabel", {
        Position = UDim2.fromOffset(11, 4),
        Size = UDim2.new(1, -20, 0, 23),
        BackgroundTransparency = 1,
        Text = "FOV     " .. math.floor(fovRadius) .. " / 300",
        TextColor3 = white,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local bar = create("TextButton", {
        Position = UDim2.new(0, 11, 0, 40),
        Size = UDim2.new(1, -22, 0, 7),
        BackgroundColor3 = Color3.fromRGB(60, 60, 77),
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0
    }, row)

    create("UICorner", { CornerRadius = UDim.new(1, 0) }, bar)

    local fill = create("Frame", {
        Size = UDim2.new(fovRadius / 300, 0, 1, 0),
        BackgroundColor3 = purple,
        BorderSizePixel = 0
    }, bar)

    create("UICorner", { CornerRadius = UDim.new(1, 0) }, fill)

    local function update(x)
        local p = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        fovRadius = math.floor(p * 300 + 0.5)
        fill.Size = UDim2.new(p, 0, 1, 0)
        label.Text = "FOV     " .. fovRadius .. " / 300"
        updateFOVShape()
    end

    local moving = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            moving = true
            update(input.Position.X)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if moving and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            moving = false
        end
    end)
end

local function showCombat()
    clearOptions()
    makeToggle("Ativar aimbot", "Aimbot")
    makeFOV()
    makeToggle("Grudar parede", "WallWalk")
    makeToggle("Matar atrás parede", "ThroughWalls")
end

local function showVisuals()
    clearOptions()
    makeToggle("Esqueleto", "Skeleton")
    makeToggle("Caixa", "Box")
    makeToggle("Linha", "Line")
    makeToggle("Nome", "Name") -- Opção adicionada na aba Visuais
end

combatTab.Activated:Connect(function()
    combatTab.BackgroundColor3 = purple
    visualTab.BackgroundColor3 = panel
    showCombat()
end)

visualTab.Activated:Connect(function()
    visualTab.BackgroundColor3 = purple
    combatTab.BackgroundColor3 = panel
    showVisuals()
end)

collapse.Activated:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(230, 48) or UDim2.fromOffset(370, 325)
    collapse.Text = minimized and "+" or "−"
end)

combatTab.BackgroundColor3 = purple
showCombat()

-- // SISTEMA DE ESP (BOX, LINE, SKELETON, NAME) \\ --
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ESP_Container"

local function createESPObj(targetPlayer)
    local espData = {
        Player = targetPlayer,
        Box = Instance.new("Frame"),
        BoxStroke = Instance.new("UIStroke"),
        Line = Instance.new("Frame"),
        NameLabel = Instance.new("TextLabel"),
        Highlight = Instance.new("Highlight")
    }

    -- Box ESP
    espData.Box.BackgroundTransparency = 1
    espData.Box.Visible = false
    espData.Box.Parent = espFolder
    espData.BoxStroke.Color = purple
    espData.BoxStroke.Thickness = 1.5
    espData.BoxStroke.Parent = espData.Box

    -- Line ESP
    espData.Line.AnchorPoint = Vector2.new(0.5, 0.5)
    espData.Line.BackgroundColor3 = purple
    espData.Line.BorderSizePixel = 0
    espData.Line.Visible = false
    espData.Line.Parent = espFolder

    -- Name ESP
    espData.NameLabel.BackgroundTransparency = 1
    espData.NameLabel.Size = UDim2.fromOffset(200, 20)
    espData.NameLabel.AnchorPoint = Vector2.new(0.5, 1)
    espData.NameLabel.Text = targetPlayer.Name
    espData.NameLabel.TextColor3 = white
    espData.NameLabel.Font = Enum.Font.GothamBold
    espData.NameLabel.TextSize = 12
    espData.NameLabel.TextStrokeTransparency = 0.3
    espData.NameLabel.Visible = false
    espData.NameLabel.Parent = espFolder

    -- Skeleton ESP
    espData.Highlight.FillTransparency = 0.8
    espData.Highlight.FillColor = purple
    espData.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    espData.Highlight.OutlineTransparency = 0
    espData.Highlight.Enabled = false

    return espData
end

local espObjects = {}

for _, enemy in ipairs(Players:GetPlayers()) do
    if enemy ~= player then
        espObjects[enemy] = createESPObj(enemy)
    end
end

Players.PlayerAdded:Connect(function(enemy)
    if enemy ~= player then
        espObjects[enemy] = createESPObj(enemy)
    end
end)

Players.PlayerRemoving:Connect(function(enemy)
    if espObjects[enemy] then
        espObjects[enemy].Box:Destroy()
        espObjects[enemy].Line:Destroy()
        espObjects[enemy].NameLabel:Destroy()
        if espObjects[enemy].Highlight then espObjects[enemy].Highlight:Destroy() end
        espObjects[enemy] = nil
    end
end)

-- // FUNÇÕES AUXILIARES DE CENTRO E AIMBOT \\ --
local function getCenterScreen()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local function getClosestHeadInFOV()
    local centerScreen = getCenterScreen()
    local closestHead = nil
    local shortestDistance = fovRadius

    for _, enemy in ipairs(Players:GetPlayers()) do
        if enemy ~= player and enemy.Character then
            local head = enemy.Character:FindFirstChild("Head")
            local humanoid = enemy.Character:FindFirstChildOfClass("Humanoid")

            if head and humanoid and humanoid.Health > 0 then
                local screenPosition, onScreen = Camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local headScreenPos = Vector2.new(screenPosition.X, screenPosition.Y)
                    local distanceToCenter = (headScreenPos - centerScreen).Magnitude

                    if distanceToCenter < shortestDistance then
                        shortestDistance = distanceToCenter
                        closestHead = head
                    end
                end
            end
        end
    end

    return closestHead
end

-- // LOOP PRINCIPAL DE ATUALIZAÇÃO (RenderStepped) \\ --
RunService.RenderStepped:Connect(function()
    local center = getCenterScreen()
    fovCircle.Position = UDim2.fromOffset(center.X, center.Y)

    local char = player.Character

    -- 1. Matar / Passar através da parede
    if char and Toggles.ThroughWalls then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- 2. Wall Walk
    if char and char:FindFirstChild("HumanoidRootPart") and Toggles.WallWalk then
        local root = char.HumanoidRootPart
        local ray = Ray.new(root.Position, root.CFrame.LookVector * 5)
        local hitPart, hitPos, hitNormal = workspace:FindPartOnRay(ray, char)
        if hitPart then
            root.Velocity = Vector3.new(0, 0, 0)
            root.CFrame = CFrame.new(root.Position, root.Position + hitNormal)
        end
    end

    -- 3. Aimbot
    if Toggles.Aimbot then
        local targetHead = getClosestHeadInFOV()
        if targetHead then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        end
    end

    -- 4. RENDERIZAÇÃO DO ESP (Caixa, Linha, Esqueleto e Nome)
    for enemy, esp in pairs(espObjects) do
        if enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") and enemy.Character:FindFirstChildOfClass("Humanoid") and enemy.Character.Humanoid.Health > 0 then
            local root = enemy.Character.HumanoidRootPart
            local head = enemy.Character:FindFirstChild("Head") or root

            local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

            if onScreen then
                -- CAIXA (BOX ESP)
                if Toggles.Box then
                    local boxHeight = math.abs(headPos.Y - legPos.Y)
                    local boxWidth = boxHeight * 0.65

                    esp.Box.Size = UDim2.fromOffset(boxWidth, boxHeight)
                    esp.Box.Position = UDim2.fromOffset(rootPos.X - boxWidth / 2, rootPos.Y - boxHeight / 2)
                    esp.Box.Visible = true
                else
                    esp.Box.Visible = false
                end

                -- LINHA (LINE ESP)
                if Toggles.Line then
                    local startPos = Vector2.new(center.X, Camera.ViewportSize.Y)
                    local targetPos = Vector2.new(rootPos.X, rootPos.Y)
                    local distance = (targetPos - startPos).Magnitude
                    local angle = math.deg(math.atan2(targetPos.Y - startPos.Y, targetPos.X - startPos.X))

                    esp.Line.Size = UDim2.fromOffset(distance, 1.5)
                    esp.Line.Position = UDim2.fromOffset((startPos.X + targetPos.X) / 2, (startPos.Y + targetPos.Y) / 2)
                    esp.Line.Rotation = angle
                    esp.Line.Visible = true
                else
                    esp.Line.Visible = false
                end

                -- NOME (NAME ESP)
                if Toggles.Name then
                    esp.NameLabel.Position = UDim2.fromOffset(headPos.X, headPos.Y - 5)
                    esp.NameLabel.Visible = true
                else
                    esp.NameLabel.Visible = false
                end

                -- ESQUELETO (SKELETON / HIGHLIGHT ESP)
                if Toggles.Skeleton then
                    esp.Highlight.Parent = enemy.Character
                    esp.Highlight.Enabled = true
                else
                    esp.Highlight.Enabled = false
                end
            else
                esp.Box.Visible = false
                esp.Line.Visible = false
                esp.NameLabel.Visible = false
                esp.Highlight.Enabled = false
            end
        else
            esp.Box.Visible = false
            esp.Line.Visible = false
            esp.NameLabel.Visible = false
            esp.Highlight.Enabled = false
        end
    end
end)
