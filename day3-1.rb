require 'pp'
require 'pry'
require 'benchmark'

time=Benchmark.realtime do

a=File.open("inputday3-1").readlines.map {|x| x.split(",").map {|y| [y[0],y[1..-1].to_i]}}

first=[[0,0]]
second=[[0,0]]

def walk(a,b)
  a.length.times do |x|
    case a[x][0]
    when "R"
      a[x][1].times do 
        b.push([b[-1][0]+1,b[-1][1]])
      end
    when "U"
      a[x][1].times do 
        b.push([b[-1][0],b[-1][1]+1])
      end
    when "D"
      a[x][1].times do 
        b.push([b[-1][0],b[-1][1]-1])
      end
    when "L"
      a[x][1].times do 
        b.push([b[-1][0]-1,b[-1][1]])
      end
    end
  end
end

walk(a[0],first)
walk(a[1],second)

pp (first&second).map{|x| x[0].abs + x[1].abs}.sort[1]
end
pp time
