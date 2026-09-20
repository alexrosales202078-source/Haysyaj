local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Actualizar referencia del Humanoid si el personaje reaparece
player.CharacterAdded:Connect(function(newChar)
	character = newChar
	humanoid = character:WaitForChild("Humanoid")
end)

-- 1. Crear Interfaz Gráfica (UI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedControllerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 90)
mainFrame.Position = UDim2.new(0.5, -150, 0.8, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Velocidad: 100"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- 2. Barra de Velocidad (Slider)
local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.85, 0, 0, 10)
sliderBar.Position = UDim2.new(0.075, 0, 0.55, 0)
sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBar.BorderSizePixel = 0
sliderBar.Parent = mainFrame

local sliderBarCorner = Instance.new("UICorner")
sliderBarCorner.CornerRadius = UDim.new(1, 0)
sliderBarCorner.Parent = sliderBar

local sliderButton = Instance.new("ImageButton")
sliderButton.Size = UDim2.new(0, 20, 0, 20)
sliderButton.AnchorPoint = Vector2.new(0.5, 0.5)
sliderButton.Position = UDim2.new(0, 0, 0.5, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderBar

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = sliderButton

-- 3. Lógica del Slider (Límites: 100 a 1000)
local minSpeed = 100
local maxSpeed = 1000
local isDragging = false

local function updateSpeed(input)
	local barAbsolutePosition = sliderBar.AbsolutePosition.X
	local barAbsoluteSize = sliderBar.AbsoluteSize.X
	
	-- Calcular porcentaje relativo al mouse dentro de la barra
	local relativeX = math.clamp(input.Position.X - barAbsolutePosition, 0, barAbsoluteSize)
	local alpha = relativeX / barAbsoluteSize
	
	-- Mover la perilla
	sliderButton.Position = UDim2.new(alpha, 0, 0.5, 0)
	
	-- Calcular nueva velocidad
	local currentSpeed = math.floor(minSpeed + (alpha * (maxSpeed - minSpeed)))
	
	-- Aplicar al personaje
	if humanoid then
		humanoid.WalkSpeed = currentSpeed
	end
	
	titleLabel.Text = "Velocidad: " .. currentSpeed
end

-- Eventos de arrastre
sliderButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateSpeed(input)
	end
end)

-- Establecer velocidad inicial predeterminada (100)
if humanoid then
	humanoid.WalkSpeed = minSpeed
end
