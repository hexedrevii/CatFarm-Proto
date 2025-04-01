shop = {
	is_active = false,

	buttons = {}
}

function shop:open()
	for b in all(self.buttons) do
		if b.id != nil then
			b.disabled = plants[b.id].lvl > ingame.data.level
		end
	end

	self.is_active = true
end

function shop:init()
	local colours = { normal = 7, hover = 10 }

	add(self.buttons, button.new(
		"close", colours,
		13, 0.7, 0, 0,
		function()
			self.is_active = false
		end
	))

	local oy = 0
	for plant in all(plants) do
		local title = plant.name .. ": " .. plant.cst .. "c" .. " (" .. plant.ret .. "c sell)\n" .. plant.time .. "s growth"
		if plant.lvl > 1 then
			title = title .. " (lvl " .. plant.lvl .. "+)     "
		else
			title = title .. "     "
		end

		local btn = button.new(
			title, colours,
			0.5, 2, 0, oy,
			function()
				if ingame.data.coins < plant.cst then
					return
				end

				ingame.data.coins -= plant.cst

				-- loop inventory to check
				local itm = nil
				for item in all(ingame.data.inv) do
					if item.name == plant.name then
						itm = item
						break
					end
				end

				if itm == nil then
					add(ingame.data.inv, item.new(plant.name, 1, plant.id))
				else
					itm.count += 1
				end
			end, true
		)

		btn.id = plant.id

		if ingame.data.level < plant.lvl then
			btn.disabled = true
		end

		add(self.buttons, btn)
		oy += 16
	end
end

function shop:update()
	if not self.is_active then
		return
	end

	for b in all(self.buttons) do
		b:update(0)
	end
end

function shop:draw()
	if not self.is_active then
		return
	end

	-- bg
	rectfill(1, 1, 126, 126, 1)
	rect(1, 1, 126, 126, 13)
	line(1, 13, 126, 13, 13)

	-- title
	?"the shop", 5, 5, 14

	-- bottom
	?"lvl: " .. ingame.data.level, 3, 114, 6
	?"purse: " .. ingame.data.coins .. "c", 3, 120, 6

	for b in all(self.buttons) do
		b:draw(0)
	end
end