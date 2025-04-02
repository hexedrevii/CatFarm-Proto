inventory = {
	is_active = false,

	buttons = {},

	per_page = 30,
	per_row = 15,
	page = 1,
	pages = {}
}

function inventory:open()
	-- reset pages
	self.pages = {}

	local oy = 15
	local ox = 3
	local count = 1
	local pg = {}
	for item in all(ingame.data.inv) do
		local entry = {
			text = item.name .. " x" .. item.count,
			y = oy, x = ox
		}

		add(pg, entry)

		if count == self.per_row then
			oy = 8
			ox = 60
		end

		if count == self.per_page then
			add(self.pages, pg)

			pg = {}
			count = 0
			oy = 8
			ox = 3
		end

		oy += 7
		count += 1
	end

	add(self.pages, pg)

	self.is_active = true
end

function inventory:init()
	local colours = { normal = 7, hover = 10 }
	add(self.buttons, button.new(
		"close", colours,
		13, 0.7, 0, 0,
		function()
			self.is_active = false
		end
	))

	local back = button.new(
		"<", colours,
		14, 15, 0, 0,
		function()
			self.page -= 1
			if self.page <= 1 then
				self.page = 1
			end
		end
	)

	back.id = 69

	add(self.buttons, back)

	local nxt = button.new(
		">", colours,
		15, 15, 0, 0,
		function()
			self.page += 1
			if self.page >= #self.pages then
				self.page = #self.pages
			end
		end
	)

	nxt.id = 70

	add(self.buttons, nxt)
end

function inventory:update()
	if btnp(❎) then
		self:open()
	end

	if not self.is_active then
		return
	end

	for b in all(self.buttons) do
		if b.id != nil then
			if b.id == 69 then
				b.disabled = self.page == 1
			elseif b.id == 70 then
				b.disabled = self.page == #self.pages
			end
		end

		b:update(0)
	end
end

function inventory:draw()
	if not self.is_active then
		return
	end

	-- bg
	rectfill(1, 1, 126, 126, 1)
	rect(1, 1, 126, 126, 13)
	line(1, 13, 126, 13, 13)

	-- title
	?"inventory", 5, 5, 14

	for b in all(self.buttons) do
		b:draw(0)
	end

	local total = self.page .. "/" .. #self.pages
	?total, 126 - #total * 4  - 15, 120, 7
	for entry in all(self.pages[self.page]) do
		?entry.text, entry.x, entry.y, 7
	end
end