plot = {}
plot.__index = plot;

function plot.new(x, y)
	local p = {
		x = x, y = y,
		active = false,
		state = "empty",
		harvest = nil,
		buttons = {},

		growth = {
			id = 0,
			time = 0,
			mtime = 0,
			sp = 0,

			mv = true
		}
	}

	local colours = { normal = 7, hover = 10 }

	p.harvest = button.new("harvest", colours, p.x, p.y, -8, -17, function()
		local plant = plants[p.growth.id]
		ingame.data.coins += plant.ret

		ingame.data.xp += plant.exp

		-- incase we level up
		while ingame.data.xp >= ingame.data.nxp do
			ingame:handle_xp()
		end

		p.state = "empty"
	end)

	add(p.buttons, button.new("plant", colours, p.x, p.y, -20, -5, function()
		if p.state != "empty" then
			return
		end

		if ingame.data.inv_id == nil then
			return
		end

		local item = ingame.data.inv[ingame.data.inv_id]
		local plant = plants[item.id]

		item.count -= 1
		if item.count <= 0 then
			del(ingame.data.inv, item)
			ingame.data.inv_id = nil
		end

		p.growth.id = item.id
		p.growth.time = 0
		p.growth.mtime = plant.time
		p.growth.sp = plant.mip

		p.growth.mv = true

		p.state = "growing"
	end))

	add(p.buttons, button.new("cancel", colours, p.x, p.y, 10, -5, function() p.active = false end))

	return setmetatable(p, plot)
end

function plot:update(cam)
	if self.active then
		for b in all(self.buttons) do
			b:update(cam);
		end
	end

	if self.state == "growing" then
		local data = self.growth

		data.time += dt

		-- switch sprite
		if data.mv and data.time >= data.mtime / 2 then
			data.sp += 1
			data.mv = false
		end

		if data.time >= data.mtime then
			data.time = data.mtime
			self.state = "ready"
			data.sp = plants[data.id].mxp
		end
	end

	if self.state == "ready" then
		self.harvest:update(cam)
	end
end

function plot:draw(cam)
	if self.active then
		for b in all(self.buttons) do
			b:draw(cam);
		end

		local tx = (((self.x - cam) * 8) + 4) - ((#self.state * 4) / 2)
		?self.state, tx, self.y * 8 + 15, 7

		if self.state == "growing" then
			local percent = flr((self.growth.time / self.growth.mtime) * 100)
			local time = percent .. "%"

			local tx = (((self.x - cam) * 8) + 4) - ((#time * 4) / 2)
			?time, tx, self.y * 8 + 21, 7
		end

		if self.state == "ready" then
			self.harvest:draw(cam)
		end
	end

	if self.state == "ready" then
		spr(53, (self.x - cam) * 8, self.y * 8 - 10)
	end

	if self.state != "empty" then
		spr(self.growth.sp, (self.x - cam) * 8, self.y * 8)
	end
end