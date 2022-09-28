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
local TERRAIN_HIGHT = 80
local DEFUALT_X , DEFUALT_Z = 10 , 10
local BLOX_SIZE = Vector3.new(TERRAIN_WIDTH,10,TERRAIN_WIDTH)

local HIGHT_COLORS = {
	[-50] = Color3.fromRGB(253, 251, 99);
	[0] = Color3.fromRGB(75, 248, 98);
	[50] = Color3.fromRGB(119, 122, 104);
}

local HIGHT_MATERIAL = {
	[-50] = Enum.Material.Sand;
	[0] = Enum.Material.Grass;
	[50] = Enum.Material.Rock;
}


-- Private --------------------------------
local function CreateBlox( VECTOR : Vector3 ) 
	local Part = Instance.new("Part")
	Part.Anchored = true
	Part.Position = VECTOR
	Part.Size = BLOX_SIZE
	Part.Parent = workspace.Terrain
	return Part
end


local function applyMaterial(hight)
	return HIGHT_MATERIAL[hight]
end

local function applyColor(blox : BasePart)
	local _hight = blox.Position.Y -- Blox Y position or the blox hight

	local color  -- The Real Color we want to apply
	local lower  
	local higher
	local Material

	-- color hight is the index of the color in the colors array and _color is the real color in the colors array
	for colorhight , _color in pairs(HIGHT_COLORS) do
		if _hight == colorhight then
			color = _color
			Material = applyMaterial(_hight)
			break
		end
		if _hight < colorhight and (not higher or colorhight < higher) then
			higher = colorhight 
		end
		if _hight > colorhight and (not lower or colorhight > lower) then
			lower = colorhight 
		end

	end

	if not color then
		if not higher then
			color = HIGHT_COLORS[lower]
			Material = applyMaterial(lower)
		elseif not lower then
			color = HIGHT_COLORS[higher]
			Material = applyMaterial(higher)
		else
			local bitColor = (_hight - lower) / (higher - lower)
			local lowerColor = HIGHT_COLORS[lower]
			local HightColor = HIGHT_COLORS[higher]
			color = lowerColor:Lerp(HightColor , bitColor)
			Material = applyMaterial(0)
		end
	end
	blox.Material = Material
	blox.Color = color
end

local function addWater(chunk)
	local cfr = CFrame.new(  (chunk.x+.5)*chunk.WIDTH_X , -50 , (chunk.z+.5)*chunk.WIDTH_Y )
	local size = Vector3.new(chunk.WIDTH_X  , 90 , chunk.WIDTH_Y )

	chunk._trove:Add(function()
		workspace.Terrain:FillBlock(cfr , size , "Air")
	end)

	workspace.Terrain:FillBlock(cfr , size , "Water")
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
			local blox = self._trove:Add(CreateBlox(VEC))
			applyColor(blox)
		end
	end
	addWater(self)
	return self
end

function Chunk:Destroy()
	self._trove:Destroy()
end

return Chunk
