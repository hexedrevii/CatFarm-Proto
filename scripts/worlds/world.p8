world = {
	current = nil
}

function world:set(new)
	new:init()
	self.current = new;
end

function world:update()
	if self.current != nil then
		self.current:update();
	end
end

function world:draw()
	if self.current != nil then
		self.current:draw();
	end
end