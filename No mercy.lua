-- NO MERCY ESP V2 - NEVERLOSE STYLE MENU FOR XENO (Extended Height)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer

local espEnabled = true
local teamCheck = true
local boxESP = true
local snaplines = true
local showDistance = true
local showHealthBar = true
local chams = true

local menuVisible = true

-- Drawing storage
local espObjects = {}

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NoMercyESP_UI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Frame.BackgroundTransparency = 0.1
Frame.Position = UDim2.new(0.05, 0, 0.25, 0)
Frame.Size = UDim2.new(0, 320, 0, 380) -- increased height from 280 to 380
Frame.Active = true
Frame.Draggable = true
Frame.Visible = true
Frame.BorderSizePixel = 0
local uicorner = Instance.new("UICorner", Frame)
uicorner.CornerRadius = UDim.new(0, 12)

-- Neon glow effect (using UIStroke)
local stroke = Instance.new("UIStroke", Frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 255, 255)
stroke.Transparency = 0.5
stroke.LineJoinMode = Enum.LineJoinMode.Round

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Asbakk - NO MERCY V2"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.TextStrokeTransparency = 0.7
Title.TextXAlignment = Enum.TextXAlignment.Center

local function createButton(text, ypos)
    local btn = Instance.new("TextButton", Frame)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Size = UDim2.new(0.8, 0, 0, 36)
    btn.Position = UDim2.new(0.1, 0, ypos, 0)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.ClipsDescendants = true

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 8)

    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(0, 255, 255)
    btnStroke.Transparency = 0.7
    btnStroke.LineJoinMode = Enum.LineJoinMode.Round

    -- Hover effect
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        btn.TextColor3 = Color3.fromRGB(18, 18, 18)
        btnStroke.Transparency = 0
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        btn.TextColor3 = Color3.fromRGB(0, 255, 255)
        btnStroke.Transparency = 0.7
    end)

    return btn
end

-- Spacing increased between buttons by using larger step in ypos
local BtnToggleESP = createButton("ESP: ON", 0.12)
local BtnTeamCheck = createButton("Team Check: ON", 0.25)
local BtnBoxESP = createButton("Box ESP: ON", 0.38)
local BtnSnaplines = createButton("Snaplines: ON", 0.51)
local BtnDistance = createButton("Distance: ON", 0.64)
local BtnHealthBar = createButton("Health Bar: ON", 0.77)
local BtnChams = createButton("Chams: ON", 0.90)

-- Toggle Functions

BtnToggleESP.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    BtnToggleESP.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
end)

BtnTeamCheck.MouseButton1Click:Connect(function()
    teamCheck = not teamCheck
    BtnTeamCheck.Text = "Team Check: " .. (teamCheck and "ON" or "OFF")
end)

BtnBoxESP.MouseButton1Click:Connect(function()
    boxESP = not boxESP
    BtnBoxESP.Text = "Box ESP: " .. (boxESP and "ON" or "OFF")
end)

BtnSnaplines.MouseButton1Click:Connect(function()
    snaplines = not snaplines
    BtnSnaplines.Text = "Snaplines: " .. (snaplines and "ON" or "OFF")
end)

BtnDistance.MouseButton1Click:Connect(function()
    showDistance = not showDistance
    BtnDistance.Text = "Distance: " .. (showDistance and "ON" or "OFF")
end)

BtnHealthBar.MouseButton1Click:Connect(function()
    showHealthBar = not showHealthBar
    BtnHealthBar.Text = "Health Bar: " .. (showHealthBar and "ON" or "OFF")
end)

BtnChams.MouseButton1Click:Connect(function()
    chams = not chams
    BtnChams.Text = "Chams: " .. (chams and "ON" or "OFF")
end)

-- Toggle Menu Visibility with Insert / Delete
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        menuVisible = true
        Frame.Visible = true
    elseif input.KeyCode == Enum.KeyCode.insert then
        menuVisible = false
        Frame.Visible = false
    end
end)

-- Utility Functions
local function isTeamMate(player)
    if not teamCheck then return false end
    if player.Team == nil or LocalPlayer.Team == nil then return false end
    return player.Team == LocalPlayer.Team
end

-- Create ESP for player
local function createESP(player)
    if player == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(0, 255, 255)
    box.Thickness = 2
    box.Filled = false
    box.Visible = false

    local snapline = Drawing.new("Line")
    snapline.Color = Color3.fromRGB(0, 255, 255)
    snapline.Thickness = 1
    snapline.Visible = false

    local healthBar = Drawing.new("Line")
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Thickness = 4
    healthBar.Visible = false

    local distanceText = Drawing.new("Text")
    distanceText.Text = ""
    distanceText.Color = Color3.new(1,1,1)
    distanceText.Size = 14
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.Visible = false

    local chamHighlight = Instance.new("Highlight")
    chamHighlight.Adornee = nil
    chamHighlight.FillColor = Color3.fromRGB(0, 255, 255)
    chamHighlight.OutlineColor = Color3.fromRGB(0, 255, 255)
    chamHighlight.FillTransparency = 0.6
    chamHighlight.Enabled = false
    chamHighlight.Parent = game:GetService("CoreGui")

    espObjects[player] = {
        box = box,
        snapline = snapline,
        healthBar = healthBar,
        distance = distanceText,
        cham = chamHighlight
    }

    RunService.RenderStepped:Connect(function()
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not espEnabled or isTeamMate(player) then
            box.Visible = false
            snapline.Visible = false
            healthBar.Visible = false
            distanceText.Visible = false
            chamHighlight.Enabled = false
            return
        end

        local hrp = char.HumanoidRootPart
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

        if onScreen then
            local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
            local scale = math.clamp(1 / dist * 100, 2, 6)
            local size = Vector2.new(35, 70) * scale
            local topLeft = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)

            if boxESP then
                box.Size = size
                box.Position = topLeft
                box.Visible = true
            else
                box.Visible = false
            end

            if snaplines then
                snapline.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                snapline.To = Vector2.new(pos.X, pos.Y)
                snapline.Visible = true
            else
                snapline.Visible = false
            end

            if showHealthBar then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local healthHeight = size.Y * healthPercent
                    healthBar.From = Vector2.new(topLeft.X - 6, topLeft.Y + size.Y)
                    healthBar.To = Vector2.new(topLeft.X - 6, topLeft.Y + size.Y - healthHeight)
                    healthBar.Visible = true
                    healthBar.Color = Color3.fromHSV(healthPercent * 0.33, 1, 1)
                else
                    healthBar.Visible = false
                end
            else
                healthBar.Visible = false
            end

            if showDistance then
                distanceText.Text = "[" .. math.floor(dist) .. "m]"
                distanceText.Position = Vector2.new(pos.X, pos.Y + size.Y / 2 + 14)
                distanceText.Visible = true
            else
                distanceText.Visible = false
            end

            if chams then
                chamHighlight.Adornee = char
                chamHighlight.Enabled = true
            else
                chamHighlight.Enabled = false
            end
        else
            box.Visible = false
            snapline.Visible = false
            healthBar.Visible = false
            distanceText.Visible = false
            chamHighlight.Enabled = false
        end
    end)
end

for _, plr in pairs(Players:GetPlayers()) do
    createESP(plr)
    plr.CharacterAdded:Connect(function()
        wait(1)
        createESP(plr)
    end)
end

Players.PlayerAdded:Connect(function(plr)
    createESP(plr)
    plr.CharacterAdded:Connect(function()
        wait(1)
        createESP(plr)
    end)
end)

print("No Mercy ESP V2 - Neverlose style extended menu loaded!")
