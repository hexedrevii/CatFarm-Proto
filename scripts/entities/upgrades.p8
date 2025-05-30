upg = {
	is_active = false,
	col = {x=0,y=0,w=0,h=0},

	buttons = {}
}

function upg:open()
	self.is_active = true
end

function upg:init()
	local colours = { normal = 7, hover = 10 }

	add(self.buttons, button.new(
		"close", colours,
		13, 0.7, 0, 0,
		function()
			self.is_active = false
		end
	))
end

function upg:update()
	self.col = {
 		x = (440 - ingame.data.cam.x * 9), y = 90,
		w = (80 - ingame.data.cam.x), h = 20
	}

	if pr(self.col, mouse.x, mouse.y) then
		if mouse.held then
			self:open()
		end
	end

	if not self.is_active then
		return
	end

	for b in all(self.buttons) do
		b:update(0)
	end
end

function upg:draw()
	-- rect(self.col.x, self.col.y, self.col.x + self.col.w, self.col.y + self.col.h)

	if not self.is_active then
		return
	end

	-- bg
	rectfill(1, 1, 126, 126, 1)
	rect(1, 1, 126, 126, 13)
	line(1, 13, 126, 13, 13)

	-- title
	?"upgrades", 5, 5, 14

	-- bottom
	?"lvl: " .. ingame.data.level, 3, 114, 6
	?"purse: " .. ingame.data.coins .. "c", 3, 120, 6

	for b in all(self.buttons) do
		b:draw(0)
	end
end