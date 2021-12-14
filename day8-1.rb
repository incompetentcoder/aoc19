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
d=c.sort_by{|x| x.count(0)}.first
pp d.count(1)*d.count(2)
