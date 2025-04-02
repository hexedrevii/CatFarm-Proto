-- from miss mouse in pico8 discord
function constructor(fields)
	fields = split(fields)
	return function(vals)
		if (type(vals) == "string") vals = split(vals)
		local res = {} for i,k in inext,fields do res[k] = vals[i] end return res
	end
end

mkplant = constructor"id,name,time,mip,mxp,cst,ret,exp,lvl"

plants = {
	mkplant"1,wheat,5,55,57,0,1,1,1",
	mkplant"2,carrot,15,58,60,5,7,5,2",
	mkplant"3,cabbage,35,61,62,20,25,10,2"
}
