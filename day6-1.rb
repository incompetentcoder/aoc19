require 'pp'
a=File.open("inputday6-1").read.split("\n").map{|x| x.split(")").reverse}.to_h

count=0
a.keys.each do |y|
  meh=y
  count+=1
  while a[meh] != "COM" do
    count+=1
    meh = a[meh]
  end
end
pp count

