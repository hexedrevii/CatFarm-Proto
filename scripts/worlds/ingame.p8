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
		}
	}
end

function ingame:update()
	local data = self.data

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
end

function ingame:draw()
	cls(12)
	map(self.data.cam.x, 0)

	-- camera(self.data.cam_x, 0)
end