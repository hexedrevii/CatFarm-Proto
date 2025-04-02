ingame = {
	data = nil
}

-- We declare all data here
-- Since it means it resets every time.
function ingame:init()
	self.data = {
		scale = 3,

		coins = 0,

		xp = 0,
		nxp = 10,
		level = 1,

		gap = 1.3,
		inc = 0.15,

		cam = {
			x = 0,
			speed = 1,

			bounds = {
				left = 0,
				right = 13,
			}
		},

		pressed = false,

		plots = {},

		inv_id = 1,
		inv = {},
	}

	add(self.data.inv, item.new(plants[1].name, 1, 1))

	-- loop through the entire map.
	for x = 0, 128 do
		for y = 0, 64 do
			-- plot
			if mget(x, y) == 54 then
				add(self.data.plots, plot.new(x, y))
			end
		end
	end

	shop:init()
	inventory:init()
end

function ingame:draw_shop()
	local scale = self.data.scale
  local x, y = (0 - self.data.cam.x * 3), 56
  local tile_size = 8

  for i=0,1 do
    for j=0,1 do
      local tile = 224 + i * 16 + j
      local sx = (tile % 16) * tile_size
      local sy = (tile \ 16) * tile_size

      sspr(
				sx, sy,
				tile_size, tile_size,
				(x + j * tile_size) * scale, y + i * tile_size * scale,
				tile_size * scale, tile_size * scale
			)
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

	local shop_col = {
		x = (15 - self.data.cam.x * 9), y = 90,
		w = (33 - self.data.cam.x * 9), h = 100
	}

	if pr(shop_col, mouse.x, mouse.y) then
		if mouse.held then
			shop:open()
		end
	end

	shop:update()

	if shop.is_active then
		return
	end

	if btnp(❎) then
		inventory:open()
	end

	inventory:update()

	if inventory.is_active then
		return
	end

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

	if #data.inv > 0 then
		if btnp(⬆️) then
			data.inv_id = (data.inv_id and data.inv_id - 1 or #data.inv)
			if data.inv_id < 1 then
					data.inv_id = #data.inv
			end
			elseif btnp(⬇️) then
				data.inv_id = (data.inv_id and data.inv_id + 1 or 1)
			if data.inv_id > #data.inv then
					data.inv_id = 1
			end
		end
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

	-- mountains
	map(0, 16, 120 - (self.data.cam.x * 0.4), 60, 18, 10)
	map(0, 16, -1 - (self.data.cam.x * 0.4), 60, 18, 10)

	-- clouds
	map(0, 23, -160 - self.data.cam.x * 0.8, 20, 21, 10)
	map(0, 23, -self.data.cam.x * 0.8, 20, 21, 10)
	map(0, 23, 150 - self.data.cam.x * 0.8, 20, 21, 10)

	map(self.data.cam.x, 0)

	for plot in all(self.data.plots) do
		plot:draw(self.data.cam.x)
	end

	local coins = pad(self.data.coins, 7) .. "c"
	local level = self.data.level .. ":" .. pad(flr((self.data.xp / self.data.nxp) * 100), 3) .. "%"

	-- bg
	rectfill(2, 2, #level * 4 + 10, 15, 4)
	rect(1, 1, #level * 4 + 11, 16, 5)

	-- coins
	?coins, 3, 3, 7

	-- level
	spr(16, 3, 10)
	?level, 11, 10, 7

	-- iventory
	if self.data.inv_id == nil then
		?"holding nothing", 1, 20, 7
	else
		local item = self.data.inv[self.data.inv_id]
		?"holding " .. item.name .. " (x" .. item.count .. ")", 1, 20, 7
	end

	?"cycle ⬆️/⬇️, ❎ open", 1, 27, 6

	self:draw_shop()
	spr(242, 20 - self.data.cam.x * 8, 90)
	?"shop", 16 - self.data.cam.x * 9, 80, 7

	shop:draw()
	inventory:draw()
end