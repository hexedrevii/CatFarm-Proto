item = {}
item.__index = item

function item.new(name, count, id)
	return setmetatable({
		name = name,
		count = count,
		id = id
	}, item)
end