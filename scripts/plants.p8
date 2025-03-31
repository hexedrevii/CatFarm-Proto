-- from miss mouse in pico8 discord
function constructor(fields)
	fields = split(fields)
	return function(vals)
		if (type(vals) == "string") vals = split(vals)
		local res = {} for i,k in inext,fields do res[k] = vals[i] end return res
	end
end

mkplant = constructor"name,time,mip,mxp,cst,ret,exp"

plants = {
	mkplant"wheat,5,55,57,0,1,1",
	mkplant"carrot,15,58,60,5,10,5"
}