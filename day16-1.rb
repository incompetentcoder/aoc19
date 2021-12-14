require 'pry'
require 'benchmark'
time=Benchmark.realtime do
a=File.open("inputday16-1").read.chars.map(&:to_i)
pattern=[0,1,0,-1]
patterns=[]
proper = a.clone
proper2 = [0]*a.length
a.length.times do |x|
  tmp = pattern.map {|y| [y]*(x+1)}.flatten
  tmp = (tmp*((a.length/tmp.length)+1))[1..a.length].each_with_index.filter {|y,z| y!=0}
  patterns.push(tmp)
end

100.times do
  proper2.fill(0)
  patterns.each_with_index do |x,y|
    x.each do |z|
      proper2[y]+=(proper[z[1]]*z[0])
    end
    proper2[y] = proper2[y].abs % 10
  end
  proper=proper2.clone
#  binding.pry
end

binding.pry
pp proper.first(8).to_a
end
pp time

