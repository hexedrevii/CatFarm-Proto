function move_towards(from,to,delta)if abs(to-from)<=delta then;return to;end;return from+sgn(to-from)*delta;end
function roll(max)return flr(rnd(max))+1;end
function rand_all_float(min,max)return rnd(max-min)+min;end
function rand_all(min,max)return flr(rnd(max-min))+min;end

function is_tile(x,y,flag)return fget(mget(x\8,y\8))==flag;end
function is_tile_rect(x, y, w, h, flag)return is_tile(x,y,flag) or is_tile(x + w, y, flag)or is_tile(x + w, y + h, flag) or is_tile(x, y + h, flag);end
function m(t)return(128-(#t*4))/2end

function pr(rect,px,py)return px>=rect.x and px<rect.x+rect.w and py>=rect.y and py<rect.y+rect.h end