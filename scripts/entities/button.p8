button = {}
button.__index = button;

function button.new(text, colours, x, y, ox, oy, click, dbl)
	dbl = dbl or false

	local h = 6
	if dbl then
		h = 12
	end

	return setmetatable({
		text = text, colours = colours,
		x = x, y = y, ox = ox, oy = oy,
		w = #text * 4, h = h,
		colour = colours.normal,

		click = click,
		pressed = false,
		disabled = false,
	}, button);
end

function button:update(cam)
	if self.disabled then
		self.colour = 5
		return
	end

	if pr(
		{x = (self.x - cam) * 8 + self.ox, y = self.y * 8 + self.oy, w = self.w, h = self.h},
		mouse.x, mouse.y
	) then
		self.colour = self.colours.hover

		if mouse.held and not self.pressed then
			self.pressed = true;
		end

		if not mouse.held and self.pressed then
			self.click(self)
			self.pressed = false
		end
	else
		self.colour = self.colours.normal
		self.pressed = false
	end
end

function button:draw(cam)
	?self.text, (self.x - cam) * 8 + self.ox, self.y * 8 + self.oy, self.colour
end