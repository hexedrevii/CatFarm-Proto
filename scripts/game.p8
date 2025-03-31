dt = 0

function init()
	-- enable mouse
	poke(0x5f2d, 1)

	world:set(ingame)
end

function update()
	-- update mouse first
	mouse:update()

	world:update()

	dt = 1 / stat(7)
end

function draw()
	world:draw()

	-- draw mouse on top of everything
	mouse:draw()
end