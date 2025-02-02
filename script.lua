-- Define a whitelist of authorized user IDs
local WHITELIST = {
    [5823510656] = true, -- Replace with actual UserId
    [4330372222] = true, -- Add more UserIds as needed
  	[5339167257] = true,
  	[5709462086] = true,
	  [5709455970] = true,
    [3821179738] = true,
    [4330372222] = true,
    [3527309294] = true,
}

-- Get the local player
local Players = cloneref(game:GetService("Players"))
local Client = Players.LocalPlayer

-- Check if the player's UserId is in the whitelist
if not WHITELIST[Client.UserId] then
    warn("Unauthorized user: " .. Client.UserId)
    return -- Stop the script if the user is not authorized
end

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local RapidFireButton = Instance.new("TextButton")

-- Configure the ScreenGui
ScreenGui.Parent = Client:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Configure the Frame
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.BackgroundTransparency = 0.1
Frame.ZIndex = 2
Frame.ClipsDescendants = true

-- Add rounded corners to the Frame
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

-- Configure the Title
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "WiZzx"
Title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true
Title.BackgroundTransparency = 0.1

-- Add rounded corners to the Title
local TitleUICorner = Instance.new("UICorner")
TitleUICorner.CornerRadius = UDim.new(0, 10)
TitleUICorner.Parent = Title

-- Configure the ToggleButton
ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(0.9, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.05, 0, 0.35, 0)
ToggleButton.Text = "Hitbox Expander"
ToggleButton.BackgroundColor3 = Color3.new(0.2, 0.7, 0.2)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.ZIndex = 2

-- Add rounded corners to the ToggleButton
local ButtonUICorner = Instance.new("UICorner")
ButtonUICorner.CornerRadius = UDim.new(0, 8)
ButtonUICorner.Parent = ToggleButton

-- Configure the RapidFireButton
RapidFireButton.Parent = Frame
RapidFireButton.Size = UDim2.new(0.9, 0, 0, 40)
RapidFireButton.Position = UDim2.new(0.05, 0, 0.65, 0)
RapidFireButton.Text = "Rapid Fire OFF"
RapidFireButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.7)
RapidFireButton.TextScaled = true
RapidFireButton.Font = Enum.Font.SourceSansBold
RapidFireButton.TextColor3 = Color3.new(1, 1, 1)
RapidFireButton.ZIndex = 2

-- Add rounded corners to the RapidFireButton
local RapidFireButtonUICorner = Instance.new("UICorner")
RapidFireButtonUICorner.CornerRadius = UDim.new(0, 8)
RapidFireButtonUICorner.Parent = RapidFireButton

-- Variables for toggling the script
local size = 20
local scriptEnabled = false
local RS = cloneref(game:GetService("RunService"))
local connection
local originalSizes = {}

-- Function to toggle the hitbox expander script
local function toggleScript()
    scriptEnabled = not scriptEnabled
    if scriptEnabled then
        ToggleButton.Text = "Hitbox ON"
        ToggleButton.BackgroundColor3 = Color3.new(0.7, 0.2, 0.2)
        connection = RS.RenderStepped:Connect(function()
            for _, Player in pairs(Players:GetPlayers()) do
                if Player == Client then continue end
                local HRP = Player.Character:FindFirstChild("HumanoidRootPart")
                if HRP then
                    if not originalSizes[Player] then
                        originalSizes[Player] = HRP.Size
                    end
                    HRP.Size = Vector3.new(size, size, size)
                    HRP.CanCollide = false
                    HRP.Transparency = 0.9
                end
            end
        end)
    else
        ToggleButton.Text = "Hitbox OFF"
        ToggleButton.BackgroundColor3 = Color3.new(0.2, 0.7, 0.2)
        if connection then
            connection:Disconnect()
            connection = nil
        end
        for _, Player in pairs(Players:GetPlayers()) do
            if originalSizes[Player] then
                local HRP = Player.Character:FindFirstChild("HumanoidRootPart")
                if HRP then
                    HRP.Size = originalSizes[Player]
                    HRP.CanCollide = true
                    HRP.Transparency = 0
                end
            end
        end
        originalSizes = {}
    end
end

-- Connect the button to the toggle function
ToggleButton.MouseButton1Click:Connect(toggleScript)

-- Rapid Fire Functionality
local utility = {}
getgenv().config = { enable = false, delay = 0.01 }

utility.getgun = function()
    for _, tool in next, game.Players.LocalPlayer.Character:GetChildren() do
        if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then return tool end
    end
end

utility.rapid = function(tool)
    tool:Activate()
end

getgenv().is_firing = false

local function toggleRapidFire()
    getgenv().config.enable = not getgenv().config.enable

    if getgenv().config.enable then
        RapidFireButton.Text = "Rapid Fire ON"
        RapidFireButton.BackgroundColor3 = Color3.new(0.7, 0.2, 0.2)
    else
        RapidFireButton.Text = "Rapid Fire OFF"
        RapidFireButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.7)
    end
end

RapidFireButton.MouseButton1Click:Connect(toggleRapidFire)

game:GetService("UserInputService").InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local gun = utility.getgun()
        if getgenv().config.enable and gun and not getgenv().is_firing then
            getgenv().is_firing = true
            while getgenv().is_firing do
                utility.rapid(gun)
                task.wait(getgenv().config.delay)
            end
        end
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        getgenv().is_firing = false
    end
end)
