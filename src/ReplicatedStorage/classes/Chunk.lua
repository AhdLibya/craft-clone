--[[
	Chunk is Huge Blox of Bloxs 
    Grid is 

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")


local Trove = require(Packages:WaitForChild("Trove"))


-- SETTINGS --------------------------------
local SMOOTHNESS = 20
local TERRAIN_WIDTH = 4
local TERRAIN_HIGHT = 20
local DEFUALT_X , DEFUALT_Z = 10 , 10
local BLOX_SIZE = Vector3.new(TERRAIN_WIDTH,4,TERRAIN_WIDTH)

-- Private --------------------------------
local function CreateBlox( VECTOR : Vector3 ) 
	local Part = Instance.new("Part")
	Part.Anchored = true
	Part.Position = VECTOR
	Part.Size = BLOX_SIZE
	Part.Parent = workspace.Terrain
	return Part
end

local function fitIntoGrid(row , column , position_x , position_z)
	return Vector3.new(
		(position_x*DEFUALT_X*TERRAIN_WIDTH)+row*TERRAIN_WIDTH , -- X

		math.noise((DEFUALT_X/SMOOTHNESS*position_x) + row/SMOOTHNESS , (DEFUALT_Z/SMOOTHNESS*position_z) +column/SMOOTHNESS) * TERRAIN_HIGHT , -- Y

		((position_z*DEFUALT_Z*TERRAIN_WIDTH)+column*TERRAIN_WIDTH) -- Z
    )
end


local Chunk = {}
Chunk.__index = Chunk

-- STATIC PUBLIC PROPERTIES
Chunk.WIDTH_X = DEFUALT_X * TERRAIN_WIDTH
Chunk.WIDTH_Y = DEFUALT_Z * TERRAIN_WIDTH

--PUBLIC METHODS
function Chunk.new( posx , posz  )
	local self = setmetatable({
		_trove = Trove.new();
		x = posx;
		z = posz;
	} , Chunk)
	local Positions = {}
	for row = 0 , DEFUALT_X do
		Positions[row] = {}
		for column = 0 , DEFUALT_Z do
			Positions[row][column] = fitIntoGrid(row , column , posx , posz)
		end
	end
	
	for row = 0 , DEFUALT_X do
		for column = 0 , DEFUALT_Z do
			local VEC = Positions[row][column]
			self._trove:Add(CreateBlox(VEC))
		end
	end
	return self
end

function Chunk:Destroy()
	self._trove:Destroy()
end

return Chunk
