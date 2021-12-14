require 'pry'
require 'pp'
a=File.open("inputday8-1").read.chars.map(&:to_i)
c=Array.new

(a.length/(25*6)).times do |offset|
  c[offset]=Array.new
  6.times do |y|
    25.times do |x|
      c[offset][y*25+x] = a[offset*25*6+25*y+x]
    end
  end
end
d=Array.new
(25*6).times do |x|
  e=c.collect{|y| y[x]}
  if e[0] == 0 or e[0] == 1
    d[x] = e[0]
    next
  else
    e.reverse.each do |f|
      d[x] = case f
             when 0
               0
             when 1
               1
             when 2
               d[x]
             end
    end
  end
end
d.each_slice(25) {|x| pp x}  
