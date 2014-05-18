require 'class'

Point = class(function(pt,x,y)
   pt:set(x,y)
 end)

local function eq(x,y)
  return x == y
end

function Point.__eq(p1,p2)
  return eq(p1[1],p2[1]) and eq(p1[2],p2[2])
end

function Point.get(p)
  return p[1],p[2]
end

function Point.copy(p)
   return Point(Point.get(p)) 
end    

-- vector addition is '+','-'
function Point.__add(p1,p2)
  return Point(p1[1]+p2[1], p1[2]+p2[2])
end

function Point.__sub(p1,p2)
  return Point(p1[1]-p2[1], p1[2]-p2[2])
end

-- unitary minus  (e.g in the expression f(-p))
function Point.__unm(p)
  return Point(-p[1], -p[2])
end

-- scalar multiplication and division is '*' and '/' respectively
function Point.__mul(s,p)
  return Point( s*p[1], s*p[2])
end

function Point.__div(p,s)
  return Point( p[1]/s, p[2]/s)
end

-- dot product is '..'
function Point.__concat(p1,p2)
  return p1[1]*p2[1] + p1[2]*p2[2]
end

function Point.normalize(p)
  local l = p:len()
  p[1] = p[1]/l
  p[2] = p[2]/l
end

function Point.set(pt,x,y)
  if type(x) == 'table' and getmetatable(x) == Point then
     local po = x
     x = po[1]
     y = po[2]
  end
  pt[1] = x
  pt[2] = y
end

function Point.translate(pt,x,y)
   pt[1] = pt[1] + x
   pt[2] = pt[2] + y
end

function Point.__tostring(p)
  return string.format('(%f,%f)',p[1],p[2])
end

local function sqr(x) return x*x end

function Point.len(p)
  return math.sqrt(sqr(p[1]) + sqr(p[2]))
end