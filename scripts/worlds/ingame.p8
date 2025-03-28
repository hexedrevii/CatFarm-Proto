ingame = {
	data = nil
}

-- We declare all data here
-- Since it means it resets every time.
function ingame:init()
	self.data = {

	}
end

function ingame:update()
end

function ingame:draw()
	cls(12)
	map(0, 0)
end