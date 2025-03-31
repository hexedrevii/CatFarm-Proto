ingame = {
	data = nil
}

-- We declare all data here
-- Since it means it resets every time.
function ingame:init()
	self.data = {
		coins = 0,

		xp = 0,
		nxp = 10,
		level = 1,

		gap = 2,
		inc = 0.15,

		cam = {
			x = 0,
			speed = 1,

			bounds = {
				left = 0,
				right = 13
			}
		},

		pressed = false,

		plots = {},

		inv_id = 1,
		inv = {},
	}

	add(self.data.inv, item.new(plants[1].name, 10, 1))
	add(self.data.inv, item.new(plants[2].name, 5, 2))

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

function ingame:handle_xp()
	self.data.xp -= self.data.nxp
	self.data.level += 1

	self.data.nxp = flr((self.data.level / self.data.inc)^self.data.gap)
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

	if btnp(⬆️) then
		data.inv_id = (data.inv_id - 2) % #data.inv + 1
	elseif btnp(⬇️) then
		data.inv_id = data.inv_id % #data.inv + 1
	end

	for plot in all(data.plots) do
		plot:update(cam.x)

		local col = {
			x = (plot.x - cam.x) * 8, y = plot.y * 8,
			w = 8, h = 8
		}

		-- the mouse is hovering the plot
		if pr(col, mouse.x, mouse.y) and not self.data.pressed then
			-- mouse click
			if mouse.held then
				-- if any other plot is active bail
				local proceed = true
				for p in all(data.plots) do
					-- skip if the plot is itself
					if p.x == plot.x and p.y == plot.y then
						goto continue
					end

					if p.active then
						proceed = false
						break
					end

					::continue::
				end

				if proceed then
					plot.active = true
					self.data.pressed = true;
				end
			end
		end

		if not mouse.held and self.data.pressed then
			self.data.pressed = false
		end
	end
end

function ingame:draw()
	cls(12)
	map(self.data.cam.x, 0)

	for plot in all(self.data.plots) do
		plot:draw(self.data.cam.x)
	end

	?pad(self.data.coins, 7) .. "c", 1, 1, 7

	spr(16, 1, 8)
	?self.data.level .. ":" .. pad(flr((self.data.xp / self.data.nxp) * 100), 3) .. "%", 9, 8, 7

	if self.data.inv_id == nil then
		?"holding nothing", 1, 16, 7
	else
		local item = self.data.inv[self.data.inv_id]
		?"holding " .. item.name .. " (x" .. item.count .. ")", 1, 20, 7
	end

	?"cycle ⬆️/⬇️", 1, 27, 6
end