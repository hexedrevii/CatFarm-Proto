mkupg=constructor"id,name,desc,lvl,cost"

upgrades = {
	mkupg"1,growth,plants grow 15% faster,1,750",
	mkupg"2,portable shop,buy from anywhere!,2,1050",
}

upgrades[1].reward = function()
	ingame.data.growth_mlt = 0.85
end

upgrades[2].reward = function()
end