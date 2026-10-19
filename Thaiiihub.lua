-- THAIIIFMYT HUB
-- Created by THAIIIFMYT
-- Roblox Studio - LocalScript

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "THAIIIFMYT_HUB"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 390)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(110, 40, 220)
title.Text = "THAIIIFMYT HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(text, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = UDim2.new(0.05, 0, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.Parent = frame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button

    button.Activated:Connect(callback)
    return button
end

local function createBox(placeholder, y)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.9, 0, 0, 32)
    box.Position = UDim2.new(0.05, 0, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextSize = 14
    box.ClearTextOnFocus = false
    box.Parent = frame
    return box
end

-- Speed
local speedBox = createBox("Speed: 50 - 200", 50)

createButton("SET SPEED", 88, function()
    local character = Player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local speed = tonumber(speedBox.Text)

    if humanoid and speed then
        humanoid.WalkSpeed = math.clamp(speed, 0, 200)
    end
end)

-- Infinite Jump
local infiniteJump = false

local jumpButton = createButton("Infinite Jump: OFF", 130, function()
    infiniteJump = not infiniteJump
    jumpButton.Text = "Infinite Jump: " ..
        (infiniteJump and "ON" or "OFF")
end)

UIS.JumpRequest:Connect(function()
    if infiniteJump then
        local character = Player.Character
        local humanoid = character and
            character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end
end)

-- Fly
local flying = false
local flySpeed = 50
local flyConnection

local flyButton = createButton("Fly: OFF", 172, function()
    flying = not flying
    flyButton.Text = "Fly: " .. (flying and "ON" or "OFF")

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if flying then
        flyConnection = RunService.RenderStepped:Connect(function()
            local character = Player.Character
            local root = character and
                character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and
                character:FindFirstChildOfClass("Humanoid")

            if not root or not humanoid then return end

            local camera = workspace.CurrentCamera
            local direction = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then
                direction += camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                direction -= camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                direction -= camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                direction += camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                direction += Vector3.yAxis
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction -= Vector3.yAxis
            end

            root.AssemblyLinearVelocity =
                direction.Magnitude > 0
                and direction.Unit * flySpeed
                or Vector3.zero
        end)
    end
end)

-- Anti-AFK
local antiAFK = false
local VirtualInputManager =
    game:GetService("VirtualInputManager")

local afkConnection

local afkButton = createButton("Anti-AFK: OFF", 214, function()
    antiAFK = not antiAFK
    afkButton.Text = "Anti-AFK: " ..
        (antiAFK and "ON" or "OFF")

    if afkConnection then
        afkConnection:Disconnect()
        afkConnection = nil
    end

    if antiAFK then
        local elapsed = 0

        afkConnection = RunService.Heartbeat:Connect(function(dt)
            elapsed += dt

            if elapsed >= 60 then
                elapsed = 0

                local character = Player.Character
                local humanoid = character and
                    character:FindFirstChildOfClass("Humanoid")

                if humanoid then
                    humanoid.Jump = true
                end
            end
        end)
    end
end)

-- Waypoint
local waypointBox = createBox("Waypoint: X, Y, Z", 260)

createButton("GO TO WAYPOINT", 300, function()
    local x, y, z = waypointBox.Text:match(
        "^%s*([%-%.%d]+)%s*,%s*([%-%.%d]+)%s*,%s*([%-%.%d]+)%s*$"
    )

    x, y, z = tonumber(x), tonumber(y), tonumber(z)

    if x and y and z then
        local character = Player.Character
        local root = character and
            character:FindFirstChild("HumanoidRootPart")

        if root then
            root.CFrame = CFrame.new(x, y, z)
        end
    end
end)

-- Hide / Show GUI
createButton("HIDE GUI", 342, function()
    frame.Visible = false
end)

local reopen = Instance.new("TextButton")
reopen.Size = UDim2.new(0, 120, 0, 40)
reopen.Position = UDim2.new(0, 10, 0.5, 0)
reopen.Text = "OPEN THAIIIFMYT"
reopen.TextSize = 12
reopen.BackgroundColor3 = Color3.fromRGB(110, 40, 220)
reopen.TextColor3 = Color3.new(1, 1, 1)
reopen.Parent = gui

reopen.Activated:Connect(function()
    frame.Visible = true
end)

print("THAIIIFMYT HUB loaded!")