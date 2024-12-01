-- Rainbow Menu with Infinity Jump Script

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local InfinityJumpCheckbox = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local DraggableArea = Instance.new("Frame")

-- GUI Setup
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 100)

UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 10)

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Rainbow Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

InfinityJumpCheckbox.Name = "InfinityJumpCheckbox"
InfinityJumpCheckbox.Parent = MainFrame
InfinityJumpCheckbox.Position = UDim2.new(0.1, 0, 0.4, 0)
InfinityJumpCheckbox.Size = UDim2.new(0.8, 0, 0, 30)
InfinityJumpCheckbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
InfinityJumpCheckbox.Font = Enum.Font.Gotham
InfinityJumpCheckbox.Text = "Infinity Jump: OFF"
InfinityJumpCheckbox.TextColor3 = Color3.fromRGB(255, 255, 255)
InfinityJumpCheckbox.TextSize = 14
InfinityJumpCheckbox.AutoButtonColor = false

DraggableArea.Name = "DraggableArea"
DraggableArea.Parent = MainFrame
DraggableArea.BackgroundTransparency = 1
DraggableArea.Size = UDim2.new(1, 0, 0, 30)

-- Rainbow Effect
local function updateRainbow()
    local tick = tick()
    local hue = tick % 5 / 5
    local color = Color3.fromHSV(hue, 1, 1)
    Title.TextColor3 = color
end

-- Dragging Functionality
local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

DraggableArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Infinity Jump
local infinityJumpEnabled = false
local function onJumpRequest()
    if infinityJumpEnabled then
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end

InfinityJumpCheckbox.MouseButton1Click:Connect(function()
    infinityJumpEnabled = not infinityJumpEnabled
    InfinityJumpCheckbox.Text = "Infinity Jump: " .. (infinityJumpEnabled and "ON" or "OFF")
    InfinityJumpCheckbox.BackgroundColor3 = infinityJumpEnabled and 
        Color3.fromRGB(60, 179, 113) or Color3.fromRGB(40, 40, 40)
end)

game:GetService("UserInputService").JumpRequest:Connect(onJumpRequest)

-- Rainbow Update Loop
game:GetService("RunService").RenderStepped:Connect(updateRainbow)

-- Anti-Destroy Protection
ScreenGui.Parent = game:GetService("CoreGui")

