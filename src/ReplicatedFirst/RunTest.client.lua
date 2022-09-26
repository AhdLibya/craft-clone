local RunService = game:GetService('RunService')
local Chunk = require (game:GetService('ReplicatedStorage'):WaitForChild("classes"):WaitForChild("Chunk"))
local Scene = require (game:GetService('ReplicatedStorage'):WaitForChild("classes"):WaitForChild("Scene"))

local RENDER_DISTANCE = 20
local scene = Scene.new(RENDER_DISTANCE)

RunService.RenderStepped:Connect(function()
    scene:render()
end)