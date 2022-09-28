--local RunService = game:GetService('RunService')
local Scene = require (game:GetService('ReplicatedStorage'):WaitForChild("classes"):WaitForChild("Scene"))

local RENDER_DISTANCE = 10
local scene = Scene.new(RENDER_DISTANCE)
local debug do
    local Player = game:GetService('Players').LocalPlayer
    local screen = Instance.new("ScreenGui")
    debug = Instance.new("TextLabel")
    debug.Parent = screen  
    debug.Text = "fps : "
    screen.Parent = Player:WaitForChild("PlayerGui")
    debug.AnchorPoint = Vector2.new(.5 , 1)

    debug.Size = UDim2.fromScale(.3,.3)
    debug.Position = UDim2.fromScale(.5,1)
    debug.TextColor = BrickColor.White()
    debug.TextScaled = true
end

--RunService.RenderStepped:Connect(function()
--    scene:render()
--    debug.Text = "fps : "..math.round(workspace:GetRealPhysicsFPS())
--end)

while true do
    task.spawn(function()
        scene:render()
    end)
    debug.Text = "fps : "..math.round(workspace:GetRealPhysicsFPS())
    task.wait(1)
end