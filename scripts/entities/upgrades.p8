upg = {
	is_active = false,
	col = {x=0,y=0,w=0,h=0},

	per_page = 6,
	page = 1,
	pages = {},

	buttons = {}
}

function upg:create_upgrade(upgrade, colours, oy)
	local title = upgrade.name .. ": " .. upgrade.cost .. "c" .. " (lvl " .. upgrade.lvl .. "+)\n- " .. upgrade.desc

	local btn = button.new(
		title, colours, 0.5, 2, 0, oy,
		function(sf)
			if ingame.data.coins < upgrade.cost then
				return
			end

			ingame.data.coins -= upgrade.cost

			upgrade.reward()
			sf.bought = true
			sf.disabled = true
			sf.text = "*got! " .. sf.text
		end, true
	)

	btn.id = upgrade.id
	if ingame.data.level < upgrade.lvl then
		btn.disabled = true
	end

	return btn
end

function upg:open()
	-- if any plot is active bail
	for plot in all(ingame.data.plots) do
		if plot.active then
			return
		end
	end

	for page in all(self.pages) do
		for b in all(page) do
			if b.bought != nil then
				b.disabled = true
				goto continue
			end

			if b.id != nil then
				b.disabled = upgrades[b.id].lvl > ingame.data.level
			end
			::continue::
		end
	end

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

	local pg = {}
	local count = 1

	local oy = 0
	for upgrade in all(upgrades) do
		local btn = self:create_upgrade(upgrade, colours, oy)
		add(pg, btn)

		oy += 16

		if count == self.per_page then
			add(self.pages, pg)
			oy = 0
			count = 0
			pg = {}
		end

		count += 1
	end

	add(self.pages, pg)
end

function upg:update()
	self.col = {
 		x = (320 - ingame.data.cam.x * 9), y = 90,
		w = (70 - ingame.data.cam.x), h = 20
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
		if b.id != nil then
			if b.id == 69 then
				b.disabled = self.page == 1
			elseif b.id == 70 then
				b.disabled = self.page == #self.pages
			end
		end

		b:update(0)
	end

	for b in all(self.pages[self.page]) do
		b:update(0)
	end
end

function upg:draw()
	--rect(self.col.x, self.col.y, self.col.x + self.col.w, self.col.y + self.col.h)

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

	local total = self.page .. "/" .. #self.pages
	?total, 126 - #total * 4  - 15, 120, 7
	for b in all(self.pages[self.page]) do
		b:draw(0)
	end
end