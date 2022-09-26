--[[
	Chunk is Huge Blox of Bloxs 
    Grid is 

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")


local Trove = require(Packages:WaitForChild("Trove"))



local HIGHT = 20
local WEDHT = 5
local DEFUALT_X , DEFUALT_Y = 25 , 25


local function CreateBlox(VEC  , SIZE)
	local Part = Instance.new("Part")
	Part.Anchored = true
	Part.Position = VEC
	Part.Size = SIZE
	Part.Parent = workspace.Terrain
	return Part
end

local Chunk = {}
Chunk.__index = Chunk

function Chunk.new(posx , posy  )
	local self = setmetatable({
		_trove = Trove.new();
		_posx = posx;
		_posy = posy;
	} , Chunk)
	local Positions = {}
	
	for row = 0 , DEFUALT_X do
		Positions[row] = {}
		for colum = 0 , DEFUALT_Y do
			
			Positions[row][colum] = Vector3.new(
				(posx*DEFUALT_X*WEDHT)+row*WEDHT , -- X

			    math.noise((DEFUALT_X/HIGHT*posx) + row/HIGHT , (DEFUALT_Y/HIGHT*posy) +colum/HIGHT) * 25 , -- Y

			    ((posy*DEFUALT_Y*WEDHT)+colum*WEDHT) -- Z
		)
		end
	end
	
	for row = 0 , DEFUALT_X do
		for colum = 0 , DEFUALT_Y do
			local VEC = Positions[row][colum]
			self._trove:Add(CreateBlox(VEC , Vector3.new(WEDHT,5,WEDHT)))
		end
	end
	return self
end

function Chunk:Destroy()
	self._trove:Destroy()
end

return Chunk
