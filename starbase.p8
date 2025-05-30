pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- deep space one
-- by hugh :)

function _init()
	tsz=8 --tile size
	cx=7*tsz cy=7*tsz --reticle
	nodes={}
	
	node.create(8*tsz+1,8*tsz+1,true)
end

function _update()
 if btn(➡️) then cx+=1 end
 if btn(⬅️) then cx-=1 end
	if btn(⬇️) then cy+=1 end
	if btn(⬆️) then cy-=1 end
 if btnp(❎) then
  if node.empty(cx+1,cy+1) then
	  node.create(cx+1,cy+1)
	 end
 end
 for n in all(nodes) do
 	node.update(n)
 end
end

function _draw()
 cls(1)
	rect(cx,cy,
						cx+tsz+1,cy+tsz+1,7)
	for i=1,#nodes do
	 node.draw(nodes[i])
	 for j=i,#nodes do
	  if node.near(nodes[i],nodes[j],40) then
	  	line(nodes[i].x,nodes[i].y,
	  	     nodes[j].x,nodes[j].y,
	  	     6)
	  end
	 end
	end
end




-->8
-- node

node={}

node.create=function(_x,_y,_p)
 if _p==nil then _p=false end
	local n={x=_x,y=_y,sp=1,pwr=_p}
	add(nodes,n)
end

node.update=function(n)
	if n.pwr then n.sp=2 else n.sp=1 end
end

node.draw=function(n)
 spr(n.sp,n.x,n.y)
end

node.empty=function(_x,_y)
	for n in all(nodes) do
		if overlap(n,{x=_x,y=_y}) then
			return false
		end
	end
	return true
end

node.near=function(n1,n2,d)
	local dx=abs(n2.x-n1.x)
	local dy=abs(n2.y-n1.y)
	return dx<d
	   and dy<d
	   and (dx^2+dy^2)<d^2
end

--todo: centre node line coords
--      and elaborate line draw
--todo: nodes as lookup table?
--don't want to always iterate
-- also wtf is local again?

-->8
-- utils

function overlap(a,b)
	return a.x<b.x+tsz
	   and a.x+tsz>b.x
	   and a.y<b.y+tsz
	   and a.y+tsz>b.y
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000066000000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000066660000aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000066666600aaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000066666600aaaaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000066660000aaaa0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000066000000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
