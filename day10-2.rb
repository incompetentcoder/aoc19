require 'pry'

a=File.open("inputday10-1").read.chars
length=a.find_index("\n")
a.delete("\n")
height=a.length/length
asteroids=[]
visible=Hash.new
a.each_with_index {|x,y| asteroids.push([y%length+0.5,y/length+0.5]) if x == "#"}
asteroids.each do |x|
  visible[x]=Hash.new
  (asteroids - [x]).each do |y|
    angle=Math.atan2(y[1]-x[1],y[0]-x[0])
    if visible[x][angle]
      next
    end
    visible[x][angle]=x
  end
end
tmp = visible.sort_by {|x,y| y.keys.length}.last
pp tmp[0],tmp[1].keys.length

laser=tmp[0]
hit = 0
boomed = []
sorted = Hash.new
(asteroids - [laser]).each do |x|
  angle=Math.atan2(x[1]-laser[1],x[0]-laser[0])
  distance=(((x[0]-laser[0]).abs)**2 + ((x[1]-laser[1]).abs)**2)**0.5
  sorted[angle]=[] unless sorted[angle]
  sorted[angle].push([distance,x])
end
sorted.keys {|x| sorted[x].sort.reverse!}
angles=sorted.keys.sort
alen=angles.length
start=angles.find_index(-1.5707963267948966)
idx=start
while hit < 200
  if sorted[angles[idx]]
    hit+=1
    boomed.push([sorted[angles[idx]].pop,hit])
  end

  idx+=1
  if idx > alen
    idx = 0
  end
end
pp (boomed[199][0][1][0]-0.5)*100 + boomed[199][0][1][1]-0.5










