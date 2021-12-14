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











