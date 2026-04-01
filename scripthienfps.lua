-- ============================================
-- FLAME TEXT SYSTEM - GIỐNG HIỆU ỨNG TRONG HÌNH
-- ============================================

local FlameTextSystem = {}
FlameTextSystem.__index = FlameTextSystem

-- Cấu hình mặc định
local DEFAULT_CONFIG = {
    TextColor = Color3.fromRGB(255, 150, 0),      -- Màu cam
    StrokeColor = Color3.fromRGB(0, 0, 0),       -- Viền đen
    StrokeThickness = 2,
    StrokeTransparency = 0.2,
    GradientColors = {
        {0, Color3.fromRGB(255, 80, 0)},         -- Đỏ cam (đầu đuôi)
        {0.7, Color3.fromRGB(255, 150, 0)},      -- Cam (giữa)
        {1, Color3.fromRGB(255, 200, 50)}        -- Vàng cam (cuối)
    },
    Font = Enum.Font.GothamBold,
    TextScaled = true,
    Size = UDim2.new(0, 250, 0, 60),
    StudsOffset = Vector3.new(0, 2, 0),
    Duration = 3,                                 -- Thời gian tồn tại (giây)
    FlickerEffect = true,                        -- Hiệu ứng nhấp nháy như lửa
    FlickerSpeed = 0.08
}

-- Tạo mới một đối tượng Flame Text
function FlameTextSystem.new(parent, text, position, customConfig)
    local self = setmetatable({}, FlameTextSystem)
    
    -- Gộp config
    self.config = {}
    for k, v in pairs(DEFAULT_CONFIG) do
        self.config[k] = customConfig and customConfig[k] or v
    end
    
    -- Tạo Part để gắn text
    self.part = Instance.new("Part")
    self.part.Name = "FlameText_" .. text
    self.part.Size = Vector3.new(1, 1, 1)
    self.part.Anchored = true
    self.part.CanCollide = false
    self.part.Transparency = 1
    self.part.Position = position or Vector3.new(0, 5, 0)
    self.part.Parent = parent or workspace
    
    -- Tạo BillboardGui
    self.billboard = Instance.new("BillboardGui")
    self.billboard.Name = "FlameBillboard"
    self.billboard.Size = self.config.Size
    self.billboard.StudsOffset = self.config.StudsOffset
    self.billboard.AlwaysOnTop = true
    self.billboard.Parent = self.part
    
    -- Frame chính
    self.frame = Instance.new("Frame")
    self.frame.Size = UDim2.new(1, 0, 1, 0)
    self.frame.BackgroundTransparency = 1
    self.frame.Parent = self.billboard
    
    -- TextLabel chính
    self.textLabel = Instance.new("TextLabel")
    self.textLabel.Size = UDim2.new(1, 0, 1, 0)
    self.textLabel.BackgroundTransparency = 1
    self.textLabel.Text = tostring(text)
    self.textLabel.TextColor3 = self.config.TextColor
    self.textLabel.TextScaled = self.config.TextScaled
    self.textLabel.Font = self.config.Font
    self.textLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.textLabel.Parent = self.frame
    
    -- Thêm viền (UIStroke) tạo hiệu ứng như trong hình
    local stroke = Instance.new("UIStroke")
    stroke.Color = self.config.StrokeColor
    stroke.Thickness = self.config.StrokeThickness
    stroke.Transparency = self.config.StrokeTransparency
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = self.textLabel
    
    -- Thêm gradient tạo hiệu ứng đuôi lửa
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 0
    local colorSequencePoints = {}
    for _, point in ipairs(self.config.GradientColors) do
        table.insert(colorSequencePoints, ColorSequenceKeypoint.new(point[1], point[2]))
    end
    gradient.Color = ColorSequence.new(colorSequencePoints)
    gradient.Parent = self.textLabel
    
    -- Hiệu ứng nhấp nháy lửa (optional)
    if self.config.FlickerEffect then
        self:startFlickerEffect()
    end
    
    -- Tự động xóa sau thời gian
    if self.config.Duration > 0 then
        game:GetService("Debris"):AddItem(self.part, self.config.Duration)
    end
    
    return self
end

-- Hiệu ứng nhấp nháy như lửa
function FlameTextSystem:startFlickerEffect()
    local tweenService = game:GetService("TweenService")
    local originalColor = self.config.TextColor
    
    local function flicker()
        -- Tạo màu ngẫu nhiên như lửa
        local randomColor = Color3.new(
            1,
            0.4 + math.random() * 0.4,
            0.1 + math.random() * 0.3
        )
        
        local tween = tweenService:Create(
            self.textLabel,
            TweenInfo.new(self.config.FlickerSpeed),
            {TextColor3 = randomColor}
        )
        tween:Play()
        
        tween.Completed:Wait()
        
        tween = tweenService:Create(
            self.textLabel,
            TweenInfo.new(self.config.FlickerSpeed),
            {TextColor3 = originalColor}
        )
        tween:Play()
    end
    
    -- Chạy hiệu ứng liên tục
    coroutine.wrap(function()
        while self.part and self.part.Parent do
            flicker()
            wait(self.config.FlickerSpeed * 2)
        end
    end)()
end

-- Cập nhật text
function FlameTextSystem:setText(newText)
    if self.textLabel then
        self.textLabel.Text = tostring(newText)
    end
end

-- Cập nhật vị trí
function FlameTextSystem:setPosition(newPosition)
    if self.part then
        self.part.Position = newPosition
    end
end

-- Xóa text
function FlameTextSystem:destroy()
    if self.part then
        self.part:Destroy()
    end
end

-- ============================================
-- HÀM TIỆN ÍCH NHANH
-- ============================================

-- Tạo text đơn giản (giống trong hình nhất)
function CreateFlameText(parent, text, position)
    return FlameTextSystem.new(parent, text, position, {
        TextColor = Color3.fromRGB(255, 140, 0),
        StrokeThickness = 2.5,
        Duration = 3,
        FlickerEffect = true,
        GradientColors = {
            {0, Color3.fromRGB(255, 70, 0)},
            {0.6, Color3.fromRGB(255, 140, 0)},
            {1, Color3.fromRGB(255, 180, 60)}
        }
    })
end

-- Tạo text với hiệu ứng kéo dài (kiểu "đuôi lửa" mạnh)
function CreateLongFlameText(parent, text, position)
    return FlameTextSystem.new(parent, text, position, {
        TextColor = Color3.fromRGB(255, 100, 0),
        StrokeThickness = 3,
        Duration = 5,
        FlickerEffect = true,
        FlickerSpeed = 0.05,
        GradientColors = {
            {0, Color3.fromRGB(255, 50, 0)},
            {0.4, Color3.fromRGB(255, 100, 0)},
            {0.8, Color3.fromRGB(255, 150, 30)},
            {1, Color3.fromRGB(255, 200, 80)}
        }
    })
end

-- Tạo text tĩnh không nhấp nháy
function CreateStaticFlameText(parent, text, position)
    return FlameTextSystem.new(parent, text, position, {
        TextColor = Color3.fromRGB(255, 150, 0),
        StrokeThickness = 2,
        Duration = 3,
        FlickerEffect = false,
        GradientColors = {
            {0, Color3.fromRGB(255, 80, 0)},
            {0.7, Color3.fromRGB(255, 150, 0)},
            {1, Color3.fromRGB(255, 200, 50)}
        }
    })
end

-- ============================================
-- VÍ DỤ SỬ DỤNG
-- ============================================

-- Tạo text giống trong hình (số 59771)
local text1 = CreateFlameText(workspace, "59771", Vector3.new(0, 5, 0))

-- Tạo text với nội dung khác
local text2 = CreateLongFlameText(workspace, "Bịện Kéo Ngọt", Vector3.new(0, 8, 0))

-- Tạo text tĩnh (không nhấp nháy)
local text3 = CreateStaticFlameText(workspace, "Safe Zone", Vector3.new(0, 11, 0))

-- Tùy chỉnh hoàn toàn
local customText = FlameTextSystem.new(workspace, "Đơn: N/A", Vector3.new(0, 2, 0), {
    TextColor = Color3.fromRGB(255, 120, 0),
    StrokeColor = Color3.fromRGB(0, 0, 0),
    StrokeThickness = 2,
    Duration = 4,
    FlickerEffect = true,
    GradientColors = {
        {0, Color3.fromRGB(255, 60, 0)},
        {0.5, Color3.fromRGB(255, 120, 0)},
        {1, Color3.fromRGB(255, 170, 40)}
    }
})

-- Cập nhật text sau 2 giây
task.wait(2)
customText:setText("Đã gán nhập phép Hải Quan")
