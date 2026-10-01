-- == Мир Денди | Boxten GUI (полный, объединённый) ==

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Палитра цветов для ESP
local COLOR_PALETTE = {
    Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 150, 60),
    Color3.fromRGB(255, 230, 60), Color3.fromRGB(120, 230, 90),
    Color3.fromRGB(60, 220, 220), Color3.fromRGB(80, 130, 255),
    Color3.fromRGB(180, 90, 255), Color3.fromRGB(255, 90, 200),
    Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 150, 150),
    Color3.fromRGB(255, 200, 120), Color3.fromRGB(120, 255, 180),
}

-- UI цвета
local C_PANEL  = Color3.fromRGB(75, 75, 75)
local C_BLACK  = Color3.fromRGB(15, 15, 15)
local C_TEXT   = Color3.fromRGB(255, 255, 255)
local C_DIM    = Color3.fromRGB(220, 220, 220)
local C_RED    = Color3.fromRGB(230, 100, 100)
local C_YELLOW = Color3.fromRGB(245, 220, 110)
local C_GREEN  = Color3.fromRGB(150, 210, 120)

-- ESP
local ESP = { Machines = true, Monsters = true, Items = true, Players = true }
local ESP_COLORS = {
    Machines = Color3.fromRGB(255, 60, 60),
    Monsters = Color3.fromRGB(200, 80, 255),
    Items    = Color3.fromRGB(80, 180, 255),
    Players  = Color3.fromRGB(80, 255, 120),
}
local LP = { Noclip = false, Fly = false, FlySpeed = 2 }

local EXACT_MACHINES  = {"BaseMachine"}
local EXACT_ITEMS     = {"Item", "ResearchCapsule"}
local SUFFIX_MONSTERS = {"Monster"}

-- Обводка текста
local function addTextStroke(label, thickness)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 0, 0)
    s.Thickness = thickness or 3
    s.Parent = label
    return s
end

-- Удаляем старые
local old = LocalPlayer.PlayerGui:FindFirstChild("DandyBoxtenGUI")
if old then old:Destroy() end

-- ========== UI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "DandyBoxtenGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 9999
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Кнопка N
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.fromOffset(60, 60)
openBtn.Position = UDim2.new(1, -80, 0, 90)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
openBtn.Text = "N"
openBtn.TextSize = 32
openBtn.TextColor3 = C_TEXT
openBtn.Font = Enum.Font.GothamBlack
openBtn.BorderSizePixel = 0
openBtn.Parent = gui

local oc = Instance.new("UICorner")
oc.CornerRadius = UDim.new(0, 10)
oc.Parent = openBtn

local oStroke = Instance.new("UIStroke")
oStroke.Color = C_BLACK
oStroke.Thickness = 3
oStroke.Parent = openBtn

-- Главное окно
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(490, 320)
main.Position = UDim2.new(0.5, -245, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0, 18)
mc.Parent = main

local grad = Instance.new("UIGradient")
grad.Rotation = 90
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 85, 85)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40)),
})
grad.Parent = main

local mStroke = Instance.new("UIStroke")
mStroke.Color = C_BLACK
mStroke.Thickness = 4
mStroke.Parent = main

-- Крестик
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(50, 38)
closeBtn.Position = UDim2.new(1, -60, 0, 10)
closeBtn.BackgroundColor3 = C_RED
closeBtn.Text = "X"
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.BorderSizePixel = 0
closeBtn.Parent = main

local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0, 10)
cc.Parent = closeBtn

local cStroke = Instance.new("UIStroke")
cStroke.Color = C_BLACK
cStroke.Thickness = 3
cStroke.Parent = closeBtn

addTextStroke(closeBtn, 2)

-- Левая панель
local left = Instance.new("Frame")
left.Size = UDim2.new(0, 190, 1, -30)
left.Position = UDim2.new(0, 15, 0, 15)
left.BackgroundTransparency = 1
left.Parent = main

local ll = Instance.new("UIListLayout")
ll.Padding = UDim.new(0, 8)
ll.Parent = left

-- Правая панель
local right = Instance.new("Frame")
right.Size = UDim2.new(1, -225, 1, -30)
right.Position = UDim2.new(0, 215, 0, 15)
right.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
right.BorderSizePixel = 0
right.Parent = main

local rc = Instance.new("UICorner")
rc.CornerRadius = UDim.new(0, 14)
rc.Parent = right

local rStroke = Instance.new("UIStroke")
rStroke.Color = C_BLACK
rStroke.Thickness = 3
rStroke.Parent = right

-- Поиск
local searchBg = Instance.new("Frame")
searchBg.Size = UDim2.new(1, -16, 0, 35)
searchBg.Position = UDim2.new(0, 8, 0, 8)
searchBg.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
searchBg.BorderSizePixel = 0
searchBg.Parent = right

local sbc = Instance.new("UICorner")
sbc.CornerRadius = UDim.new(0, 10)
sbc.Parent = searchBg

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = C_BLACK
searchStroke.Thickness = 3
searchStroke.Parent = searchBg

local searchLbl = Instance.new("TextLabel")
searchLbl.Size = UDim2.new(1, -16, 1, 0)
searchLbl.Position = UDim2.new(0, 12, 0, 0)
searchLbl.BackgroundTransparency = 1
searchLbl.Text = "Search..."
searchLbl.TextColor3 = C_DIM
searchLbl.TextSize = 15
searchLbl.Font = Enum.Font.GothamBlack
searchLbl.TextXAlignment = Enum.TextXAlignment.Left
searchLbl.Parent = searchBg

addTextStroke(searchLbl, 2)

-- Контент
local cardsFrame = Instance.new("ScrollingFrame")
cardsFrame.Size = UDim2.new(1, -16, 1, -55)
cardsFrame.Position = UDim2.new(0, 8, 0, 50)
cardsFrame.BackgroundTransparency = 1
cardsFrame.BorderSizePixel = 0
cardsFrame.ScrollBarThickness = 6
cardsFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
cardsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
cardsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
cardsFrame.Parent = right

local cl = Instance.new("UIListLayout")
cl.Padding = UDim.new(0, 8)
cl.Parent = cardsFrame

-- Вкладка
local function makeTabButton(text, color)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 40)
    holder.BackgroundColor3 = C_BLACK
    holder.BorderSizePixel = 0
    holder.Parent = left

    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 12)
    hc.Parent = holder

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 1, -6)
    btn.Position = UDim2.new(0, 3, 0, 3)
    btn.BackgroundColor3 = color
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Parent = holder

    local bc2 = Instance.new("UICorner")
    bc2.CornerRadius = UDim.new(0, 10)
    bc2.Parent = btn

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextSize = 20
    lbl.Font = Enum.Font.GothamBlack
    lbl.Parent = btn

    addTextStroke(lbl, 3)

    local shine = Instance.new("Frame")
    shine.Size = UDim2.new(1, -14, 0, 10)
    shine.Position = UDim2.new(0, 7, 0, 4)
    shine.BackgroundColor3 = Color3.new(1, 1, 1)
    shine.BackgroundTransparency = 0.75
    shine.BorderSizePixel = 0
    shine.Parent = btn

    local shc = Instance.new("UICorner")
    shc.CornerRadius = UDim.new(0, 5)
    shc.Parent = shine

    return btn
end

-- Карточка
local function makeCard(name, desc, initial, onChange, colorKey)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -12, 0, 60)
    holder.BackgroundColor3 = C_BLACK
    holder.BorderSizePixel = 0
    holder.Parent = cardsFrame

    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 12)
    hc.Parent = holder

    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, -6, 1, -6)
    card.Position = UDim2.new(0, 3, 0, 3)
    card.BackgroundColor3 = C_PANEL
    card.Text = ""
    card.BorderSizePixel = 0
    card.AutoButtonColor = false
    card.Parent = holder

    local cc2 = Instance.new("UICorner")
    cc2.CornerRadius = UDim.new(0, 10)
    cc2.Parent = card

    local textWidth = colorKey and 110 or 90

    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(1, -textWidth, 0, 20)
    n.Position = UDim2.new(0, 14, 0, 10)
    n.BackgroundTransparency = 1
    n.Text = name
    n.TextColor3 = C_TEXT
    n.TextSize = 14
    n.Font = Enum.Font.GothamBlack
    n.TextXAlignment = Enum.TextXAlignment.Left
    n.Parent = card

    addTextStroke(n, 2)

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -textWidth, 0, 16)
    d.Position = UDim2.new(0, 14, 0, 32)
    d.BackgroundTransparency = 1
    d.Text = desc
    d.TextColor3 = C_DIM
    d.TextSize = 10
    d.Font = Enum.Font.GothamBold
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = card

    addTextStroke(d, 1)

    if colorKey then
        local colorBtn = Instance.new("TextButton")
        colorBtn.Size = UDim2.fromOffset(32, 32)
        colorBtn.Position = UDim2.new(1, -112, 0.5, -16)
        colorBtn.BackgroundColor3 = ESP_COLORS[colorKey]
        colorBtn.Text = ""
        colorBtn.BorderSizePixel = 0
        colorBtn.AutoButtonColor = false
        colorBtn.Parent = card

        local cbc = Instance.new("UICorner")
        cbc.CornerRadius = UDim.new(0.5, 0)
        cbc.Parent = colorBtn

        local cbStroke = Instance.new("UIStroke")
        cbStroke.Color = C_BLACK
        cbStroke.Thickness = 3
        cbStroke.Parent = colorBtn

        colorBtn.MouseButton1Click:Connect(function()
            local existing = card:FindFirstChild("Palette")
            if existing then existing:Destroy() return end

            local palette = Instance.new("Frame")
            palette.Name = "Palette"
            palette.Size = UDim2.fromOffset(190, 140)
            palette.Position = UDim2.new(1, -200, 1, 5)
            palette.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            palette.BorderSizePixel = 0
            palette.ZIndex = 50
            palette.Parent = card

            local pc = Instance.new("UICorner")
            pc.CornerRadius = UDim.new(0, 10)
            pc.Parent = palette

            local ps = Instance.new("UIStroke")
            ps.Color = C_BLACK
            ps.Thickness = 3
            ps.Parent = palette

            local grid = Instance.new("UIGridLayout")
            grid.CellSize = UDim2.fromOffset(35, 35)
            grid.CellPadding = UDim2.fromOffset(8, 8)
            grid.Parent = palette

            local padding = Instance.new("UIPadding")
            padding.PaddingTop = UDim.new(0, 12)
            padding.PaddingLeft = UDim.new(0, 12)
            padding.Parent = palette

            for _, color in ipairs(COLOR_PALETTE) do
                local swatch = Instance.new("TextButton")
                swatch.BackgroundColor3 = color
                swatch.Text = ""
                swatch.BorderSizePixel = 0
                swatch.AutoButtonColor = false
                swatch.ZIndex = 51
                swatch.Parent = palette

                local sc = Instance.new("UICorner")
                sc.CornerRadius = UDim.new(0.5, 0)
                sc.Parent = swatch

                local ss = Instance.new("UIStroke")
                ss.Color = C_BLACK
                ss.Thickness = 2
                ss.Parent = swatch

                swatch.MouseButton1Click:Connect(function()
                    ESP_COLORS[colorKey] = color
                    colorBtn.BackgroundColor3 = color
                    palette:Destroy()
                end)
            end
        end)
    end

    local stateHolder = Instance.new("Frame")
    stateHolder.Size = UDim2.fromOffset(58, 32)
    stateHolder.Position = UDim2.new(1, -70, 0.5, -16)
    stateHolder.BackgroundColor3 = C_BLACK
    stateHolder.BorderSizePixel = 0
    stateHolder.Parent = card

    local shc2 = Instance.new("UICorner")
    shc2.CornerRadius = UDim.new(0, 8)
    shc2.Parent = stateHolder

    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, -6, 1, -6)
    box.Position = UDim2.new(0, 3, 0, 3)
    box.BackgroundColor3 = initial and Color3.fromRGB(80, 200, 100) or Color3.fromRGB(110, 110, 110)
    box.BorderSizePixel = 0
    box.Parent = stateHolder

    local bc3 = Instance.new("UICorner")
    bc3.CornerRadius = UDim.new(0, 6)
    bc3.Parent = box

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = initial and "ВКЛ" or "ВЫКЛ"
    txt.TextColor3 = C_TEXT
    txt.TextSize = 12
    txt.Font = Enum.Font.GothamBlack
    txt.Parent = box

    addTextStroke(txt, 2)

    local state = initial
    card.MouseButton1Click:Connect(function()
        state = not state
        box.BackgroundColor3 = state and Color3.fromRGB(80, 200, 100) or Color3.fromRGB(110, 110, 110)
        txt.Text = state and "ВКЛ" or "ВЫКЛ"
        onChange(state)
    end)
end

-- Ползунок
local function makeSlider(name, desc, minVal, maxVal, initial, onChange)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -12, 0, 90)
    holder.BackgroundColor3 = C_BLACK
    holder.BorderSizePixel = 0
    holder.Parent = cardsFrame

    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 12)
    hc.Parent = holder

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 1, -6)
    card.Position = UDim2.new(0, 3, 0, 3)
    card.BackgroundColor3 = C_PANEL
    card.BorderSizePixel = 0
    card.Parent = holder

    local cc3 = Instance.new("UICorner")
    cc3.CornerRadius = UDim.new(0, 10)
    cc3.Parent = card

    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(1, -90, 0, 20)
    n.Position = UDim2.new(0, 14, 0, 10)
    n.BackgroundTransparency = 1
    n.Text = name
    n.TextColor3 = C_TEXT
    n.TextSize = 14
    n.Font = Enum.Font.GothamBlack
    n.TextXAlignment = Enum.TextXAlignment.Left
    n.Parent = card

    addTextStroke(n, 2)

    local valueLbl = Instance.new("TextLabel")
    valueLbl.Size = UDim2.fromOffset(50, 20)
    valueLbl.Position = UDim2.new(1, -64, 0, 10)
    valueLbl.BackgroundTransparency = 1
    valueLbl.Text = tostring(initial)
    valueLbl.TextColor3 = C_GREEN
    valueLbl.TextSize = 16
    valueLbl.Font = Enum.Font.GothamBlack
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.Parent = card

    addTextStroke(valueLbl, 2)

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -30, 0, 16)
    d.Position = UDim2.new(0, 14, 0, 32)
    d.BackgroundTransparency = 1
    d.Text = desc
    d.TextColor3 = C_DIM
    d.TextSize = 10
    d.Font = Enum.Font.GothamBold
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.Parent = card

    addTextStroke(d, 1)

    local trackHolder = Instance.new("Frame")
    trackHolder.Size = UDim2.new(1, -30, 0, 18)
    trackHolder.Position = UDim2.new(0, 14, 1, -26)
    trackHolder.BackgroundColor3 = C_BLACK
    trackHolder.BorderSizePixel = 0
    trackHolder.Parent = card

    local thc = Instance.new("UICorner")
    thc.CornerRadius = UDim.new(0.5, 0)
    thc.Parent = trackHolder

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -6, 1, -6)
    track.Position = UDim2.new(0, 3, 0, 3)
    track.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    track.BorderSizePixel = 0
    track.Parent = trackHolder

    local tcor = Instance.new("UICorner")
    tcor.CornerRadius = UDim.new(0.5, 0)
    tcor.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((initial - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = C_GREEN
    fill.BorderSizePixel = 0
    fill.Parent = track

    local fcor = Instance.new("UICorner")
    fcor.CornerRadius = UDim.new(0.5, 0)
    fcor.Parent = fill

    local knob = Instance.new("TextButton")
    knob.Size = UDim2.fromOffset(22, 22)
    knob.Position = UDim2.new((initial - minVal) / (maxVal - minVal), -11, 0.5, -11)
    knob.BackgroundColor3 = C_GREEN
    knob.Text = ""
    knob.BorderSizePixel = 0
    knob.AutoButtonColor = false
    knob.Parent = track

    local kcor = Instance.new("UICorner")
    kcor.CornerRadius = UDim.new(0.5, 0)
    kcor.Parent = knob

    local kStroke = Instance.new("UIStroke")
    kStroke.Color = C_BLACK
    kStroke.Thickness = 2
    kStroke.Parent = knob

    local dragging = false

    local function updateFromX(x)
        local rel = (x - track.AbsolutePosition.X) / track.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        local val = math.floor(minVal + rel * (maxVal - minVal) + 0.5)
        if val < minVal then val = minVal end
        if val > maxVal then val = maxVal end
        fill.Size = UDim2.new((val - minVal) / (maxVal - minVal), 0, 1, 0)
        knob.Position = UDim2.new((val - minVal) / (maxVal - minVal), -11, 0.5, -11)
        valueLbl.Text = tostring(val)
        onChange(val)
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch then
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- Заполнение
local function clearCards()
    for _, child in ipairs(cardsFrame:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local function showMain()
    clearCards()
    makeCard("Добро пожаловать!", "Спасибо, что используешь Boxten GUI", false, function() end)
    makeCard("Версия", "1.0 — для Мир Денди", false, function() end)
end

local function showVisuals()
    clearCards()
    makeCard("ESP Машин", "BaseMachine", ESP.Machines, function(v) ESP.Machines = v end, "Machines")
    makeCard("ESP Твистедов", "Все *Monster", ESP.Monsters, function(v) ESP.Monsters = v end, "Monsters")
    makeCard("ESP Предметов", "Item, ResearchCapsule", ESP.Items, function(v) ESP.Items = v end, "Items")
    makeCard("ESP Игроков", "Игроки", ESP.Players, function(v) ESP.Players = v end, "Players")
end

local function showLP()
    clearCards()
    makeCard("Noclip", "Проходить сквозь стены", LP.Noclip, function(v) LP.Noclip = v end)
    makeCard("Fly", "Полёт (тач)", LP.Fly, function(v) LP.Fly = v end)
    makeSlider("Скорость полёта", "От 1 до 5", 1, 5, LP.FlySpeed, function(v) LP.FlySpeed = v end)
end

local tabMain = makeTabButton("Main", C_RED)
tabMain.MouseButton1Click:Connect(showMain)

local tabVis = makeTabButton("Visuals", C_YELLOW)
tabVis.MouseButton1Click:Connect(showVisuals)

local tabLP = makeTabButton("Local Player", C_GREEN)
tabLP.MouseButton1Click:Connect(showLP)

openBtn.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- ========== ESP ЛОГИКА ==========
local highlights = {}

local function setHL(inst, color)
    local hl = highlights[inst]
    if not hl or not hl.Parent then
        hl = Instance.new("Highlight")
        hl.Name = "DandyESP"
        hl.FillTransparency = 0.55
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = inst
        highlights[inst] = hl
    end
    hl.FillColor = color
    hl.OutlineColor = Color3.new(1, 1, 1)
end

local function matchExact(name, list)
    for _, n in ipairs(list) do
        if name == n then return true end
    end
    return false
end

local function matchSuffix(name, list)
    for _, n in ipairs(list) do
        if name:sub(-#n) == n then return true end
    end
    return false
end

local function scanESP()
    local found = {}
    if ESP.Machines then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and matchExact(obj.Name, EXACT_MACHINES) then
                found[obj] = true
                setHL(obj, ESP_COLORS.Machines)
            end
        end
    end
    if ESP.Monsters then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and matchSuffix(obj.Name, SUFFIX_MONSTERS) then
                found[obj] = true
                setHL(obj, ESP_COLORS.Monsters)
            end
        end
    end
    if ESP.Items then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if (obj:IsA("Model") or obj:IsA("BasePart")) and matchExact(obj.Name, EXACT_ITEMS) then
                found[obj] = true
                setHL(obj, ESP_COLORS.Items)
            end
        end
    end
    if ESP.Players then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                found[plr.Character] = true
                setHL(plr.Character, ESP_COLORS.Players)
            end
        end
    end
    for inst, hl in pairs(highlights) do
        if not found[inst] or not inst.Parent then
            if hl and hl.Parent then hl:Destroy() end
            highlights[inst] = nil
        end
    end
end

-- Noclip
local noclipConn = nil
local lastNoclip = false

local function setNoclip(enabled)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if enabled then
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end
end

-- Fly
local flyConn = nil
local flyBodyVel = nil
local flyGyro = nil
local upPressed = false
local downPressed = false

local flyControls = Instance.new("Frame")
flyControls.Size = UDim2.fromOffset(50, 120)
flyControls.Position = UDim2.new(1, -65, 0.5, -60)
flyControls.BackgroundTransparency = 1
flyControls.Visible = false
flyControls.Parent = gui

local flyLayout = Instance.new("UIListLayout")
flyLayout.Padding = UDim.new(0, 6)
flyLayout.Parent = flyControls

local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.fromOffset(50, 50)
upBtn.BackgroundColor3 = Color3.fromRGB(80, 200, 100)
upBtn.Text = "▲"
upBtn.TextSize = 22
upBtn.TextColor3 = Color3.new(1, 1, 1)
upBtn.Font = Enum.Font.GothamBlack
upBtn.BorderSizePixel = 0
upBtn.Parent = flyControls

local upC = Instance.new("UICorner")
upC.CornerRadius = UDim.new(0.5, 0)
upC.Parent = upBtn

local upS = Instance.new("UIStroke")
upS.Color = C_BLACK
upS.Thickness = 3
upS.Parent = upBtn

local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.fromOffset(50, 50)
downBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
downBtn.Text = "▼"
downBtn.TextSize = 22
downBtn.TextColor3 = Color3.new(1, 1, 1)
downBtn.Font = Enum.Font.GothamBlack
downBtn.BorderSizePixel = 0
downBtn.Parent = flyControls

local downC = Instance.new("UICorner")
downC.CornerRadius = UDim.new(0.5, 0)
downC.Parent = downBtn

local downS = Instance.new("UIStroke")
downS.Color = C_BLACK
downS.Thickness = 3
downS.Parent = downBtn

upBtn.MouseButton1Down:Connect(function() upPressed = true end)
upBtn.MouseButton1Up:Connect(function() upPressed = false end)
upBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then upPressed = true end
end)
upBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then upPressed = false end
end)

downBtn.MouseButton1Down:Connect(function() downPressed = true end)
downBtn.MouseButton1Up:Connect(function() downPressed = false end)
downBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then downPressed = true end
end)
downBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then downPressed = false end
end)

local function setFly(enabled)
    if enabled then
        flyControls.Visible = true
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        flyBodyVel = Instance.new("BodyVelocity")
        flyBodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBodyVel.Velocity = Vector3.new(0, 0, 0)
        flyBodyVel.Parent = hrp

        flyGyro = Instance.new("BodyGyro")
        flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyGyro.P = 1000
        flyGyro.D = 50
        flyGyro.CFrame = hrp.CFrame
        flyGyro.Parent = hrp

        local camera = workspace.CurrentCamera
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid.PlatformStand = true end

        flyConn = RunService.RenderStepped:Connect(function()
            if not LocalPlayer.Character then return end
            local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not root then return end

            local dir = Vector3.new(0, 0, 0)
            local humMove = hum and hum.MoveDirection or Vector3.new(0, 0, 0)
            if humMove.Magnitude > 0.01 then
                dir = camera.CFrame.LookVector * humMove.Z + camera.CFrame.RightVector * humMove.X
            end
            if upPressed then dir = dir + Vector3.new(0, 1, 0) end
            if downPressed then dir = dir - Vector3.new(0, 1, 0) end

            local speed = LP.FlySpeed * 50
            flyBodyVel.Velocity = dir * speed
            flyGyro.CFrame = camera.CFrame
        end)
    else
        flyControls.Visible = false
        upPressed = false
        downPressed = false
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if flyBodyVel then flyBodyVel:Destroy() flyBodyVel = nil end
        if flyGyro then flyGyro:Destroy() flyGyro = nil end
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
        end
    end
end

local lastFly = false
local _lastScan = 0

RunService.Heartbeat:Connect(function()
    if LP.Noclip ~= lastNoclip then
        lastNoclip = LP.Noclip
        setNoclip(LP.Noclip)
    end
    if LP.Fly ~= lastFly then
        lastFly = LP.Fly
        setFly(LP.Fly)
    end
    local now = tick()
    if now - _lastScan >= 0.5 then
        _lastScan = now
        scanESP()
    end
end)

showMain()
scanESP()

print("[Boxten GUI] Полная версия загружена.")
