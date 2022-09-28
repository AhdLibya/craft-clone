
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")


local Trove = require(Packages:WaitForChild("Trove"))
local Chunk = require (script.Parent:WaitForChild("Chunk"))

local CAMERA = workspace.CurrentCamera
--local UPDATE_PER_TICK = tick()
--local FREQANCE_UPDATE = 1 -- UPDATE FREQANCE
local FREQANCE_CREATE = 2 -- CREATE FREQANCE


local centerx 
local centery 
local chunks = {}
local counter = 0



local function puse()
    counter  = (counter + 1) % FREQANCE_CREATE
    if counter == 0 then
        task.wait(.20)
    end
end

local function chunkExistAtXZ(x , z)
    for _ , chunk in ipairs(chunks) do
        if chunk.x == x and chunk.z == z then 
            return true
        end
    end
    return false
end

local function gnerate(scene)
    for row = centerx - scene._range , centerx + scene._range do
        for column = centery - scene._range , centery + scene._range do
            if chunkExistAtXZ(row, column) then continue end
            puse()
            table.insert(chunks , Chunk.new(row, column) )
        end
    end
end

local function isChunkOutOfRang(rang , chunk)
    if  (math.abs(chunk.x - centerx) > rang) or (math.abs(chunk.z - centery) > rang ) then
        return true
    end
    return false
end

local function updateCenter(scene)
    local cameraPostion = CAMERA.CFrame.Position
    centerx = math.round(cameraPostion.X / Chunk.WIDTH_X)
	centery = math.round(cameraPostion.Z / Chunk.WIDTH_Y)
	gnerate(scene)
end

local function clear(scene)
    for index = 1 , #chunks do
        local chunk = chunks[index]
        if not chunk then continue end
        if isChunkOutOfRang(scene._range, chunk) then
            print("Destroying chunk "..index)
            chunk:Destroy()
            table.remove(chunks,index)
        end
    end
end

local Scene = {}
Scene.__index = Scene


function Scene.new(rang)
    local self = setmetatable({
        _range = rang,
        _trove = Trove.new()
    }, Scene)

    return self
end

function Scene:render()
	task.spawn(clear , self)
	task.spawn(updateCenter , self)
end

function Scene:Destroy()
    self._trove:Destroy()
end


return Scene
