pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- deep space one
-- by hugh :)


--todo: node selection ui
--todo: scroll camera/level
--todo: fix pwr algo

--also wtf is local again?


function _init()
	tsz=8 --tile size
	--player control
	c={x=7*tsz,y=7*tsz,ctr={x,y}}
	c.ctr=centre(c.x,c.y)

	nodes={}
	
	local n=node.create(8*tsz+1,8*tsz+1,true)
	add(nodes,n)
end

function _update()
 if btn(➡️) then c.x+=1 end
 if btn(⬅️) then c.x-=1 end
	if btn(⬇️) then c.y+=1 end
	if btn(⬆️) then c.y-=1 end
	c.ctr=centre(c.x,c.y)
	
 if btnp(❎) then
  if not node.get(c.x+1,c.y+1) then
	  local n=shtr.create(c.x+1,c.y+1)
	  add(nodes,n)
	 end
 end
 if btnp(🅾️) then
  n=node.get(c.x+1,c.y+1)
  if n then node.destroy(n) end
 end
 for n in all(nodes) do
 	node.update(n)
 end
end

function _draw()
 cls(0)
 spr(1,c.x+1,c.y+1)
	rect(c.x,c.y,
						c.x+tsz+1,c.y+tsz+1,7)
	--circ((c.x+tsz/2)+1,(c.y+tsz/2)+1,rad-3,7)
	for i=1,#nodes do
	 if nodes[i].class=="shtr" then
	  shtr.draw(nodes[i])
	 else
 	 node.draw(nodes[i])
 	end
	 
	 --neighbour preview
	 if #nodes[i].nbr<4 then
 	 if node.near(c,nodes[i],rad+1) then
	   line(c.ctr.x,c.ctr.y,nodes[i].ctr.x,nodes[i].ctr.y,11)
	  elseif node.near(c,nodes[i],rad+5) then
	   line(c.ctr.x,c.ctr.y,nodes[i].ctr.x,nodes[i].ctr.y,8)
	  end
	 end
	end
end



-->8
-- node

node={}

nid=0
rad=20

node.create=function(_x,_y,_p)
 if _p==nil then _p=false end
	local n={id=nid,
	 x=_x,y=_y,sp=1,pwr=_p,
		ctr=centre(_x,_y),
		nbr={},
		class="base"
	}
	--detect neighbours
	local nears={}
	for i=1,#nodes do
	 if node.near(n,nodes[i],rad+1) then
	  --register closest first
	  for j=1,#nears do
	   if dist(n,nodes[i]) > dist(n,nears[j]) then
	    break
	   end
	  end
	  add(nears, nodes[i], j)
	 end
	end
	for i=1,#nears do --sorted
	 if #n.nbr<4 and #nears[i].nbr<4 then
	  --set pointers
	  add(n.nbr, nears[i])
   add(nears[i].nbr, n)
   if n.pwr then
    nears[i].pwr=true
   end
   if nears[i].pwr then
    n.pwr=true
   end
	 end
	end
	nid+=1 --todo: fix overflow
	return n
end

node.destroy=function(n)
 for i=1,#nodes do
 	if nodes[i].id==n.id then
 	 --unlink neighbours
 	 for n2 in all(nodes[i].nbr) do
 	  del(n2.nbr,nodes[i])
 	 end
 	 deli(nodes,i)
 	 return true
 	end
 end
 return false
end

node.update=function(n)
	if n.pwr then n.sp=2 else n.sp=1 end
end

node.draw=function(n)
 for n2 in all(n.nbr) do
  if n.id<n2.id then
   line(n.ctr.x,n.ctr.y,
        n2.ctr.x,n2.ctr.y,
 	   	  (n.pwr and n2.pwr)
 	   	   and 3 or 6) 
 	end
 end
 spr(n.sp,n.x,n.y) --on top 
end

node.get=function(_x,_y)
	for n in all(nodes) do
		if overlap(n,{x=_x,y=_y}) then
			return n
		end
	end
	return nil
end

node.near=function(n1,n2,d)
	local dx=abs(n2.ctr.x-n1.ctr.x)
	local dy=abs(n2.ctr.y-n1.ctr.y)
	return dx<d
	   and dy<d
	   and (dx^2+dy^2)<d^2
end

-->8
-- utils

function overlap(a,b)
	return a.x<b.x+tsz
	   and a.x+tsz>b.x
	   and a.y<b.y+tsz
	   and a.y+tsz>b.y
end

function centre(_x,_y)
 local ctr={}
 ctr.x=_x+tsz/2
 ctr.y=_y+tsz/2
 return ctr
end

function dist(n1,n2)
 return sqrt(sqr(n1.x-n2.x)+sqr(n1.y-n2.y))
end

function sqr(x) return x*x end
-->8
-- shooter

-- todo: write rotation
--       and shooting

shtr={}

shtr.create=function(_x,_y,_p)
 local n=node.create(_x,_y,_p)
 n.class="shtr"
 return n
end

--dont need to wrap destroy?

shtr.draw=function(n)
 node.draw(n)
 spr(4,n.x,n.y) --a rose
end

__gfx__
00000000000000000000000000e00000008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000330000e8ee080082222800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000660000033330000e8e8ee828828280000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000666600033333300ee8a8e0882288880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000666600033333300eea8e00888828880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000006600000333300eeeeee00888882880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000003300000e0eee0088882800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000e00008882000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
