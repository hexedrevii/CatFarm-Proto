function init()
	-- enable mouse
	poke(0x5f2d, 1)
end

function update()
	mouse:update();
end

function draw()
	cls(12)
	mouse:draw()
end