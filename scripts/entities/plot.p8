plot = {}
plot.__index = plot;

function plot.new(x, y)
	return setmetatable({
		x = x, y = y,
	}, plot)
end