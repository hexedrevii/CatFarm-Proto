function init()
	-- enable mouse
	poke(0x5f2d, 1)

	world:set(ingame)
end

function update()
	mouse:update()

	world:update()
end

function draw()
	world:draw()

	mouse:draw()
end