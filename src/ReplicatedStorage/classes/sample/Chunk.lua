
--[[Grid of Bloxs
local x , z = 30 , 30

local grid = {}


for row = 0 , x do
	grid[row] = {}
	
	for colum = 0 , z do
		grid[row][colum] = math.noise(row/5 , colum/5) * 15
	end
	
end

for row = 0 , x do
	for colum = 0 , z do
		local Part = Instance.new('Part')
		Part.Anchored = true
		Part.Position = Vector3.new(row*5 , grid[row][colum] , colum*5)
		Part.Size = Vector3.new(5 , 15 , 5)
		Part.Parent = workspace
	end
end
]]

return {}