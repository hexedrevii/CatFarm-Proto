ingame = {
	data = nil
}

-- We declare all data here
-- Since it means it resets every time.
function ingame:init()
	self.data = {
		cam = {
			x = 0,
			speed = 1,

			bounds = {
				left = 0,
				right = 10
			}
		},

		plots = {},
	}

	-- loop through the entire map.
	for x = 0, 128 do
		for y = 0, 64 do
			-- plot
			if mget(x, y) == 54 then
				add(self.data.plots, plot.new(x, y))
			end
		end
	end
end

function ingame:update()
	local data = self.data

	-- camera movement
	local cam = data.cam
	if btn(➡️) then
		if (cam.x >= cam.bounds.right) then
			return
		end

		cam.x += cam.speed
	elseif btn(⬅️) then
		if (cam.x <= cam.bounds.left) then
			return
		end

		cam.x -= cam.speed
	end

	for plot in all(self.data.plots) do
		local col = {
			x = (plot.x - cam.x) * 8, y = plot.y * 8,
			w = 8, h = 8
		}

		-- The mouse is hovering the plot
		if pr(col, mouse.x, mouse.y) then
			-- TODO: Everything
		end
	end
end

function ingame:draw()
	cls(12)
	map(self.data.cam.x, 0)
end