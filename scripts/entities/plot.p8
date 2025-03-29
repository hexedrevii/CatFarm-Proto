plot = {}
plot.__index = plot;

function plot.new(x, y)
	local p = {
		x = x, y = y,
		active = false,
		state = "empty",
		buttons = {}
	}

	local colours = { normal = 7, hover = 10 }

	add(p.buttons, button.new("plant", colours, p.x, p.y, -20, -5, function()
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
end

function plot:draw(cam)
	if self.active then
		for b in all(self.buttons) do
			b:draw(cam);
		end

		local tx = (((self.x - cam) * 8) + 4) - ((#self.state * 4) / 2)
		?self.state, tx, self.y * 8 + 15, 7
	end
end